# frozen_string_literal: true

module BusinessPeriod
  class Days < Base
    def self.call(from_date:, to_date:)
      new.perform(from_date, to_date)
    end

    def perform(from_date, to_date)
      return {} if
        from_date.is_a?(Array) || to_date.is_a?(Array) ||
        from_date.nil? || to_date.nil? ||
        from_date > to_date

      period = calculate_period(to_date)
      days = business_days(period)

      check_holidays(days)

      {
        from_date: days[from_date][:day],
        to_date: days[to_date][:day]
      }
    end

    private

    def validate_params(from_date, to_date)
      return {} if
        from_date.is_a?(Array) || to_date.is_a?(Array) ||
        from_date.nil? || to_date.nil? ||
        from_date > to_date
    end

    def business_days(period)
      period.map do |day|
        if config.work_days.include?(day.wday)
          { day: day, month: day.to_time.month }
        end
      end.compact
    end

    def check_holidays(days)
      days.each_with_index do |day, index|
        next unless holidays[day[:month]]

        extract_holidays(days, day, index)
      end
    end

    def extract_holidays(days, day, index)
      holidays[day[:month]].map do |holiday|
        days.delete_at(index) if holiday['mday'] == day[:day].mday
      end
    end
  end
end
