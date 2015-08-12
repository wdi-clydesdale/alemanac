require 'sinatra/base'

require('./controllers/ApplicationController')
require('./controllers/EntriesController')
require('./controllers/HomeController')
require('./controllers/UsersController')
require('./models/EntriesModel')
require('./models/UsersModel')

# map controllers
erogeroigeiorgjoi
map('/') {run HomeController}
map('/users') {run UsersController}
map('/beers') {run EntriesController}
map('/search_results') {run HomeController}
map('/new_user') {run UsersController}
map('/login') {run UsersController}
map('/my_alemanac') {run EntriesController}
# map ('/new_user') {run UsersController}
