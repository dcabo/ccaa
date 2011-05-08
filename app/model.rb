require "rubygems"
require "bundler/setup"
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Region
  include DataMapper::Resource
  property :id,           String, :length => 2, :key => true
  property :name,         String, :length => 50
  
  has n, :expenses
  has n, :populations
end

class Policy
  include DataMapper::Resource
  property :id,           String, :length => 2, :key => true
  property :name,         String, :length => 50

  has n, :expenses
end

class Expense
  include DataMapper::Resource  

  property :id,           Serial, :key => true
  property :year,         Integer
  property :amount,       Float
  
  belongs_to :policy
  belongs_to :region
end

class Population
  include DataMapper::Resource  

  property :id,           Serial, :key => true
  property :year,         Integer
  property :size,         Integer
  
  belongs_to :region
end

DataMapper.auto_upgrade!