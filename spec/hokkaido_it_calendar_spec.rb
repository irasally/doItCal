require 'spec_helper'

module HokkaidoItCalendar
  describe HokkaidoItCalendar do
    describe '#writedate' do
      before do
        File.stub(:open).with(HokkaidoItCalendar::DATETIME_FILE_NAME, 'w').and_return(file)
        DateTime.stub(:now).and_return(now)
      end

      let(:now) { DateTime.parse('2012-06-03T0:37:10+9:00') }
      let(:file) { double('file').as_null_object }

      it 'should write now date to file' do
        file.should_receive(:write).with(now.to_s)
        subject.send(:writedate)
      end
    end
  end
end
