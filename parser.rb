module Bixi
  class Parser
    STATION_RXP = /var station = \{id:"(\d*)",name:"([\w|\-|\/|\s]*)",lat:"(\-?[\d|\.]*)",long:"(\-?[\d|\.]*)",nbBikes:"(\d*)",nbEmptyDocks:"(\d*)",installed:"(true|false)",locked:"(true|false)",temporary:"(true|false)"[\s|\w|,|:]*};/i

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

    def station_matches
      matches = @data.scan STATION_RXP
      matches ||= []
      matches.map do |match|
        {
          :id           => match[0].to_i,
          :name         => match[1],
          :lat          => match[2].to_f,
          :long         => match[3].to_f,
          :nbBikes      => match[4].to_i,
          :nbEmptyDocks => match[5].to_i,
          :installed    => match[6] == 'true',
          :locked       => match[7] == 'true',
          :temporary    => match[8] == 'true'
        }
      end
    end
  end
end