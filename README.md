# HokkaidoItCalendar

IT勉強会カレンダーから[北海道]のタグがついているイベントだけを抜き出して新しいicalファイルを作成します。
一度icalファイルを作成したあとは、差分取得が可能です。

このスクリプトから作成されているカレンダーは以下のURLで公開されています。
https://www.google.com/calendar/embed?src=dal3aqnssjr76f2fpocnnb85h0@group.calendar.google.com&ctz=Asia/Tokyo

## Build and Install to local-machine

    $ gem build hokkaido_it_calendar.gemspec
    $ gem install hokkaido_it_calendar-x.x.x.gem

## Usage

    $ mkdir ~/hokkaido_it_calendar
    $ touch lastaccess
    $ bundle install
    $ hokkaido_it_calendar

'yyyymmddHHMM.ical' created in the ~/hokkaido_it_calendar directory.
You can import that file to your calendar.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
