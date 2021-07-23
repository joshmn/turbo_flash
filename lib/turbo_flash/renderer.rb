# frozen_string_literal: true

module TurboFlash
  module Renderer
    def render(*args)
      result = super
      if request.format.turbo_stream?
        flash_turbo_options = flash.turbo.options
        flash.turbo.instance_variable_get(:@flash).instance_variable_get(:@flashes).each do |key, _value|
          flash_options = flash_turbo_options[key]
          result << turbo_stream.send(flash_options.delete(:action), flash_options.delete(:target), **flash_options)
        end
      end
      result
    end
  end
end
