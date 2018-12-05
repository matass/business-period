# frozen_string_literal: true

RSpec.describe BusinessPeriod::Days do
  include_context 'shared helper'

  it 'correctly calculates from business bay' do
    config('lt', [1, 2, 3, 4, 5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 10)).to eq(
      from_date: Time.new(2018, 0o1, 10).to_date,
      to_date: Time.new(2018, 0o1, 22).to_date
    )
  end

  it 'correctly calculates from saturday' do
    saturday
    config('lt', [5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 5)).to eq(
      from_date: Time.new(2018, 0o1, 26).to_date,
      to_date: Time.new(2018, 0o2, 23).to_date # 02-16 Valstybes atkurimo diena
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    saturday
    config('lt', [5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 10)).to eq(
      from_date: Time.new(2018, 0o1, 26).to_date,
      to_date: Time.new(2018, 0o3, 30).to_date
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    lt_easter_holidays
    config('lt', [2, 4, 5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 5)).to eq(
      from_date: Time.new(2018, 0o4, 0o3).to_date,
      to_date: Time.new(2018, 0o4, 10).to_date
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    lt_easter_holidays
    config('lt', [2, 4, 5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 5)).to eq(
      from_date: Time.new(2018, 0o4, 0o3).to_date,
      to_date: Time.new(2018, 0o4, 10).to_date
    )
  end

  it 'returns emty hash when from_date > to_date' do
    config('lt', [2])

    expect(BusinessPeriod::Days.call(from_date: 20, to_date: 5)).to eq({})
  end

  describe 'when passing nil parrams' do
    it 'returns empty hash when from_date param is nil' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(BusinessPeriod::Days.call(from_date: nil, to_date: 30)).to eq({})
    end

    it 'returns empty hash when to_date param is nil' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(BusinessPeriod::Days.call(from_date: 30, to_date: nil)).to eq({})
    end

    it 'returns empty hash when both from_date and to_date params are nils' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(BusinessPeriod::Days.call(from_date: nil, to_date: nil)).to eq({})
    end
  end

  context 'calls self' do
    2000.times do |index|
      day = rand(356)
      days = rand(356)

      next unless day < days

      it "raises no errors according to given interval: [#{day} – #{days}]" do
        config('lt', [5])

        expect { BusinessPeriod::Days.call(from_date: 1, to_date: 20) }
          .to_not raise_error
      end
    end
  end
end
