class ApplicationController < Sinatra::Base
  require 'bundler'
  Bundler.require()

  ActiveRecord::Base.establish_connection(
    :adapter => 'postgresql',
    :database => 'alemanac'
    )

    # enable[:sessions]
    enable :sessions

    def is_not_authenticated?
      session[:user].nil?
    end


  set :views, File.expand_path('../../Views',__FILE__)
  # set :public_folder, File.expand_path('../../Public',__FILE__)
  set :public_dir, File.expand_path('../../Public', __FILE__)

end
