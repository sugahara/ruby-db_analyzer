class AddIndex
  require 'mysql'
  
  db_host = ARGV[0]
  db_user_name = ARGV[1]
  db_pass = ARGV[2]
  db_name = ARGV[3]
  
  db = Mysql::new(db_host, db_user_name, db_pass, db_name)

  #sql = "SHOW TABLES FROM tcpdump"
  tables =  db.list_tables
  tables.each do |tbl|
    fields = db.list_fields(tbl).fetch_fields
    (1...fields.size()).each do |t|
      if fields[t].type != Mysql::Field::TYPE_BLOB
        sql = "ALTER TABLE `#{tbl}` ADD INDEX #{fields[t].name}(#{fields[t].name})"
        p sql
      else
        #sql = "ALTER TABLE `#{tbl}` ADD INDEX #{fields[t].name}(#{fields[t].name}(200))"
        #p sql
      end
      begin
        db.query(sql)
      rescue
        puts db.error
      end
    end
  end
end
