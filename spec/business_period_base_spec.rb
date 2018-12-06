# frozen_string_literal: true

RSpec.describe BusinessPeriod::Base do
  include_context 'shared helper'

  context '#holidays' do
    it 'gets holidays config file' do
      config('lt', nil)
      expect(BusinessPeriod::Base.new.holidays).not_to eq(nil)
    end
  end
end
