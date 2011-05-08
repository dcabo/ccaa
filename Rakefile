require 'parser/import.rb'

namespace 'data' do
  
  desc "Import budget data"
  task :import, [:uri] do |t, args|
    if ( args.uri.nil? )
      puts "Error: missing input file URI!"
    else
      puts "Importing data from file #{args.uri}..."
      RegionBudgetImporter::import(args.uri)
    end
  end
  
end