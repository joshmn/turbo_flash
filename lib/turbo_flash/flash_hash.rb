# frozen_string_literal: true

require 'turbo_flash/flash_turbo'

module TurboFlash
  module FlashHash
    # create a Flash::Turbo instance.
    #
    # Behaves just like `flash.now`, but gets injected into your TurboStream response.
    #
    #   flash.turbo[:notice] = "There was an error"
    def turbo
      @turbo ||= ::TurboFlash::FlashTurbo.new(self)
    end

    # Copy over flashes
    def turbo!(options = {})
      turbo.from_flashes(@flashes, options)

      true
    end
  end
end
