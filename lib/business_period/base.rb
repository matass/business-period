# frozen_string_literal: true

module BusinessPeriod
  class Base
    def config
      @config ||= Config
    end

    # Returns range of days
    def calculate_period(to_date)
      @calculate_period ||= begin
        finish = DateTime.now.next_day(to_date).to_date

        # Builds an array from current time to imaginable end time
        Time.now.to_date..finish
      end
    end

    # Sets holiday instance by given file location
    def holidays
      @holidays ||= YAML.load_file(File.join(holiday_config)).fetch('months')
    end

    private

    # Gets path to config file by given locale
    def holiday_config
      [File.dirname(__FILE__), "../../config/holidays/#{config.locale}.yml"]
    end
  end
end
