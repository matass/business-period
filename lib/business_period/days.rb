# frozen_string_literal: true

module BusinessPeriod
  class Days < Base
    def initialize(locale = nil, work_days = nil)
      BusinessPeriod.configure do |config|
        config.locale = locale if locale
        config.work_days = work_days if work_days
      end
    end

    def self.call(plot)
      new.perform(plot)
    end

    def perform(plot)
      @period = calculate_period(plot)
      @days = business_days

      check_holidays

      # Selects business days from given plot.
      # E.g plot = [2, 4], selects second and fourth elements
      plot.map { |param| @days[param][:day] }
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
