# frozen_string_literal: true

# TODO: this is ugly af, but it works
module TurboFlash
  class FlashTurbo < ::ActionDispatch::Flash::FlashNow
    attr_reader :options

    def initialize(flash)
      super
      @copied_flashes = false
      @temp_options = nil
      @default_render_target = TurboFlash.configuration.target
      @default_render_options = { action: TurboFlash.configuration.action, partial: TurboFlash.configuration.partial }
      @locals_key = TurboFlash.configuration.key
      @locals_value = TurboFlash.configuration.value
      @options = {}
      @clear_target = false
      @cleared = false
    end

    def copied_flashes?
      @copied_flashes
    end

    def from_flashes(other_flashes, options)
      other_flashes.each do |k,v|
        from_flash(k, v, options)
      end
      @copied_flashes = true

      true
    end

    def cleared?
      @cleared
    end

    def unclear!
      @cleared = false
    end

    def clear!
      @cleared = true
    end

    def from_flash(k, v, options = {})
      set_options(options)[k] = v

      true
    end

    def clear_target?
      @clear_target
    end

    def clear_target!
      @clear_target = true
    end

    def reset_clear_target!
      @clear_target = false
    end

    def flashes
      @flash.instance_variable_get(:@flashes)
    end

    def []=(k, v)
      super
      @options_for_flash = {}
      @options_for_flash = @default_render_options.dup
      @options_for_flash.merge!({ target: @default_render_target })
      @options_for_flash[:locals] = {
        @locals_key => k,
        @locals_value => v
      }
      if @temp_options
        @options_for_flash.merge!(@temp_options)
        @temp_options = nil
      end

      @options[k.to_s] = @options_for_flash
      v
    end

    def set_options(options = {})
      @temp_options = options
      self
    end
  end
end
