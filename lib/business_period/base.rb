# frozen_string_literal: true

module BusinessPeriod
  class Base
    def config
      @config ||= Config
    end

    def calculate_period(to_date, options = nil)
      magic_number = 15 - config.work_days.size
      days_to_add = days_to_seconds(to_date * magic_number)
      start_date = options[:origin] || Time.now
      finish = start_date + days_to_add
      start_date.to_date..finish.to_date
    end

    def holidays
      @holidays ||= YAML.load_file(File.join(holiday_config)).fetch('years')
    end

    private

    def holiday_config
      [File.dirname(__FILE__), "../../config/holidays/#{config.locale}.yml"]
    end

    def days_to_seconds(days)
      days * 60 * 60 * 24
    end
  end
end
