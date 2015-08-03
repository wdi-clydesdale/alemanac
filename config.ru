require 'sinatra/base'

Dir.glob('./{controllers,models}/*rb').each {
  |file| require file
}

map('/users') {run UsersController}
map('/') {run HomeController}
map('/beers') {run BeersController}
