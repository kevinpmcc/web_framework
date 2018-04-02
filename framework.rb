class App
    def initialize(&block)
      @routes = RoutesTable.new(block)
    end

    def call(env)
        request = Rack::Request.new(env)
        @routes.each do |route|
            return [200, {}, [route.content(request)]] if route.content(request)
        end
        [404, {}, ["Route #{request.path} not found"]]
    end

    class RoutesTable
        def initialize(block)
            @routes = []
            instance_eval(&block)
        end

        def get(route, &block)
            @routes << Route.new(route, block)
        end

        def each(&block)
            @routes.each(&block)
        end
    end

    class Route < Struct.new(:route, :block)
        def content(request)
            block.call if route == request.path
        end
    end
end
