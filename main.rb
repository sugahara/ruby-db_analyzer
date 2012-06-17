class Main
  require './analyzer.rb'
  require 'mysql'
  require './io.rb'
  table_name = ARGV[0]
  db_host = ARGV[1]
  db_user_name = ARGV[2]
  db_pass = ARGV[3]
  db_name = ARGV[4]
  delta_t = ARGV[5].to_f

  db = Mysql::new(db_host, db_user_name, db_pass, db_name)
  tables = db.list_tables
  tables.each do |tbl|
    puts tbl
    analyzer = Analyzer.new(tbl, db, delta_t)
    puts "get_tcp_flow"
    IO.to_file(analyzer.get_tcp_flow, "tcp_flow"+delta_t.to_s+"_"+tbl+".log")
    puts "get_udp_flow"
    IO.to_file(analyzer.get_udp_flow, "udp_flow"+delta_t.to_s+"_"+tbl+".log")
    puts "get_all_flow"
    IO.to_file(analyzer.get_all_flow, "all_flow"+delta_t.to_s+"_"+tbl+".log")
    puts "get_tcp_packet"
    IO.to_file(analyzer.get_tcp_packet, "tcp_packet"+delta_t.to_s+"_"+tbl+".log")
    puts "get_udp_packet"
    IO.to_file(analyzer.get_udp_packet, "udp_packet"+delta_t.to_s+"_"+tbl+".log")
    puts "get_all_packet"
    IO.to_file(analyzer.get_all_packet, "all_packet"+delta_t.to_s+"_"+tbl+".log")
  end

end
