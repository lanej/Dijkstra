require "spec_helper"

describe Dijkstra do
  describe "#tc1" do
    let(:graph) { Dijkstra::Graph.new(parse_testcase("tc1")) }

    it 'solves testcase 1' do
      expected = {
        1 => 0,
        2 => 6,
        3 => 2,
        4 => 4,
        5 => 3,
        6 => 10,
        7 => 11,
        8 => 9,
        9 => 12,
      }

      graph.solve(1)

      expect(graph.shortest_paths).to eq(expected)
    end
  end

  describe "#homework" do
    let(:graph) { Dijkstra::Graph.new(parse_testcase("data")) }

    it 'solves homework' do
      expected = {
       115 => 2399,
       133 => 2029,
       165 => 2442,
       188 => 2505,
       197 => 3068,
       37 => 2610,
       59 => 2947,
       7 => 2599,
       82 => 2052,
       99 => 2367,
      }

      graph.solve(1)

      actual = graph.shortest_paths.select { |(k,_)| expected.key?(k) }

      puts actual.keys.sort.map { |k| actual[k] }.join(",")

      expect(actual).to eq(expected)
    end
  end

  def parse_testcase(filename)
    File.readlines("#{filename}.txt").each_with_object({}) do |line, res|
      tokens = line.strip.split(/\s+/)

      vertex = tokens.shift.to_i
      edge_weights = Hash[tokens.map { |t| t.split(',').map(&:to_i) }]

      res[vertex] = edge_weights
    end
  end
end
