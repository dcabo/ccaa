require "rubygems"
require "bundler/setup"

require 'sinatra/base'
require 'haml'

require 'app/model'

class RegionBudgetApp < Sinatra::Base
  
  # Enable serving of static files
  set :static, true
  set :public, 'public'
  
  get '/' do
    haml :index
  end
  
end