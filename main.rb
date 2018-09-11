require_relative './database'
require_relative './framework'
require_relative './queries'
require 'pg'

DB = Database.connect('postgres://localhost/framework_dev', QUERIES)

APP = App.new do
  get '/' do
    'rooty'
  end

  get '/users/:username' do |params|
    'a user named ' + params.fetch('username')
  end

  get '/submissions' do
    DB.all_submissions
  end

  get '/submissions/:username' do |params|
    name = params.fetch('username')
    user = DB.find_submission_by_user(name).fetch(0)
    "the user is #{user.fetch('name')}"
  end
end

