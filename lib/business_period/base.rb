# frozen_string_literal: true

module BusinessPeriod
  class Base
    def config
      @config ||= Config
    end

    def calculate_period(to_date)
      magic_number = 15 - config.work_days.size
      days_to_add = days_to_seconds(to_date * magic_number)
      finish = Time.now + days_to_add
      Time.now.to_date..finish.to_date
    end

    def holidays
      @holidays ||= YAML.load_file(File.join(holiday_config)).fetch('months')
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
