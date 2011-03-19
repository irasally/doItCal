require 'icalendar'
require 'open-uri'

class HokkaidoItCalendar
  KEYWORD = '北海道'
  DATETIME_FILE_NAME = 'icaldatetime.txt'
  CALENDAR_URL = 'http://www.google.com/calendar/ical/fvijvohm91uifvd9hratehf65k%40group.calendar.google.com/public/basic.ics'
  def create
    data = Icalendar::Calendar.new
    basedate = get_base_datetime

    open(CALENDAR_URL) {|f|
      cal = Icalendar.parse(f).first
      cal.events.each { |event|
        if DateTime.parse(basedate) <= event.created and event.summary.match(KEYWORD) and Date::today <= event.dtstart then
          data.add_event(event)
        end
      }
    }
    writeical(data)
    writedate
  end
  private
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
