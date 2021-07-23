# frozen_string_literal: true

require 'turbo_flash/flash_turbo'

module TurboFlash
  module FlashHash
    def turbo
      @turbo ||= ::TurboFlash::FlashTurbo.new(self)
    end
  end
end
