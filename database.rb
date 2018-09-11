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

  def method_missing(name, *args)
    sql = @queries.fetch(name)

    @db_conn.exec_params(sql, args).to_a.map do |row|
      Record.new(row)
    end
  end

  class Record
    def initialize(row)
      @row = row
    end

    def method_missing(name)
      @row.fetch(name.to_s)
    end
  end
end