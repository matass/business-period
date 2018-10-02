# frozen_string_literal: true

RSpec.describe BusinessPeriod::Days do
  include_context 'shared helper'

  it 'correctly calculates from business bay' do
    config('lt', [1, 2, 3, 4, 5])

    expect(BusinessPeriod::Days.call([2, 10])).to eq(
      [
        Time.new(2018, 0o1, 10).to_date,
        Time.new(2018, 0o1, 22).to_date
      ]
    )
  end

  it 'correctly initializes config' do
    config('lt', [5])

    expect(BusinessPeriod::Config.locale).to eq 'lt'
    expect(BusinessPeriod::Config.work_days).to eq [5]
  end

  it 'correctly initializes config with Proc' do
    config_proc('lt', [1, 3, 5])

    expect(BusinessPeriod::Config.locale).to eq 'lt'
    expect(BusinessPeriod::Config.work_days).to eq [1, 3, 5]
  end

  it 'correctly calculates from saturday' do
    saturday
    config('lt', [5])

    expect(BusinessPeriod::Days.call([2, 5])).to eq(
      [
        Time.new(2018, 0o1, 26).to_date,
        Time.new(2018, 0o2, 23).to_date # 02-16 Valstybes atkurimo diena
      ]
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    saturday
    config('lt', [5])

    expect(BusinessPeriod::Days.call([2, 10])).to eq(
      [
        Time.new(2018, 0o1, 26).to_date,
        Time.new(2018, 0o3, 30).to_date
      ]
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    lt_easter_holidays
    config('lt', [2, 4, 5])

    expect(BusinessPeriod::Days.call([2, 5])).to eq(
      [
        Time.new(2018, 0o4, 0o3).to_date,
        Time.new(2018, 0o4, 10).to_date
      ]
    )
  end
end
