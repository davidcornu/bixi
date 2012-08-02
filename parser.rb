# encoding=utf-8

module Bixi
  class Parser
    def initialize(data)
      @data = data
    end

    def stations
      @stations ||= station_matches
    end

    def to_s
      "#<Bixi::Parser>"
    end

    private

    STATION_RXP   = /var\s+station\s*=\s*{[^}]+}\s*;/x
    ATTRIBUTE_RXP = /\s*(\w+)\s*:\s*"([^"]+)"/x
    VALID_ATTRIBUTES = %w{id name lat long nbBikes nbEmptyDocks installed locked temporary}

    def cast(string)
      if string.match /\A\d+\z/
        string.to_i
      elsif string.match /\A-?\d+\.\d+\z/
        string.to_f
      elsif ['true', 'false'].include?(string)
        string == 'true'
      else
        string.gsub(/\\'/, "'")
      end
    end

    def station_matches
      raw_stations = @data.scan STATION_RXP
      raw_stations.map do |raw_station|
        station = {}
        raw_station.scan(ATTRIBUTE_RXP).each do |match|
          if match.size == 2
            station[match[0]] = cast(match[1])
          end
        end
        station.select {|k,v| VALID_ATTRIBUTES.include?(k)}
      end
    end
  end
end