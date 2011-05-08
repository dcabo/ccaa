require "rubygems"
require "bundler/setup"

require 'sinatra/base'
require 'haml'
require 'json'

require 'app/model'

# TODO: Remove hardwired constants
class RegionBudgetApp < Sinatra::Base
  
  # Enable serving of static files
  set :static, true
  set :public, 'public'
  
  get '/' do
    @regions = Region.all

    # Get the policies in descending amount order for last year
    # (Doing this instead of returning Policy.all has the benefit of not 
    # including policies that are in the budget but never have amounts - 
    # like Defence, and - at the front-end - sorting out the graphs based 
    # on amount makes more sense)
    # TODO: Move this to URL and fetch using Ajax
    ids = Expense.all(:region_id => '00', :year => '2010', :order => :amount.desc).map &:policy_id
    @policies = ids.map{|id| {:id => id, :name => Policy.get(id).name}}
        
    haml :index
  end
  
  get '/ca/:region' do
    # Fetch relevant data
    region = Region.first(:id => params[:region])
    expenses = region.expenses
    
    populations = {}
    region.populations.each{|p| populations[p.year] = p.size }
    
    # Reshuffle as needed for visualization
    per_policy_data = {}
    expenses.each do |e|
      per_policy_data[e.policy_id] = {} if per_policy_data[e.policy_id].nil?
      per_policy_data[e.policy_id][e.year] = e.amount
    end

    # TODO: Clean up total calculation
    total = {}
    expenses.each do |e|
      total[e.year] = total[e.year].nil? ? e.amount : total[e.year]+e.amount
    end
    per_policy_data['00'] = total
    
    # Prepare JSON response
    content_type :json
    response = { 
      :label => region.name, 
      :per_policy_data => per_policy_data,
      :populations => populations
      }
    response.to_json
  end  
end