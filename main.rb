require_relative './framework.rb'

APP = App.new do
    get '/' do
        'rooty'
    end

    get '/users/:username' do
        'a user'
    end
end

