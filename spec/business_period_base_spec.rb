# frozen_string_literal: true

RSpec.describe BusinessPeriod::Base do
  include_context 'shared helper'

  context '#holidays' do
    it 'gets holidays config file' do
      config('lt', nil)
      expect(BusinessPeriod::Base.new.holidays).not_to eq(nil)
    end
  end

  context '#calculate_days_to_add_to' do
    it 'correctly calculates how many days to add to plot end
        when there is only one business day in the week' do

      config(nil, [1])

      expect(
        BusinessPeriod::Base.new.calculate_days_to_add_to(2, 4)
      ).to be >= 31
    end

    it 'correctly calculates how many days to add to plot end
        when the whole week is business time' do

      config(nil, [1, 2, 3, 4, 5, 6, 7])

      expect(
        BusinessPeriod::Base.new.calculate_days_to_add_to(2, 4)
      ).to be >= 7
    end
  end
end
