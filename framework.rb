class App
    def initialize(&block)
      @routes = RoutesTable.new(block)
    end

    def call(env)
        request = Rack::Request.new(env)
        @routes.each do |route|
            content = route.match(request)
            return [200, { "Content-type" => "text/plain"}, [content.to_s]] if content
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

        def match(request)
            path_components = request.path.split('/')
            spec_components = route.split('/')
            params = {}

            return nil unless path_components.length == spec_components.length
            spec_components.zip(path_components).each do |spec_comp, path_comp|
                is_var = spec_comp.start_with?(':')
                if is_var
                    key = spec_comp[1..-1]
                    params[key] = URI.decode(path_comp)
                else
                    return nil unless path_comp == spec_comp
                end
            end
            block.call(params)
        end
    end
end
