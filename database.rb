require 'pg'

class Database

  def initialize(db_conn, queries)
    @db_conn = db_conn
    @queries = queries
  end

  def self.connect(url, queries)
    db_conn = PG::Connection.open(url)
    new(db_conn, queries)
  end

  def exec_sql(sql)
    @db_conn.exec(sql).to_a
  end

  def method_missing(name, *args)
    sql = @queries.fetch(name) % args

    exec_sql(sql)
  end
end