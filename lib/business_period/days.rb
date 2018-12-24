# frozen_string_literal: true

module BusinessPeriod
  class Days < Base
    def self.call(from_date = nil, to_date = nil, options = {})
      new.perform(from_date, to_date, options)
    end

    def perform(from_date, to_date, options)
      return [] unless valid_params(from_date, to_date, options)

      period = calculate_period(to_date, options)
      result = business_days(period)

      {
        from_date: result[from_date][:day],
        to_date: result[to_date][:day]
      }
    end

    private

    def valid_params(from_date, to_date, options)
      valid_options(options) &&
        from_date.is_a?(Integer) && to_date.is_a?(Integer) &&
        from_date >= 0 && to_date >= 0 &&
        (from_date <= to_date)
    end

    def valid_options(options)
      options ? primary_day_present?(options) : true
    end

    def primary_day_present?(options)
      return unless options.is_a?(Hash)

      options[:primary_day] ? (options[:primary_day].methods.include? :strftime) : true
    end

    def business_days(period)
      period.each_with_object([]) do |day, container|
        next unless config.work_days.include?(day.wday)

        next if holidays.flatten.include? holiday_month_with_day(day.month, day.day)

        container << { day: day }
      end
    end
  end
end
