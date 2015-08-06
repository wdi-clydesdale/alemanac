class EntriesController < ApplicationController

# @beer =

  get '/new' do
    erb :new_entry
  end

  get '/new_api_entry' do
    erb :new_entry_from_api
  end

  post'/new_api_entry_add' do
    @beer_name = params['beer_name']
    @beer_abv = params['abv']
    @notes = params['notes']
    erb :new_entry_from_api
  end

  post '/new_api_entry' do

    puts '---------'
    puts params
    puts user = session[:user]
    puts '---------'

    puts
    @beer = EntriesModel.new

    @beer.beer_name = params[:beer_name]
    # @beer.brewery = params[:brewery_name]
    @beer.abv = params[:abv].to_i
    # @beer.brew_location = params[:brew_location]
    @beer.consume_location = params[:consume_location]
    @beer.vote = params[:vote].to_i
    @beer.notes = params[:notes]
    if params[:beer_id]
      @beer.is_custom = false
      @beer.beer_id = params[:beer_id].to_i
    else
      @beer.is_custom = true
    end
    @beer.user_id = user.id.to_i
    # @beer.user_id = UsersModel.find_by(:id => id.to_i)

    puts '---------'
    puts @beer
    puts '---------'
    @beer.save

    # @beer_name = params['beer_name']
    # @beer_brewery = ''
    # @beer_abv = params['abv']

    erb :new_entry_success

  end

  post '/new' do

    puts '---------'
    puts params
    puts user = session[:user]
    puts '---------'

    puts

    @beer = EntriesModel.new

    @beer.beer_name = params[:beer_name]
    # @beer.brewery = params[:brewery_name]
    @beer.abv = params[:abv].to_i
    # @beer.brew_location = params[:brew_location]
    @beer.consume_location = params[:consume_location]
    @beer.vote = params[:vote].to_i
    @beer.notes = params[:notes]
    if params[:beer_id]
      @beer.is_custom = false
      @beer.beer_id = params[:beer_id].to_i
    else
      @beer.is_custom = true
    end
    @beer.user_id = user.id.to_i
    # @beer.user_id = UsersModel.find_by(:id => id.to_i)

    puts '---------'
    puts @beer
    puts '---------'
    @beer.save



    erb :new_entry_success
  end

  get '/my_alemanac' do
    # @user=session[:user]
    @current_user = session[:user]
    # @user_id=@user.user_id
    # @entries=Entries.where(user_id: session[:current_user].id)
    @all_entries = EntriesModel.all
    @entries = Array.new
    @all_entries.each do |entry|

      if entry.user_id == @current_user.id
        @entries.push(entry)
      end

    end
    puts @current_user.id
    # @reviews = product.reviews.select! { |s| s.user_id == current_user.id } unless admin?
    erb :user_journal
  end


  get '/edit_entry/:id' do
    @id = params[:id]
    @entry = EntriesModel.find(@id)

    erb :edit_entry
  end

  post '/edit' do
    puts '------yoloswag------'
    puts params
    puts '------yoloswag------'

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
