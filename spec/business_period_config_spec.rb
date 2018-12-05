# frozen_string_literal: true

RSpec.describe BusinessPeriod::Config do
  include_context 'shared helper'

  describe 'initialization' do
    it 'correctly initializes when assigning Config.locale and Config.work_days' do
      config('lt', [5])

      expect(BusinessPeriod::Config.locale).to eq 'lt'
      expect(BusinessPeriod::Config.work_days).to eq [5]
    end

    it 'correctly initializes config with Proc block parameters' do
      config_proc('lt', [1, 3, 5])

      expect(BusinessPeriod::Config.locale).to eq 'lt'
      expect(BusinessPeriod::Config.work_days).to eq [1, 3, 5]
    end
  end
end
