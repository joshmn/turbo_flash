# frozen_string_literal: true

require 'turbo_flash/renderer'
require 'turbo_flash/flash_hash'

module TurboFlash
  class Railtie < ::Rails::Railtie
    initializer 'turbo_flash.initialize' do
      ::ActiveSupport.on_load(:action_controller) do
        ActionController::Base.include TurboFlash::Renderer
        ActionDispatch::Flash::FlashHash.include TurboFlash::FlashHash
      end
    end
  end
end
