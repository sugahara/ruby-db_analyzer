class Main
  require './analyzer2.rb'
  require 'mysql'
  require './io.rb'
  db_host = ARGV[0]
  db_user_name = ARGV[1]
  db_pass = ARGV[2]
  db_name = ARGV[3]
  delta_t = ARGV[4].to_f
  start_time = nil
  as_soon_as_possible = Time.now
  # I want to go home as soon as possible.
  # Me too.
  end_time = as_soon_as_possible

  db = Mysql::new(db_host, db_user_name, db_pass, db_name)
  tables = db.list_tables
  analyzer = Analyzer.new(tables, db, delta_t)
  puts "get_tcp_flow"
  analyzer.get_tcp_flow
  analyzer.get_udp_flow
  analyzer.get_all_flow
  analyzer.get_tcp_packet
  analyzer.get_udp_packet
  analyzer.get_all_packet
  analyzer.get_packet("http", 4)
  analyzer.get_flow("http", 4)
  analyzer.get_packet("dns", 4)
  analyzer.get_flow("dns", 4)
  analyzer.get_packet("nfs", 4)
  analyzer.get_flow("nfs", 4)
  analyzer.get_packet("arp", 2)
  analyzer.get_flow("arp", 2)

end
