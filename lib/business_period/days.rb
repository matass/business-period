# frozen_string_literal: true

module BusinessPeriod
  class Days < Base
    def self.call(from_date:, to_date:, options: {})
      new.perform(from_date, to_date, options)
    end

    def perform(from_date, to_date, options)
      @from_date = from_date
      @to_date = to_date
      @options = options

      return [] unless valid_params

      period = calculate_period(@to_date, @options)
      days = business_days(period)
      result = extract_holidays(days).compact

      {
        from_date: result[@from_date][:day],
        to_date: result[@to_date][:day]
      }
    end

    private

    def valid_params
      valid_options &&
        @from_date.is_a?(Integer) && @to_date.is_a?(Integer) &&
        @from_date >= 0 && @to_date >= 0 &&
        (@from_date <= @to_date)
    end

    def valid_options
      @options ? origin_present? : true
    end

    def origin_present?
      return unless @options.is_a?(Hash)

      @options[:origin] ? (@options[:origin].methods.include? :strftime) : true
    end

    def extract_holidays(days)
      days.map.with_index do |day, idx|
        years = holidays[day[:day].year]

        next unless years && years['months'][day[:month]]

        day unless first_day_is_holiday?(idx, years, day)
      end
    end

    def first_day_is_holiday?(idx, years, day)
      include_day = years['months'][day[:month]].map { |d| d['mday'] }

      if idx.zero? && (include_day.include? day[:day].day)
        @from_date -= 1
        @to_date -= 1
      end

      (include_day.include? day[:day].day)
    end

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
  end
end
