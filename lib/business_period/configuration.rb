# frozen_string_literal: true

module BusinessPeriod
  attr_accessor :configuration

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :locale, :work_days
  end
end
