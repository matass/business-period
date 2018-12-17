# frozen_string_literal: true

RSpec.describe BusinessPeriod::Base do
  include_context 'shared helper'

  context '#holidays' do
    it 'gets LT holidays config file' do
      config('lt', nil)
      expect(described_class.new.holidays).not_to eq(nil)
    end

    it 'gets ET holidays config file' do
      config('et', nil)
      expect(described_class.new.holidays).not_to eq(nil)
    end

    it 'gets LV holidays config file' do
      config('lv', nil)
      expect(described_class.new.holidays).not_to eq(nil)
    end
  end
end
