require_relative './framework.rb'

APP = App.new do
    get '/' do
        'rooty'
    end

    get '/users/:username' do |params|
        'a user named ' + params.fetch("username")
    end
end

