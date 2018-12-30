# frozen_string_literal: true

require 'bundler/setup'
require 'business-period'

RSpec.configure(&:disable_monkey_patching!)

RSpec.shared_context 'shared helper', shared_context: :metadata do
  before do
    allow(Time).to receive(:now).and_return(Time.new(2018, 1, 8))
  end

  let(:saturday) do
    allow(Time).to receive(:now).and_return(Time.new(2018, 1, 13))
  end

  let(:sunday) do
    allow(Time).to receive(:now).and_return(Time.new(2018, 1, 21))
  end

  let(:lt_easter_holidays) do
    allow(Time).to receive(:now).and_return(Time.new(2018, 3, 29))
  end

  let(:et_spring_day) do
    allow(Time).to receive(:now).and_return(Time.new(2019, 5, 1))
  end

  let(:lv_national_day) do
    allow(Time).to receive(:now).and_return(Time.new(2019, 4, 19))
  end

  def days_to_move_back(days)
    Time.now - days * 3600 * 24
  end

  def options
    { primary_day: Time.now }
  end

  def config(locale, work_days)
    BusinessPeriod::Config.locale = locale
    BusinessPeriod::Config.work_days = work_days
  end

  def config_proc(locale, work_days)
    BusinessPeriod::Config.locale = -> { locale }
    BusinessPeriod::Config.work_days = -> { work_days }
  end

  def expecter(work_days, day, days)
    config('lt', work_days)

    expect { BusinessPeriod::Days.call(from_date: day, to_date: days) }
      .to_not raise_error
  end
end
