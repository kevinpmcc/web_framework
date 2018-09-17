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

  def method_missing(name, params={})
    sql = @queries.fetch(name)
    Executor.new(@db_conn, sql, params).execute
  end

  class Executor

    def initialize(db_conn, sql, params)
      @db_conn = db_conn
      @sql = sql
      @params = params
    end

    def execute
      var_names = @params.keys
      args = @params.values
      var_names.each_with_index do |var, index|
          key = "{" + var.to_s + "}" 
          @sql = @sql.gsub(key, "$#{index + 1}")
      end

      @db_conn.exec_params(@sql, args).to_a.map do |row|
        Record.new(row)
      end
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