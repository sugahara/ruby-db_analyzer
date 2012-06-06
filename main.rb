class Main
  require './analyzer.rb'
  require 'mysql'
  table_name = ARGV[0]
  db_host = ARGV[1]
  db_user_name = ARGV[2]
  db_pass = ARGV[3]
  db_name = ARGV[4]
  delta_t = ARGV[5].to_f

  db = Mysql::new(db_host, db_user_name, db_pass, db_name)
  

  
  analyzer = Analyzer.new(table_name, db, delta_t)


end
