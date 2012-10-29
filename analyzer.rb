# -*- coding: utf-8 -*-
class Analyzer
  require 'ruby-debug'
  # DBのインスタンスをもらってDBから値を取得して出力まで
  def initialize(tables, db, delta_t)
    @tables = tables
    @processing_table = @tables.first
    @db = db
    @delta_t = delta_t
    @result = []
    time_check
    sql = "SELECT time from `#{@processing_table}` where number = (select min(number) from `#{@processing_table}`)"
    @start_time = datetime2time(@db.query(sql).fetch_row()[0])
    @end_time = @start_time + @delta_t - 1
  end
  
  def time_check
    # テーブルの最終パケット時刻を得る
    # sql = "SELECT time from `#{@processing_table}` where number = (select min(number) from `#{@processing_table}`)"
    # @start_time = datetime2time(@db.query(sql).fetch_row()[0])
    # @end_time = @start_time + @delta_t - 1
    sql = "SELECT time FROM `#{@processing_table}` WHERE number = (select max(number) from `#{@processing_table}`)"
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

  def get_flow_sql(table, start_time, end_time, protocol=nil, layer_num = nil)
    sql = "SELECT COUNT(DISTINCT ip_src, ip_dst, port_src, port_dst) FROM `#{table}` WHERE time BETWEEN '#{start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{end_time.strftime("%Y-%m-%d %H:%M:%S")}'"
    if protocol != nil
      sql +=  "AND protocol_#{layer_num}='#{protocol}'"
    end
    sql
  end

  def get_packet_sql(table, start_time, end_time, protocol=nil, layer_num = nil)
    sql = "SELECT COUNT(*) FROM `#{table}` WHERE time BETWEEN '#{start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{end_time.strftime("%Y-%m-%d %H:%M:%S")}'"
    if protocol != nil
      sql +=  "AND protocol_#{layer_num}='#{protocol}'"
    end
    sql
  end

  def flow_query(protocol=nil, layer_num = nil)
    # プロトコルが指定されている場合のフロー数集計
    if protocol != nil
      @tables.each_with_index do |tbl, i|
        @processing_table = tbl
        time_check
        while @start_time <= @last_packet_time
          p @start_time
          p @end_time
          sql = get_flow_sql(@processing_table, @start_time, @end_time, protocol, layer_num)
          result = @db.query(sql).fetch_row()[0].to_i
          ## table transition
          j = i
          while @end_time >= @last_packet_time && @tables.size - 1 < j
            @processing_table = @tables[j+1]
            time_check
            sql = get_flow_sql(@tables[j+1], @start_time, @end_time, protocol, layer_num)
            result += @db.query(sql).fetch_row()[0].to_i
            j += 1
          end
          @processing_table = tbl
          time_check
          puts result
          @result << result
          slide_window
        end
        IO::to_file(@result,"#{protocol}_flow"+@delta_t.to_s+"_"+@processing_table+".log")
        @result = []
      end
      # プロトコルが指定されていない場合のフロー数集計
    else
      @tables.each_with_index do |tbl, i|
        @processing_table = tbl
        time_check
        while @start_time <= @last_packet_time
          sql = get_flow_sql(@processing_table, @start_time, @end_time)
          result = @db.query(sql).fetch_row()[0].to_i
          ## table transition
          j = i
          while @end_time >= @last_packet_time && @tables.size - 1 < j
            @processing_table = @tables[j+1]
            time_check
            sql = get_flow_sql(@tables[j+1], @start_time, @end_time)
            result += @db.query(sql).fetch_row()[0].to_i
            j += 1
          end
          @processing_table = tbl
          time_check
          puts result
          @result << result
          slide_window
        end
        IO::to_file(@result,"all_flow"+@delta_t.to_s+"_"+@processing_table+".log")
        @result = []
      end
    end
  end

  def packet_query(protocol=nil, layer = nil)
    # プロトコルが指定されている場合のパケット数集計
    if protocol != nil
      @tables.each_with_index do |tbl, i|
        @processing_table = tbl
        time_check
        while @start_time <= @last_packet_time
          p @start_time
          p @end_time
          sql = get_packet_sql(@processing_table, @start_time, @end_time, protocol, layer)
          result = @db.query(sql).fetch_row()[0].to_i
          ## table transition
          j = i
          while @end_time >= @last_packet_time && @tables.size - 1 < j
            @processing_table = @tables[j+1]
            time_check
            sql = get_packet_sql(@tables[j+1], @start_time, @end_time, protocol, layer)
            result += @db.query(sql).fetch_row()[0].to_i
            j += 1
          end
          @processing_table = tbl
          time_check
          puts result
          @result << result
          slide_window
        end
        IO::to_file(@result,"#{protocol}_packet"+@delta_t.to_s+"_"+@processing_table+".log")
        @result = []
      end
      # プロトコルが指定されていない場合のパケット数集計
    else
      @tables.each_with_index do |tbl, i|
        @processing_table = tbl
        time_check
        while @start_time <= @last_packet_time
          p @start_time
          p @end_time
          sql = get_packet_sql(@processing_table, @start_time, @end_time)
          result = @db.query(sql).fetch_row()[0].to_i

          ## table transition
          j = i
          while @end_time >= @last_packet_time && @tables.size - 1 < j
            @processing_table = @tables[j+1]
            time_check
            sql = get_packet_sql(@tables[j+1], @start_time, @end_time)
            result += @db.query(sql).fetch_row()[0].to_i
            j += 1
          end
          @processing_table = tbl
          time_check
          puts result
          @result << result
          slide_window
        end
        IO::to_file(@result,"all_packet"+@delta_t.to_s+"_"+@processing_table+".log")
        @result = []
      end
    end
  end
  
  def get_tcp_flow
    flow_query("tcp", 3)
  end
  
  def get_udp_flow
    flow_query("udp", 3)
  end
  
  def get_all_flow
    flow_query()
  end

  def get_tcp_packet
    packet_query("tcp", 3)
  end

  def get_udp_packet
    packet_query("udp", 3)
  end

  def get_all_packet
    packet_query()
  end

  def get_packet(protocol, layer)
    packet_query(protocol, layer)
  end

  def get_flow(protocol, layer)
    flow_query(protocol, layer)
  end

end
