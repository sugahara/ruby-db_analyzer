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
  #IO.to_file(analyzer.get_tcp_flow, "tcp_flow"+delta_t.to_s+"_"+tbl+".log")
  #puts "get_udp_flow"
  #IO.to_file(analyzer.get_udp_flow, "udp_flow"+delta_t.to_s+"_"+tbl+".log")
  #puts "get_all_flow"
  #IO.to_file(analyzer.get_all_flow, "all_flow"+delta_t.to_s+"_"+tbl+".log")
  #puts "get_tcp_packet"
  #IO.to_file(analyzer.get_tcp_packet, "tcp_packet"+delta_t.to_s+"_"+tbl+".log")
  #puts "get_udp_packet"
  #IO.to_file(analyzer.get_udp_packet, "udp_packet"+delta_t.to_s+"_"+tbl+".log")
  #puts "get_all_packet"
  #IO.to_file(analyzer.get_all_packet, "all_packet"+delta_t.to_s+"_"+tbl+".log")

end
