class App
    def call(env)
        [200, {}, ["hello world!"]]
    end
end

APP = App.new
