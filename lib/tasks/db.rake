namespace :db do
  desc "Clear all table data"
  task clear_data: :environment do
    ActiveRecord::Base.connection.tables.each do |table|
      next if table == "schema_migrations"
      ActiveRecord::Base.connection.execute("TRUNCATE #{table} CASCADE")
    end
    puts "All table data has been cleared."
  end
end
