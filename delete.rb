require 'mysql'

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

db = Mysql::new("127.0.0.1", "ruby", "suga0329", "1week")
tables = db.list_tables
tables.each do |tbl|
    #sql = "delete from `#{tbl}` where time NOT BETWEEN '2012-05-26 00:00:00' AND '2012-06-01 23:59:59'"
  sql = "select time from `#{tbl}` order by number desc limit 1"
  p sql
  result = db.query(sql).fetch_row()[0]
  p result.class
  last_time = datetime2time(result)
  if !(last_time >= Time.local(2012,5,26,0,0,0) && last_time <= Time.local(2012,6,1,23,59,59))
    sql = "drop table `#{tbl}`"
    p sql
    db.query(sql)
  end
end
