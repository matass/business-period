# frozen_string_literal: true

module BusinessPeriod
  class Days < Base
    def self.call(from_date:, to_date:)
      new.perform(from_date, to_date)
    end

    def perform(from_date, to_date)
      return {} if from_date.nil? || to_date.nil?
      return {} if from_date > to_date

      @period = calculate_period(from_date, to_date)
      @days = business_days

      check_holidays

      # Selects business days from given from_date and to_date values.
      # E.g from_date = 2, to_date = 4
      # selects second and fourth elements
      {
        from_date: @days[from_date][:day],
        to_date: @days[to_date][:day]
      }
    end

    private

    # Maps business days to array by given calculated period
    def business_days
      @business_days ||= @period.map do |day|
        # checks if day is business day
        if config.work_days.include?(day.wday)
          { day: day, month: day.to_time.month }
        end
      end.compact
    end

    # Removes business days which are on holidays
    def check_holidays
      @days.each_with_index do |day, index|
        # Skips if no holiday in the current month
        next unless holidays[day[:month]]

        extract_holidays(day, index)
      end
    end

    def extract_holidays(day, index)
      holidays[day[:month]].each do |holiday|
        @days.delete_at(index) if holiday['mday'] == day[:day].mday
      end
    end
  end
end
