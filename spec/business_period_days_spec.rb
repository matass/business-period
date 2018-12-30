# frozen_string_literal: true

RSpec.describe BusinessPeriod::Days do
  include_context 'shared helper'

  it 'correctly calculates from business day' do
    config('lt', [1, 2, 3, 4, 5])

    expect(described_class.call(2, 10, options)).to eq(
      from_date: Time.new(2018, 1, 10).to_date,
      to_date: Time.new(2018, 1, 22).to_date
    )
  end

  it 'correctly calculates from saturday' do
    saturday
    config('lt', [5])

    expect(described_class.call(2, 5)).to eq(
      from_date: Time.new(2018, 2, 2).to_date,
      to_date: Time.new(2018, 3, 2).to_date
    )
  end

  it 'correctly calculates from sunday when the first day is sunday' do
    config('lt', [1, 2, 3, 4, 5])
    sunday

    expect(described_class.call(0, 2, options)).to eq(
      from_date: Time.new(2018, 1, 22).to_date,
      to_date: Time.new(2018, 1, 24).to_date
    )
  end

  it 'correctly calculates from saturday when ends on holiday' do
    saturday
    config('lt', [5])

    expect(described_class.call(2, 10)).to eq(
      from_date: Time.new(2018, 2, 2).to_date,
      to_date: Time.new(2018, 4, 6).to_date
    )
  end

  it 'correctly calculates from holiday' do
    lt_easter_holidays
    config('lt', [2, 4, 5])

    expect(described_class.call(2, 5, options)).to eq(
      from_date: Time.new(2018, 4, 3).to_date,
      to_date: Time.new(2018, 4, 10).to_date
    )
  end

  it 'correctly calculates from ET spring day holiday' do
    et_spring_day
    config('et', [4, 5])

    expect(described_class.call(1, 4)).to eq(
      from_date: Time.new(2019, 5, 3).to_date,
      to_date: Time.new(2019, 5, 16).to_date
    )
  end

  it 'correctly calculates from LV National Day holiday' do
    lv_national_day # 04 - 19
    config('lv', [1, 3, 5])

    expect(described_class.call(3, 4)).to eq(
      from_date: Time.new(2019, 5, 3).to_date,
      to_date: Time.new(2019, 5, 8).to_date
    )
  end

  it 'correctly calculates from today' do
    config('lt', [1, 2, 3, 4, 5])

    expect(described_class.call(0, 2)).to eq(
      from_date: Time.new(2018, 1, 8).to_date,
      to_date: Time.new(2018, 1, 10).to_date
    )
  end

  describe 'when passing nil parrams' do
    it 'returns empty array (from_date param is nil)' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(described_class.call(nil, 30)).to eq([])
    end

    it 'returns empty array (to_date param is nil)' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(described_class.call(30, nil)).to eq([])
    end

    it 'returns empty array (from_date and to_date params are nils)' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(described_class.call(nil, nil)).to eq([])
    end

    it 'returns empty array (from_date, to_date and options params are nils)' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(described_class.call(nil, nil, nil)).to eq([])
    end
  end

  describe 'when passing hashes or arrays' do
    it 'returns empty array (from_date and to_date params are empty arrays)' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(described_class.call([], [])).to eq([])
    end

    it 'returns empty array when both from_date and to_date params are empty hashes' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(described_class.call({}, {})).to eq([])
    end
  end

  describe 'when passing not numeric chars' do
    it 'returns empty array' do
      lt_easter_holidays
      config('lt', [2, 4, 5])

      expect(described_class.call('a', 'b')).to eq([])
    end
  end

  describe 'when from_date > to_date' do
    it 'returns empty array' do
      config('lt', [1, 2, 3, 4, 5])

      expect(described_class.call(1, 0)).to eq([])
    end
  end

  describe 'when primary_day param is not Date/DateTime/Time' do
    it 'returns empty array' do
      config('lt', [1, 2, 3, 4, 5])

      expect(described_class.call(1, 2, { primary_day: 1 })).to eq([])
    end
  end

  describe 'when from_date == to_date' do
    it 'returns calculated result' do
      config('lt', [1, 2, 3, 4, 5])

      expect(described_class.call(1, 1)).to_not eq([])
    end
  end

  describe 'when primary_day param is valid' do
    it 'calculates period correctly' do
      config('lt', [1, 2, 3, 4, 5])

      custom_2017_12_29 = days_to_move_back(10)
      options = { primary_day: custom_2017_12_29 }

      expect(described_class.call(1, 1, options)).to eq(
        from_date: Time.new(2018, 1, 2).to_date,
        to_date: Time.new(2018, 1, 2).to_date
      )
    end

    it 'calculates period correctly when today is saturday and primary_day is tuesday' do
      config('lt', [1, 2, 3, 4, 5])
      saturday

      custom_2018_1_11 = days_to_move_back(2)
      options = { primary_day: custom_2018_1_11 }

      expect(described_class.call(1, 5, options )).to eq(
        from_date: Time.new(2018, 1, 12).to_date,
        to_date: Time.new(2018, 1, 18).to_date
      )
    end

    it 'calculates period correctly when today is sunday and primary_day is saturday' do
      config('lt', [1, 2, 3, 4, 5])
      sunday

      custom_2018_1_20 = days_to_move_back(1)
      options = { primary_day: custom_2018_1_20 }

      expect(described_class.call(1, 5, options: options)).to eq(
        from_date: Time.new(2018, 1, 23).to_date,
        to_date: Time.new(2018, 1, 29).to_date
      )
    end

    it 'calculates period correctly when today is sunday and primary_day is friday' do
      config('lt', [1, 2, 3, 4, 5])
      sunday

      custom_2018_1_19 = days_to_move_back(2)
      options = { primary_day: custom_2018_1_19 }

      expect(described_class.call(1, 5, options)).to eq(
        from_date: Time.new(2018, 1, 22).to_date,
        to_date: Time.new(2018, 1, 26).to_date
      )
    end
  end

  context 'calls self' do
    2000.times do
      day = rand(356)
      days = rand(356)

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

      it "raises no errors. work_days: [1, 2, 3, 4, 5, 6], interval: [#{day} – #{days}]" do
        expecter([1, 2, 3, 4, 5, 6], day, days)
      end

      it "raises no errors. work_days: [1, 2, 3, 4, 5, 6, 7], interval: [#{day} – #{days}]" do
        expecter([1, 2, 3, 4, 5, 7], day, days)
      end
    end
  end
end
