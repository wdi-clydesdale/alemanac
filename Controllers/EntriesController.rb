class EntriesController < ApplicationController

#@beer =

  get '/new' do
    erb :new_entry
  end

  post '/new_api_entry' do

    puts '---------'
    puts params
    puts '---------'

    @beer_name = params['beer_name']
    @beer_brewery = ''
    @beer_abv = params['abv']

    erb :new_entry_from_api

  end

  post '/new' do

    puts '---------'
    puts params
    puts user = session[:user]
    puts '---------'

    puts

    @beer = EntriesModel.new

    @beer.beer_name = params[:beer_name]
    @beer.brewery = params[:brewery_name]
    @beer.abv = params[:abv].to_i
    @beer.brew_location = params[:brew_location]
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
    @user=session[:user]
    @entries=@user.entries.all
    erb :user_journal
  end

end
