# frozen_string_literal: true

RSpec.describe BusinessPeriod::Days do
  include_context 'shared helper'

  it 'correctly calculates from business bay' do
    config('lt', [1, 2, 3, 4, 5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 10)).to eq(
      from_date: Time.new(2018, 1, 10).to_date,
      to_date: Time.new(2018, 1, 22).to_date
    )
  end

  it 'correctly calculates from saturday' do
    saturday
    config('lt', [5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 5)).to eq(
      from_date: Time.new(2018, 1, 26).to_date,
      to_date: Time.new(2018, 2, 23).to_date # 02-16 Valstybes atkurimo diena
    )
  end

  it 'correctly calculates from sunday when the first day is sunday' do
    config('lt', [1, 2, 3, 4, 5])
    sunday

    expect(BusinessPeriod::Days.call(from_date: 0, to_date: 2)).to eq(
      from_date: Time.new(2018, 1, 22).to_date,
      to_date: Time.new(2018, 1, 24).to_date
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    saturday
    config('lt', [5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 10)).to eq(
      from_date: Time.new(2018, 1, 26).to_date,
      to_date: Time.new(2018, 3, 30).to_date
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    lt_easter_holidays
    config('lt', [2, 4, 5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 5)).to eq(
      from_date: Time.new(2018, 4, 3).to_date,
      to_date: Time.new(2018, 4, 10).to_date
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    lt_easter_holidays
    config('lt', [2, 4, 5])

    expect(BusinessPeriod::Days.call(from_date: 2, to_date: 5)).to eq(
      from_date: Time.new(2018, 4, 3).to_date,
      to_date: Time.new(2018, 4, 10).to_date
    )
  end

  it 'correctly calculates from today' do
    config('lt', [1, 2, 3, 4, 5])

    expect(BusinessPeriod::Days.call(from_date: 0, to_date: 2)).to eq(
      from_date: Time.new(2018, 1, 8).to_date,
      to_date: Time.new(2018, 1, 10).to_date
    )
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

  describe 'when passing hashes or arrays' do
    it 'returns empty hash when both from_date and to_date params are empty arrays' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(BusinessPeriod::Days.call(from_date: [], to_date: [])).to eq({})
    end

    it 'returns empty hash when both from_date and to_date params are empty hashes' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(BusinessPeriod::Days.call(from_date: {}, to_date: {})).to eq({})
    end
  end

  describe 'when passing not numeric chars' do
    it 'returns empty hash when both from_date and to_date are not numeric' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(BusinessPeriod::Days.call(from_date: 'a', to_date: 'b')).to eq({})
    end
  end

  context 'calls self' do
    2000.times do
      day = rand(356)
      days = rand(356)

      next unless day < days

      it "raises no errors. work_days: [1], interval: [#{day} – #{days}]" do
        expecter([1], day, days)
      end

      it "raises no errors. work_days: [1, 2], interval: [#{day} – #{days}]" do
        expecter([1, 2], day, days)
      end

      it "raises no errors. work_days: [1, 2, 3], interval: [#{day} – #{days}]" do
        expecter([1, 2, 3], day, days)
      end

      it "raises no errors. work_days: [1, 2, 3, 4], interval: [#{day} – #{days}]" do
        expecter([1, 2, 3, 4], day, days)
      end

      it "raises no errors. work_days: [1, 2, 3, 4, 5], interval: [#{day} – #{days}]" do
        expecter([1, 2, 3, 4, 5], day, days)
      end

      it "raises no errors. work_days: [1, 2, 3, 4, 5], interval: [#{day} – #{days}]" do
        expecter([1, 2, 3, 4, 5, 6], day, days)
      end

      it "raises no errors. work_days: [1, 2, 3, 4, 5], interval: [#{day} – #{days}]" do
        expecter([1, 2, 3, 4, 5, 7], day, days)
      end
    end
  end
end
