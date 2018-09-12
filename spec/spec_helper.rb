# frozen_string_literal: true

require 'bundler/setup'
require 'business_period'

RSpec.configure(&:disable_monkey_patching!)

RSpec.shared_context 'shared helper', shared_context: :metadata do
  before do
    allow(Time).to receive(:now).and_return(Time.new(2018, 1, 8))
  end

  let(:saturday) do
    allow(Time).to receive(:now).and_return(Time.new(2018, 1, 11))
  end

  def config(locale, work_days)
    BusinessPeriod.configure do |config|
      config.locale = locale if locale
      config.work_days = work_days if work_days
    end
  end
end
