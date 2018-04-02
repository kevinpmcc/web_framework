class App
    def initialize(&block)
      @routes = RoutesTable.new(block)
    end
    def call(env)
        [200, {}, ["hello world!"]]
    end

    class RoutesTable
        def initialize(block)
            @routes = []
            instance_eval(&block)
        end

        def get(route, &block)
            @routes << Route.new(route, block)
        end
    end

    Route = Struct.new(:route, :block)
end
