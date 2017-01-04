require "dijkstra/version"

Bundler.require

module Dijkstra
  class Graph
    include Plexus

    attr_reader :graph, :shortest_paths

    def initialize(graph)
      @graph = graph
      @shortest_paths = {}
    end

    def vertices
      graph.keys
    end

    def show
      points = list.each_with_object([]) { |(h,ts), r| ts.each { |t| r << [h,t] } }
      DirectedGraph[*points.flatten].tap do |ug|
        filename = ug.write_to_graphic_file('png', 'tmp')
        system("open #{filename}")
      end
    end

    def solve(root)
      x = [root]
      y = vertices - [root]
      shortest_paths[root] = 0

      while y.any?
        # find edges with tail in x in head in y
        crossing_arcs = graph.each_with_object([]) { |(tail,edges),r|
          next unless x.include?(tail) # tail in x
          edges.each do |(head, weight)|
            next unless y.include?(head)

            score = (shortest_paths[tail] || 0) + weight

            r << [tail, head, weight, score]
          end
        }

        # find lowest greedy score
        _, v, _, score = crossing_arcs.sort_by { |_,_,_,score| score }.first

        # add vertex to x
        x << y.delete(v)

        # update vertex score
        shortest_paths[v] ||= score
        shortest_paths[v] = [shortest_paths[v], score].min
      end
    end
  end
end
