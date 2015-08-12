class UsersController < ApplicationController

  def does_user_exist?(username)
    user = UsersModel.find_by(:username => username.to_s)
    if user
      return TRUE
    else
      return FALSE
    end
  end

  def is_not_authenticated?
    session[:user].nil?
  end


  get '/new_user' do
      erb :new_user

  end
  # registration action
  post '/register' do
      puts '-------------'
      puts params
      puts '-------------'
      @messsage = ' '



      if does_user_exist?(params[:username]) == TRUE
        @message = 'This username already exists. Try again.'
        return erb :login_notice
      end

      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

      new_user = UsersModel.new
      new_user.username = params[:username]
      new_user.email = params[:user_email]
      new_user.first_name = params[:first_name]
      new_user.last_name = params[:last_name]
      new_user.password_hash = password_hash
      new_user.password_salt = password_salt
      new_user.save

      @message = 'You have successfully registered with Alemanac! Now, go find your favorite brews.'


      erb :login_notice

  end

  get '/login' do
      erb :login

  end
  # login action
  post '/login' do
    puts '-------------'
    puts params
    puts '-------------'

    @message = ''

    if does_user_exist?(params[:username]) == false
      @message = 'Sorry... but that username does not exist.'
      return erb :login_notice
    end

    #find and get our user
    @user = UsersModel.where(:username => params[:username]).first!

    # does the password match?
    pwd = params[:password]
    if @user.password_hash == BCrypt::Engine.hash_secret(pwd, @user.password_salt)
      @message = 'You have been logged in successfully!'
      session[:user] = @user
      # puts @user.id
      # puts session[:user].id
      return erb :login_notice
    else
      @message = 'Sorry but your password does not match our records. Please try again. '
      return erb :login_notice
    end

  end


  get '/logout' do
    session[:user] = nil
    redirect '/'
  end



end
