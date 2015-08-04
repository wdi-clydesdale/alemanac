class UsersController < ApplicationController

  def does_user_exist?(username)
    user = UsersModel.find_by(:name => username.to_s)
    if user
      return TRUE
    else
      return FALSE
    end
  end

  def is_authenticated?
    user_session = session[:user].nil?
  end

  # enable[:sessions]

  get '/new_user' do
      erb :new_user

  end
  # registration action
  post '/register' do
      puts '-------------'
      puts params
      puts '-------------'
      if does_user_exist(params[:username]) == TRUE
        @message = 'Username already exists'
        return erb :login_notice
      end

      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

      newbie = UsersModel.new
      newbie.username = params[:username]
      newbie.password_hash = password_hash
      newbie.password_salt = password_salt
      newbie.save

      @message = 'You have successfully registered!'


      erb :login_notice

  end
  # login action
  post '/login' do
    puts '-------------'
    puts params
    puts '-------------'

    @message = ''
    if does_user_exist?(params[:name]) == false
      @message = 'Sorry... but that username does not exist.'
      return erb :login_notice
    end

    #find and get our user
    username = UsersModel.where(:username => params[:name]).first!

    # does the password match?
    pwd = params[:password]
    if user.password_hash == BCrypt::Engine.hash_secret(pwd, user.password_salt)
      @message = 'You have been logged in successfully'
      sessions[:user] = true
      return erb :login_notice
    else
      @message = 'Sorry but your password does not match'
      return erb :login_notice
    end

  end


  get '/logout' do
    session[:user] = nil
    redirect '/'
  end


end
