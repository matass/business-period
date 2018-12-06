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

    def business_days(period)
      period.each_with_object([]) do |day, container|
        next unless config.work_days.include?(day.wday)

        container <<
          {
            day: day,
            month: day.to_time.month
          }
      end
    end

    def check_holidays(business_days)
      business_days.each_with_index do |day, index|
        next unless holidays[day[:month]]

        holidays[day[:month]].each do |holiday|
          business_days.delete_at(index) if holiday['mday'] == day[:day].mday
        end
      end
    end
  end
end
