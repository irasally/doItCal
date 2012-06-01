# -*- coding: utf-8 -*-
require "hokkaido_it_calendar/version"

require 'icalendar'
require 'open-uri'
require 'date'

module HokkaidoItCalendar
  def self.run
    HokkaidoItCalendar.new.create
  end

  class HokkaidoItCalendar
    KEYWORD = '北海道'
    DATETIME_FILE_NAME = '/Users/sally/Develop/doItCal/icaldatetime.txt'
    OUTPUT_FILE_FORMAT = '%Y%m%d%H%M'
    CALENDAR_URL = 'http://www.google.com/calendar/ical/fvijvohm91uifvd9hratehf65k%40group.calendar.google.com/public/basic.ics'
    def create
      data = Icalendar::Calendar.new
      open(CALENDAR_URL) {|f|
        cal = Icalendar.parse(f).first
        cal.events.each { |event|
          if isMatchingEvent(event) then
            data.add_event(event)
          end
        }
      }
      if data.events.size != 0 then
        writeical(data)
      end
      writedate
    end
    private
    def isMatchingEvent(event)
      return get_base_datetime <= event.created && event.summary.match(KEYWORD)
    end
    def get_base_datetime
      File::open(DATETIME_FILE_NAME){|f|
        return DateTime.parse(f.gets)
      }
    end
    def writedate
      LastAccess.new.put
    end
    def writeical(data)
      output = File.open("Develop/doItCal/HokkaidoIT_#{DateTime::now.strftime(OUTPUT_FILE_FORMAT)}.ical", "w")
      output.write(data.to_ical)
      output.close
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
