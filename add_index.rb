require 'active_record'
class Migration < ActiveRecord::Migration
end
class ProcessingTable < ActiveRecord::Base
end

class AddIndex

  db_host = ARGV[0]
  db_user_name = ARGV[1]
  db_pass = ARGV[2]
  db_name = ARGV[3]
  
  ar_info = {
    :adapter => 'mysql',
    :host => db_host,
    :username => db_user_name,
    :password => db_pass,
    :database => db_name
  }
  
  ActiveRecord::Base.establish_connection(ar_info)
  tables = ActiveRecord::Base.connection.tables
  colmun = ["time"]
  colmun_text = ["protocol_4", "protocol_5"]
  tables.each do |tbl|
    colmun.each do |col|
      #Migration.add_index(tbl.intern, col)
    end
    colmun_text.each do |col|
      ProcessingTable.connection.execute("ALTER TABLE `#{tbl}` ADD FULLTEXT (`#{col}`)")
    end
  end
  
  
end
