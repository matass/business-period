# frozen_string_literal: true

require 'singleton'

module BusinessPeriod
  class Config
    include Singleton

    attr_accessor :locale, :work_days, :origin

    def self.locale=(str)
      instance.locale = str
    end

    def self.locale
      instance.locale.class == Proc ? instance.locale.call : instance.locale
    end

    def self.work_days=(arr)
      instance.work_days = arr
    end

    def self.work_days
      instance.work_days.class == Proc ? instance.work_days.call : instance.work_days
    end

    def self.origin=(arr)
      instance.origin = arr
    end

    def self.origin
      instance.origin.class == Proc ? instance.origin.call : instance.origin
    end
  end
end
