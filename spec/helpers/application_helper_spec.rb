require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'application_helper' do
    let(:time) { Time.now }

    it 'demonstrates in_ist returns time in IST standard' do
      expect(in_ist(time)).to eq(time.in_time_zone("Chennai"))
    end

    it 'demonstrates displayable_time returns custom time created' do
      expect(displayable_time(time)).to eq(in_ist(time).strftime("%I:%M %p"))
    end

    it 'demonstrates displayable_date returns custom date created' do
      expect(displayable_date(time)).to eq(in_ist(time).strftime("%A, #{time.day.ordinalize}, %B"))
    end
  end
  
end