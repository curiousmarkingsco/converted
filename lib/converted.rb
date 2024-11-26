# frozen_string_literal: true

require_relative "converted/version"
require_relative 'converted/mp4'
require_relative 'converted/png'
require_relative 'converted/gif'
require_relative 'converted/jpg'

module Converted
  class Error < StandardError; end
end
