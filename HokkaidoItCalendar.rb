require 'icalendar'
require 'open-uri'

class HokkaidoItCalendar
  KEYWORD = '北海道'
  DATETIME_FILE_NAME = 'icaldatetime.txt'
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
    writeical(data)
    writedate
  end
  private
  def isMatchingEvent(event)
    return DateTime.parse(get_base_datetime) <= event.created && event.summary.match(KEYWORD)
  end
  def get_base_datetime
    File::open(DATETIME_FILE_NAME){|f|
      return f.gets
    }
  end
  def writedate
    datetext = File.open(DATETIME_FILE_NAME, "w")
    datetext.write("#{DateTime::now}")
    datetext.close
  end
  def writeical(data)
    output = File.open("HokkaidoIT_#{Date::today.strftime("%Y%m%d")}.ical", "w")
    output.write(data.to_ical)
    output.close
  end
end
