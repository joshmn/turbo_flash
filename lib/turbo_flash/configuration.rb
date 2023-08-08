# frozen_string_literal: true

module TurboFlash
  class Configuration
    attr_accessor :target, :action, :partial, :key, :value, :clear_unless_flashed, :inherit_flashes

    def initialize
      @target = 'flash'
      @action = :update
      @partial = 'shared/flash'
      @key = :role
      @value = :message
      @clear_target_unless_flashed = true
      @inherit_flashes = true
    end

    def inherit_flashes?
      @inherit_flashes
    end

    def clear_target_unless_flashed?
      @clear_target_unless_flashed
    end

    def object_partial?
      # check if the partial is a defined class
      @partial.is_a?(String) && @partial.split('/').map(&:camelize).join('::').safe_constantize.present?
    end
  end
end
