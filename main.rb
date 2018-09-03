require_relative './framework.rb'
require 'pg'

APP = App.new do
    get '/' do
        'rooty'
    end

    get '/users/:username' do |params|
        'a user named ' + params.fetch('username')
    end

    get '/submissions' do
        conn = PG::Connection.open(:dbname => 'framework_dev')
        conn.exec('SELECT * FROM submissions;').first
    end
end

