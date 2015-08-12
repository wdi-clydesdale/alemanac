class HomeController < ApplicationController

  enable :sessions

  get '/' do
    # The following code, if implemented, will direct the user to
    # the log-in page instead of search
    # if is_not_authenticated? == true
    #     redirect '/users/login'
    # else
    #   erb :index
    # end
    # The following code, if implemented, will pass a parameter to
    # the index page to indicate whether validation is necessary.
    if is_not_authenticated? == true
      @is_not_authenticated = false
    else
      @is_not_authenticated = true
    end
    erb:index
  end

  # It's unwise to use key like this (visible in public repository),
  # but we don't yet know how to hide it

  # @search_string is a word to search the api data for
  # @search_param is the string to send to the api which may include
  # a search string, a style id, an acohol by volume range, or a page number

  post '/' do

    #search API for beers with the chosen styleId. We require a style because we
    #don't want to return all 46,000+ beers in the API database.

    @pg_num = params[:pg_num].to_i || 1

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
    elsif params[:max_abv] != ''
      abv_range = '-' + params[:max_abv].to_s
    else
      abv_range = '0,20'
    end

    #page
    if @pg_num > 0
      page ='&p=' + @pg_num.to_s
    else
      page = ''
    end

    #testing output
    puts params[:min_abv]
    puts params[:max_abv]
    puts abv_range

    if params[:search_param] == "" || nil  #not using existing api parameter text
      if params[:search_string] == '' || nil  #not looking for a term in the api data
        if params[:styleId] == '' || nil  #not using a beer style filter in the api parameter text
          @search_param = 'beers?abv=' + abv_range
        elsif #we ARE using a beer style filter (additionally filtered by some abv range)
          @search_param = 'beers?styleId=' + params[:styleId].to_s + '?abv=' +  abv_range
        end
      else #release the constraints of style and abv if search box is used
        # note: API search ORs multiple words. For sake of rapid deployment, our search will
        # only consider the first word
        @search_param = 'search?q=' + params[:search_string].partition(" ").first + '?abv=' +  abv_range
      end
    elsif  #we're just changing pages for the existing search parameter text
      @search_param = params[:search_param]
    end
    puts @search_param
    puts @pg_num
    puts page
    out1 = 'http://api.brewerydb.com/v2/' + @search_param + page + "&key=fdf1b28c011f27510720ab3070943f3e"
    puts out1

    @search_results = HTTParty.get('http://api.brewerydb.com/v2/' + @search_param + page + "&key=fdf1b28c011f27510720ab3070943f3e")

    #testing output
    # puts @search_results # the data key contains all beer info and is an array
    # {"id"=>"AZI8ib", "name"=>"Indian Brown Ale", "nameDisplay"=>"Indian Brown Ale", "description"=>"Forget about the car companies, this is the original hybrid, a cross between a Scotch Ale, an India Pale Ale, and an American Brown. Our Indian Brown Ale is well-hopped and malty at the same time (magical). The beer has characteristics of each style that inspired it; the color of an American Brown, the caramel notes of a Scotch Ale, and the hopping regiment of an India Pale Ale. We dry-hop the Indian Brown Ale in a similar fashion as our 60 Minute IPA and 90 Minute IPAs. This beer is brewed with Aromatic barley and organic brown sugar.", "abv"=>"7.2", "ibu"=>"50", "glasswareId"=>5, "availableId"=>1, "styleId"=>37, "isOrganic"=>"N", "labels"=>{"icon"=>"https://s3.amazonaws.com/brewerydbapi/beer/AZI8ib/upload_1uf5Zr-icon.png", "medium"=>"https://s3.amazonaws.com/brewerydbapi/beer/AZI8ib/upload_1uf5Zr-medium.png", "large"=>"https://s3.amazonaws.com/brewerydbapi/beer/AZI8ib/upload_1uf5Zr-large.png"}, "status"=>"verified", "statusDisplay"=>"Verified", "foodPairings"=>"Balsamic vinaigrette salads, smoked meats, duck confit, braised ribs, venison, prosciutto, stews", "createDate"=>"2012-01-03 02:43:29", "updateDate"=>"2015-05-07 14:49:47", "glass"=>{"id"=>5, "name"=>"Pint", "createDate"=>"2012-01-03 02:41:33"}, "available"=>{"id"=>1, "name"=>"Year Round", "description"=>"Available year round as a staple beer."}, "style"=>{"id"=>37, "categoryId"=>3, "category"=>{"id"=>3, "name"=>"North American Origin Ales", "createDate"=>"2012-03-21 20:06:45"}, "name"=>"American-Style Brown Ale", "shortName"=>"American Brown", "description"=>"American brown ales range from deep copper to brown in color. Roasted malt caramel-like and chocolate-like characters should be of medium intensity in both flavor and aroma. American brown ales have evident low to medium hop flavor and aroma, medium to high hop bitterness, and a medium body. Estery and fruity-ester characters should be subdued. Diacetyl should not be perceived. Chill haze is allowable at cold temperatures.", "ibuMin"=>"25", "ibuMax"=>"45", "abvMin"=>"4", "abvMax"=>"6.4", "srmMin"=>"15", "srmMax"=>"26", "ogMin"=>"1.04", "fgMin"=>"1.01", "fgMax"=>"1.018", "createDate"=>"2012-03-21 20:06:46", "updateDate"=>"2015-04-07 15:27:35"}, "type"=>"beer"}

    erb :search_results
  end

  post '/search_results' do
    @search_param = params[:search_param]
    @pg_num = params[:pg_num] || 1
    #page
    if @pg_num > 0
      page ='&pg=' + @pg_num.to_s
    else
      page = ''
    end
    @search_results = HTTParty.get('http://api.brewerydb.com/v2/' + params[:search_param] +
     '$p=' + params[:pg_num] +
     {:query => {:key => 'fdf1b28c011f27510720ab3070943f3e'} })
    erb :search_results
  end
end
