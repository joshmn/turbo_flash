# frozen_string_literal: true

module TurboFlash
  class Configuration
    attr_accessor :target, :action, :partial, :key, :value

    def initialize
      @target = 'flash'
      @action = :append
      @partial = 'shared/flash'
      @key = :role
      @value = :message
    end
  end
end
