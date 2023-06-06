# frozen_string_literal: true

require 'turbo_flash/version'
require 'turbo_flash/railtie'

require 'turbo_flash/configuration'
require 'turbo_flash/flash_turbo'
require 'turbo_flash/renderer'

module TurboFlash
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end
