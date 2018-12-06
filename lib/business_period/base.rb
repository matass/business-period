# frozen_string_literal: true

module BusinessPeriod
  class Base
    def config
      @config ||= Config
    end

    def calculate_period(to_date)
      @calculate_period ||= begin
        finish = DateTime.now.next_day(to_date).to_date

        Time.now.to_date..finish
      end
    end

    def holidays
      @holidays ||= YAML.load_file(File.join(holiday_config)).fetch('months')
    end

    private

    def holiday_config
      [File.dirname(__FILE__), "../../config/holidays/#{config.locale}.yml"]
    end
  end
end
