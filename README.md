# Pakcet / Flow counter from a database
データベースに格納されたEthernetトラフィックのヘッダ情報から全パケットまたは指定したプロトコルの指定間隔中に観測されるパケット数やフロー数を集計し出力するプログラムです．

## 使い方

	% ruby main.rb <mysql_server_host_address> <mysql_username> <mysql_password> <database_name> <time_window_size>
	
	mysql_server_host_address
		MySQLサーバのアドレス
	
	mysql_username
		MySQLサーバのユーザ名
	
	mysql_password
		指定したMySQLユーザのパスワード
		
	database_name
		MySQLにあるデータベース名
		
	time_window_size
		指定する間隔(秒)

## フォーマット
### データベース関連
サーバにはMySQLサーバを使用する必要があります．また指定するユーザには指定したデータベースに対して全権限を有していることが好ましいですが，最低限パケット数フロー数のカウントはSELECT権限，SHOW権限が必要になります．その他add_index.rbなどインデックス設定ユーティリティは更に他の権限が必要になります．

本プログラムはSHOW TABLESクエリで返されるテーブル順にカウントを行うため，指定したデータベースのテーブルはテーブル名昇順で時系列順になるようにソートされている必要があります．

テーブルの構造は以下の通り  

![必要なテーブル構造](https://dl.dropbox.com/u/532328/db_field.png)

### 出力ファイル
実行後実行ファイルが存在するディレクトリに結果のログファイルが以下のようなファイル名で出力される．

    <protocol>_<packet or flow><time_window>_<table_name>.log
    実際の例:udp_packet3600.0_dump_00714_20120601181851.pcap.log

これはあるテーブル内に含まれるパケットからパケット数フロー数を集計したものである．
データベース全体の集計結果を1ファイルに出力するには以下の様なコマンドを実行することで可能である．

    % cat udp_packet3600.0_dump_* > udp_packet3600.0.log
