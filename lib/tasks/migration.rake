require 'migration/migration'

#importing / exporting the whole database in json format
namespace :migration do

  task :export => :environment do |task, args|
    Migration.export
  end

  task :import => :environment do |task, args|
    Migration.import
  end

end
