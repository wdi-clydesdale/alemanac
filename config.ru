require 'sinatra/base'

Dir.glob('./{controllers,models}/*.rb').each {
  |file| require file
}

# map controllers

map('/') {run HomeController}
map('/users') {run UsersController}
map('/beers') {run EntriesController}
map('/search_results') {run HomeController}
map('/new_user') {run UsersController}
map('/login') {run UsersController}
map('/my_alemanac') {run EntriesController}
# map ('/new_user') {run UsersController}
