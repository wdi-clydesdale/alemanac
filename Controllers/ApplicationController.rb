class ApplicationController < Sinatra::Base
  require 'bundler'
  Bundler.require()

  ActiveRecord::Base.establish_connection(
    :adapter => 'postgresql',
    :database => 'alemanac'
    )

  set :views, File.expand_path('../../views',__FILE__)

end
