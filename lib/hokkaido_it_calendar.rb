# -*- coding: utf-8 -*-
require "hokkaido_it_calendar/version"

require 'icalendar'
require 'uri'
require 'net/http'
require 'date'

module HokkaidoItCalendar
  def self.run
    last_access = LastAccess.new
    HokkaidoItCalendar.new(last_access.get).create
    last_access.put
  end

  class HokkaidoItCalendar
    KEYWORD = '北海道'
    OUTPUT_FILE_FORMAT = '%Y%m%d%H%M'
    CALENDAR_URL = 'http://www.google.com/calendar/ical/fvijvohm91uifvd9hratehf65k%40group.calendar.google.com/public/basic.ics'

    def initialize since
      @since = since
    end

    def source
      return @source if @source
      doc = Net::HTTP.get(URI.parse(CALENDAR_URL)).force_encoding('UTF-8')
      @source = Icalendar.parse(doc).first # doc have always only one calendar
    end

    def new_matching_events
      source.events.select(&:isMatchingEvent)
    end

    def to_ical
      Icalendar::Calendar.new.tap { |ical|
        new_matching_events.each { |event| ical.add_event(event) }
      }
    end

    def create
      unless to_ical.events.empty?
        output = File.open("Develop/doItCal/HokkaidoIT_#{DateTime::now.strftime(OUTPUT_FILE_FORMAT)}.ical", "w")
        output.write(to_ical.to_ical)
        output.close
      end
    end
    private
    def isMatchingEvent(event)
      return @since <= event.created && event.summary.match(KEYWORD)
    end
  end

  class LastAccess
    DATETIME_FILE_NAME = '/Users/sally/Develop/doItCal/icaldatetime.txt'

    def get
      File::open(DATETIME_FILE_NAME){|f|
        return DateTime.parse(f.gets)
      }
    end

    def put
      datetext = File.open(DATETIME_FILE_NAME, "w")
      datetext.write("#{DateTime::now}")
      datetext.close
    end
  end
end
