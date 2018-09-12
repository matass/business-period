# frozen_string_literal: true

module BusinessPeriod
  class Base
    def config
      @config ||= BusinessPeriod.configuration
    end

    # Returns range of days
    # Plot is our given period. E.g. [2, 4]
    def calculate_period(plot)
      @calculate_period ||= begin
        imaginable_last_day = calculate_days_to_add_to(plot)

        # converts days to seconds
        days_to_add = days_to_seconds(imaginable_last_day)

        # Adds expected last day to current day
        finish = Time.now + days_to_add

        # Builds an array from current time to imaginable end time
        Time.now.to_date..finish.to_date
      end
    end

    # Sets holiday instance by given file location
    def holidays
      @holidays ||= YAML.load_file(File.join(holiday_config)).fetch('months')
    end

    # Dynamically calculates how many days we have add to plot end
    def calculate_days_to_add_to(plot)
      # Calculates subjective number
      sum = (7 - config.work_days.size)

      # sum cannot be zero.
      # Relevant when when work_days array == [1, 2, 3, 4, 5, 6, 7]
      sum = 1 if sum.zero?

      # Some magic
      (plot.last - plot.first) * 2 * sum + 7
    end

    private

    # Gets path to config file by given locale
    def holiday_config
      [File.dirname(__FILE__), "../../config/holidays/#{config.locale}.yml"]
    end

    def days_to_seconds(days)
      days * 60 * 60 * 24
    end
  end
end
