# frozen_string_literal: true

module TurboFlash
  module Renderer
    def render(*args)
      result = super
      if request.format.turbo_stream?
        return result if flash.turbo.cleared?

        flashed = false
        flash_turbo_options = flash.turbo.options
        flash.turbo.flashes.each do |key, value|
          flash_options = flash_turbo_options[key]
          if TurboFlash.configuration.inherit_flashes?
            flash.turbo.from_flash(key, value)
            flash_options = flash_turbo_options[key]
          end

          if flash_options.nil?
            flash.discard(key)
            next
          end

          result << turbo_stream.send(flash_options.delete(:action), flash_options.delete(:target), **flash_options)
          flashed = true
          flash.turbo.flash.discard(key)
        end

        flash.clear

        puts "flashed? #{flashed}"
        puts "Clear unless flashed: #{TurboFlash.configuration.clear_target_unless_flashed?}"
        puts "flash.turbo.clear_target : #{flash.turbo.clear_target?}"
        if (!flashed && TurboFlash.configuration.clear_target_unless_flashed?) || flash.turbo.clear_target?
          result << turbo_stream.send(:update, TurboFlash.configuration.target) do
            ""
          end
          flash.turbo.reset_clear_target!
        end
      end
      result
    end
  end
end
