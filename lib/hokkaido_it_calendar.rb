# -*- coding: utf-8 -*-
require "hokkaido_it_calendar/version"

require 'icalendar'
require 'uri'
require 'net/http'
require 'fileutils'

module HokkaidoItCalendar
  ROOT = File.expand_path('~/hokkaido_it_calendar')
  OUTPUT_FILE_FORMAT = '%Y%m%d%H%M'

  def self.run
    FileUtils.mkdir_p(ROOT)
    last_access = LastAccess.new(ROOT)
    ical = HokkaidoItCalendar.new(last_access.get).to_ical
    unless ical.events.empty?
      puts 'ical file create start.....'
      date_for_filename = DateTime.now.strftime(OUTPUT_FILE_FORMAT)
      ext_name = '.ical'
      fullpath = File.join(ROOT, date_for_filename + ext_name)
      File.write(fullpath, ical.to_ical)
      puts "Create ical file:#{fullpath}."
    else
      puts 'Nothing to do.'
    end
    last_access.put
  end

  class HokkaidoItCalendar
    KEYWORD = /北海道/
    CALENDAR_URL = 'https://www.google.com/calendar/ical/fvijvohm91uifvd9hratehf65k%40group.calendar.google.com/public/basic.ics'

    def initialize since
      @since = since
    end

    def source
      return @source if @source
      puts 'Calender data download start.....'
      doc = Net::HTTP.get(URI.parse(CALENDAR_URL)).force_encoding('UTF-8')
      puts 'Calender data downloaded.'
      @source = Icalendar::Parser.new(doc, false).parse.first
    rescue => e
      puts e
      raise 'exception occerd'
    end

    def new_event? event
      @since <= event.created.to_datetime
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
        puts 'ical data filtering start.....'
        new_matching_events.each { |event| ical.add_event(event) }
        puts 'ical data filtered.'
      }
    rescue => e
      puts e
      raise 'exception occerd'
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
      doc = File.read(fullpath)
      DateTime.parse(doc)
    rescue
      DateTime.new
    end

    def put
      File.write(fullpath, DateTime.now.to_s)
    end
  end
end
