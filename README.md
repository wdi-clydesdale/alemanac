#Alemanac

##A Beer Journaling app

###Created by David Hayes & Kate Shirley

Version: 1.0
Completed: August 6, 2015

## Description

Alemanac allows a user to search for beer information by style, keyword, or alcohol content (%ABV range). Users may create an account and journal (save) data about a beer, such as where they drank it and what characteristics they noted. Beer information can be entered from the search results page or entered manually.

![Search Page](https://raw.githubusercontent.com/wdi-clydesdale/alemanac/master/Public/images/screen-search.png)
![Journal Page](https://raw.githubusercontent.com/wdi-clydesdale/alemanac/master/Public/images/screen-journal.png)

## Beer Data

Alemanac uses an RESTful web API provided by BreweryDB.com which contains over 46,700 beer entries, as well as data on breweries and events.  Alemanac uses the following data fields from the API: name, styleId, glass, label url, ABV. Other fields, such as ingredients, and serving temperature were available, but not implemented in Alemanac. Not every field is populated for every record. As the API is crowdsourced, the data is subject not only to missing information, but bias and error. The data is provided as a hash with subhashes. For example, the 'style' subhash for every beer includes it's id, Category id, name, and create Date, i.e., information best referenced in a separate table.

Data returned by the BreweryDB API is separated into pages containing 50 entries each. While the total number of results, number of pages, and current page is given at the top of returned data, the only way to access other pages of returned results is to specify the page number.

The BreweryDB API search function searches for terms through the data object. There is no feature to limit the search to a particular key, such as style. Also, as demonstrated on the API Explorer at BreweryDB.com, multiple search terms return a result set that is the combination of each results as if each term were searched for separately. For simplicity, Alemanac recognizes only the first word in the search field. Any space effectively terminates the search input.

## Implementation Challenges

###BreweryDB

Alemanac connects to the BreweryDB API using the Ruby gem HTTParty. The parameters passed by Alemanac may include a search term, an ABV minimum value, an ABV maximum value, and a style ID.

```ruby
#search API for beers with the chosen styleId. We require a style because we
#don't want to return all 46,000+ beers in the API database.

# Alcohol By Volume search
# api string segment is abv='lo,hi' ,
# abv='-lo' (for lo and below)
# abv='+hi' (for hi and above)
if params[:min_abv] != ''
  abv_range = params[:min_abv].to_s
  if params[:max_abv] != ''
    abv_range = abv_range + ',' + params[:max_abv].to_s
  else
    abv_range = '+' + abv_range
  end
elsif params[:max_abv] != nil
  abv_range = '-' + params[:max_abv].to_s
else
  abv_range = '0,20'
end

#testing output
puts params[:min_abv]
puts params[:max_abv]
puts abv_range

if params[:search_string] == '' || nil
  if params[:styleId] == '' || nil
    search_param = 'beers?abv=' + abv_range
  end if
  search_param = 'beers?styleId=' + params[:styleId].to_s + '?abv=' +  abv_range
else #release the constraints of style and abv if search box is used
  # note: API search ORs multiple words. For sake of rapid deployment, our search will
  # only consider the first word
  search_param = 'search?q=' + params[:search_string].partition(" ").first + '?abv=' +  abv_range
end
puts search_param
@search_results = HTTParty.get('http://api.brewerydb.com/v2/' + search_param + "&key=XXXXXXXXXXXXXXXXX")
```

Data in the returned API hash was not uniformly constructed: not every hash contained all the keys. As a result, each hash had to be examined for the presence of the expected keys:

```ruby
<td id="beer-facts"><h3><%= beer["name"]  %></h3>
    <p>Style:
  <% s = beer.has_key?("style") %>
  <% if s == true %>
    <% t = beer["style"] %>
      <% if t.has_key?("category") %>
      <%= t["category"]["name"] %>
      <% end %>
    <% else %>
      Unknown
    <% end %>
  </p>
```

Alemanac's purpose is to explore beer information and save beer information. Exploration of the beer information is highly dependent on the nature of the data available and the behavior of the API. The availability of the API data offered us the opportunity to create a useful and meaningful application. The characteristics of the API challenged our progress in the following ways:

1. In the interest of greater data management utility, greater interface design freedom, and code simplicity, we considered creating a local database from the API data. And, in fact, a table was created to correlate the styleId and style name. This information is used in the final presentation as user must be presented with the name and the API request parameter must be a style ID. Since the API Explorer readily generates a JSON and online utilities are available to convert JSON to CSV, Microsoft Excel was employed to examine and manipulate the data. Automation with Visual Basic was attempted, but unfamiliarity with OSX file input/output presented an obstacle that motivated semi-manual methods using the power select, search, replace, and tag wrap capabilities of Sublime Text.

2. When a list of beers is requested, only certain parameters can be specified. Style ID is one (there are 170 styles). There are only 11 categories of styles, but Category ID is not an available parameter for the beer information request url. Searching in Alemanac by style seemed to be a very powerful way to search, but the styles have to be presented for the user to choose from. We considered elegant ways to only present relevant style choices to a user --perhaps in response to a style category selection or in response to the provision of a keyword--but the necessary coding seemed to be beyond our time constraints for Version 1.0.

3. Alemanac 1.0 only returns the first page of any list of beers. Depending upon the information entered, there may be hundreds of pages available from the API. A version 2.0 would certainly include a way to click to the next page and even enter a page number to browse.

4. With so many results, it's only natural that a user would want to filter in a number of ways. That capability would be much easier if not just plain possible with SQL. That would require loading it into a database. We opted not to pursue a local database for several reasons, including some cited above.

### CRUD functionality through SQL, ActiveRecord, and Ruby

Besides beer search functionality the other main purpose of this app is to allow users to save, update, and delete entries to a 'beer journal' so the user can track what they've tried and liked. The current user is established through Ruby sessions. When items are added to the EntriesModel the user's foreign key is passed through so that the user can only edit and view their own entries. A potential bug that was discovered with ActiveRecord for Sinatra was we could not effectively display just the current user's entries on the journal page, perhaps because ActiveRecord was not recognizing the reference key for the user's foriegn key within the EntriesModel. This was solved by calling for EntriesModel.all on the journal page, and then running an if/then statement ont he results. Code included below:

```ruby
get '/my_alemanac' do

  if is_not_authenticated? == true
      redirect '/users/login'

  elsif
    @current_user = session[:user]
  end
  @all_entries = EntriesModel.all
  @entries = Array.new
  @all_entries.each do |entry|

    if entry.user_id == @current_user.id
      @entries.push(entry)
    end

  end
  puts @current_user.id
  erb :user_journal
end
```

Editing journal entries is possible by passing hidden input fields on the "Edit" button on the journal page, so that the beer_id is identified and all information about the beer is pre-filled into the editing form. Delete functionality works in nearly the same way, by passing the beer_id through a hidden input field on the button.
Code below:

```ruby
get '/edit_entry/:id' do
  @id = params[:id]
  @entry = EntriesModel.find(@id)

  erb :edit_entry
end

post '/edit' do

  @entry = EntriesModel.find(params[:id])
  @entry.beer_name = params[:beer_name]
  @entry.abv = params[:abv]
  @entry.consume_location = params[:consume_location]
  @entry.vote = params[:vote]
  @entry.notes = params[:notes]
  @entry.save

  erb :entry_edit_success
end

##delete

post '/delete' do
   @id = params[:beer_id]
   @entry = EntriesModel.find(@id)

   puts '---'
   puts params
   puts @entry.beer_name
   puts '---'

   @entry.destroy

   erb :entry_delete_success
  end
end

```

# Project Propoal (originally posted [here](https://github.com/wdi-clydesdale/alemanac/blob/master/BeerProjectScope.md)

Summary: Tentatively named 'Point of Brew', this app will have both beer search functionality and CRUD functionality within a 'beer journal'.

User Flow: Users are first prompted to login, once they've logged in they are taken to a page where than can either choose to search, choose to go to their journal page, or choose to edit/view a beer that they've previously logged. The search functionality will be provided by the Brewery DB API and users will be able to search by a pre-defined set of parameters. The journal functionality will be created using SQL/ActiveRecord and users will be able to save beers that they've tried with notes and ratings.

Technologies:
-Ruby
-SQL
-ActiveRecord
-Bootstrap


Views:

Age Confirmation
login
search/Search Results
myBeers

# Wireframe

![Wireframe of Alemanac](https://raw.githubusercontent.com/wdi-clydesdale/alemanac/master/Draft1AlemanacWireframes.png)

# Alemanac Internal Data

The file alemanac_migrations.sql, also in this repository contains the Postgresql commands used to create our databases. The app uses two models (tables): users and EntriesModel

Users

id | first_name | last_name | username | email | password_salt | password_hash
---|------------|-----------|----------|-------|---------------|--------------
PK | varchar(25) | varchar(25) | varhar(25) | varchar(50) | varchar(255) | varchar(255)

Entries

id | user_id | users | beer_id | notes | vote | consume_location | consume_date | entry_date | is_custom | beer_name | brewery | brew_location | abv
---|---------|-------|---------|-------|------|------------------|--------------|------------|-----------|-----------|---------|---------------|----
PK | FK | integer | text | integer | varchar(100) | varchar(100) | date | boolean | varchar(25) | varchar(25) | varchar(50) | varchar(25) |  real | varchar(255)

## Techonologies Used

*Ruby
*Sinatra framework
*JavaScript
*jQuery
*Bootstrap framework styling HTML
*Postgresql database
*ActiveRecord Object-Relational Mapping facility
*Microsoft Excel
*Microsoft VBA

## Running Alemanac

Alemanac requires Ruby files to run on a server. The Postgresql database named alemanac must also be placed on a server and can be created with alemanac_migrations.sql.

### To run Alemanac:

1.  Clone this repository.
2.  Navigate to the directory it is store in.
3.  Obtain a BreweryDB.com API key and swap it for the existing one in Controllers\HomeController.rb
2.  Create a Postgresql database and copy the alemanac_migrations.sql commands to the postgresql command line.
3.  Run 'bundle' from a terminal command line to install required gems.
4.  From the terminal command line, run 'bundle exec rackup' to start the server.
5.  Open an internet browser and navigate to 'localhost:9292'.

## Pair Programming

One of the objectives of this General Assembly Web Development Immersive project was use Pair Programming, a method of programming where one terminal is used, one developer types in code and the other partner watches and advises, roles usually referred to as driver and navigator. The advantages of this process are educational, collaborational and efficiency. The driver can concentrate on syntax, command entry, and speed. The navigator can think about the larger picture and do quick research when necessary to make progress past hurdles.

In practice, Pair Programming worked well in the earlier stages, through the user stories and model design, file structure and boilerplate set-up. As the complex nature of the chose API was gradually discovered and coding interests became known, it was clear that a parallel approach was the more natural way to go and in the interest of meeting the project requirements within the limited timeframe (5 days). As a result Kate did most of the front-end work and David did most of the back-end work.


## Version 2.0 Wishlist

1. Ability for Users to view other user's journal entries and comment. More generhally, social interaction and sharing.
2. Add label photos from search results to user journal entries (when saved from search results).
3. Allow users to upload label images for their custom entries
4. Add brewery information from API (as available)
5. Investigate other data sources for completeness, capabilities and ease of implementation.
6. Ability to switch and choose pages in displayed results
7. Ability to refine search query
8. When adding a beer from search results, the description would be filled in.
9. Install Alemanac on a hosted server so that it is accessible across the internet.
10. Ability for users to sort through their journals!
11. Hide the API key, which is visible herein, but meant to be kept private.
