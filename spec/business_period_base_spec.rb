# frozen_string_literal: true

RSpec.describe BusinessPeriod::Base do
  include_context 'shared helper'

  context '#holidays' do
    it 'gets LT holidays config file' do
      config('lt', nil)
      expect(BusinessPeriod::Base.new.holidays).not_to eq(nil)
    end

    it 'gets ET holidays config file' do
      config('et', nil)
      expect(BusinessPeriod::Base.new.holidays).not_to eq(nil)
    end
  end
end
