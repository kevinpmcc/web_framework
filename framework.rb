class App
    def initialize(&block)
      @routes = RoutesTable.new(block)
    end

    def call(env)
        request = Rack::Request.new(env)
        @routes.each do |route|
            if route.match?(request.path)
                return [200, {}, [instance_eval(&route.block)]]
            end
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
        def match?(path)
            self.route == path
        end
    end
end
