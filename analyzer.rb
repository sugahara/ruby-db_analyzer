# -*- coding: utf-8 -*-
class Analyzer
  # DBのインスタンスをもらってDBから値を取得して出力まで

  def initialize(table, db, delta_t)
    @table = table
    @db = db
    @delta_t = delta_t
    @table_name = table
    # 開始時と終了時を得る
    sql = "SELECT time from `#{@table_name}` where number = '1'"
    @start_time = datetime2time(@db.query(sql).fetch_row()[0])
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

  def get_tcp
    while @end_time <= @last_packet_time
      sql = "SELECT COUNT(DISTINCT ip_src, ip_dst, tcp_srcport, tcp_dstport) FROM `#{@table_name}` WHERE time BETWEEN '#{start_time.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{end_time.strftime("%Y-%m-%d %H:%M:%S")}' and protocol_3='tcp'"
      puts @db.query(sql).fetch_row()
      slide_window
      
    end
  end
  
  def get_udp

  end
  
  def get_all

  end

  
end
