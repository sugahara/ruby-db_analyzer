# -*- coding: utf-8 -*-
class Analyzer
  require 'ruby-debug'
  # DBのインスタンスをもらってDBから値を取得して出力まで
  def initialize(table, db, delta_t, tables, init_start_time)
    @table = table
    @db = db
    @delta_t = delta_t
    @table_name = table
    @result = []
    @init_start_time = init_start_time
    init_time
  end

  def init_time
    # 開始時と終了時を得る
    if @end_time != nil
      @last_end_time = @end_time
    end
    if @init_start_time != nil
      @start_time = @init_start_time
    else
      sql = "SELECT time from `#{@table_name}` where number = (select min(number) from `#{@table_name}`)"
      @start_time = datetime2time(@db.query(sql).fetch_row()[0])
    end
    @end_time = @start_time + @delta_t - 1
    sql = "SELECT time FROM `#{@table_name}` WHERE number = (select max(number) from `#{@table_name}`)"
    @last_packet_time = datetime2time(@db.query(sql).fetch_row()[0])
  end

  def datetime2time(datetime)
    year = datetime.split(" ")[0].split("-")[0]
    month = datetime.split(" ")[0].split("-")[1]
    day = datetime.split(" ")[0].split("-")[2]
    hour = datetime.split(" ")[1].split(":")[0]
    min = datetime.split(" ")[1].split(":")[1]
    sec = datetime.split(" ")[1].split(":")[2]
    time = Time.local(year, month, day, hour, min, sec)
    time
  end

  def slide_window
    @start_time = @end_time + 1
    @end_time = @start_time + @delta_t -1
  end

  def flow_query(protocol=nil)
    @result = []
    if protocol != nil
      while @end_time <= @last_packet_time
        sql = "SELECT COUNT(DISTINCT ip_src, ip_dst, port_src, port_dst) FROM `#{@table_name}` WHERE time BETWEEN '#{@start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{@end_time.strftime("%Y-%m-%d %H:%M:%S")}' and protocol_3='#{protocol}'"
        sql += "AND time  BETWEEN '2012-05-26 00:00:00' AND '2012-06-01 23:59:59'"
        puts result = @db.query(sql).fetch_row()[0].to_i
        @result << result
        slide_window
      end
    else
      #get all protocol
      while @end_time <= @last_packet_time
        sql = "SELECT COUNT(DISTINCT ip_src, ip_dst, port_src, port_dst) FROM `#{@table_name}` WHERE time BETWEEN '#{@start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{@end_time.strftime("%Y-%m-%d %H:%M:%S")}'"
        sql += "AND time  BETWEEN '2012-05-26 00:00:00' AND '2012-06-01 23:59:59'"
        puts result = @db.query(sql).fetch_row()[0].to_i
        @result << result
        slide_window
      end
    end
  end

  def packet_query(protocol=nil)
    @result = []
    if protocol != nil
      while @end_time <= @last_packet_time
        sql = "SELECT COUNT(*) FROM `#{@table_name}` WHERE time BETWEEN '#{@start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{@end_time.strftime("%Y-%m-%d %H:%M:%S")}' and protocol_3='#{protocol}'"
        sql += "AND time  BETWEEN '2012-05-26 00:00:00' AND '2012-06-01 23:59:59'"
        puts result = @db.query(sql).fetch_row()[0].to_i
        @result << result
        slide_window
      end
    else
      while @end_time <= @last_packet_time
        sql = "SELECT COUNT(*) FROM `#{@table_name}` WHERE time BETWEEN '#{@start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{@end_time.strftime("%Y-%m-%d %H:%M:%S")}'"
        sql += "AND time  BETWEEN '2012-05-26 00:00:00' AND '2012-06-01 23:59:59'"
        puts result = @db.query(sql).fetch_row()[0].to_i
        @result << result
        slide_window
      end
    end
  end
  
  def get_tcp_flow
    flow_query("tcp")
    init_time
    @result
  end
  
  def get_udp_flow
    flow_query("udp")
    init_time
    @result
  end
  
  def get_all_flow
    flow_query()
    init_time
    @result
  end

  def get_tcp_packet
    packet_query("tcp")
    init_time
    @result
  end

  def get_udp_packet
    packet_query("udp")
    init_time
    @result
  end

  def get_all_packet
    packet_query()
    init_time
    @result
  end

  def close
    @last_end_time + 1
  end
end
