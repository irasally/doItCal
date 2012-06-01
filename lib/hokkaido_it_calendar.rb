# -*- coding: utf-8 -*-
require "hokkaido_it_calendar/version"

require 'icalendar'
require 'uri'
require 'net/http'
require 'date'

module HokkaidoItCalendar
  ROOT = File.expand_path('~/hokkaido_it_calendar')
  OUTPUT_FILE_FORMAT = '%Y%m%d%H%M'

  def self.run
    last_access = LastAccess.new(ROOT)
    ical = HokkaidoItCalendar.new(last_access.get).to_ical
    unless ical.events.empty?
      output = File.open("Develop/doItCal/HokkaidoIT_#{DateTime::now.strftime(OUTPUT_FILE_FORMAT)}.ical", "w")
      output.write(ical.to_ical)
      output.close
    end
    last_access.put
  end

  class HokkaidoItCalendar
    KEYWORD = /北海道/
    CALENDAR_URL = 'http://www.google.com/calendar/ical/fvijvohm91uifvd9hratehf65k%40group.calendar.google.com/public/basic.ics'

    def initialize since
      @since = since
    end

    def source
      return @source if @source
      doc = Net::HTTP.get(URI.parse(CALENDAR_URL)).force_encoding('UTF-8')
      @source = Icalendar.parse(doc).first # doc have always only one calendar
    end

    def new_event? event
      @since <= event.created
    end

    def matching_event? event
      event.summary =~ KEYWORD
    end

    def new_matching_events
      source.events.
        select(&self.method(:new_event?)).
        select(&self.method(:matching_event?))
    end

    def to_ical
      Icalendar::Calendar.new.tap { |ical|
        new_matching_events.each { |event| ical.add_event(event) }
      }
    end
  end

  class LastAccess
    LASTACCESS_RECORD_FILE_NAME = 'lastaccess'

    def initialize root
      @root = root
    end

    def fullpath
      File.join(@root, LASTACCESS_RECORD_FILE_NAME)
    end

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
