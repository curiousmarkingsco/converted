# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "converted"
require 'minitest/autorun'
require 'fileutils'
require_relative '../lib/converted'

module TestHelpers
  # Helper to clean up generated files after tests
  def remove_file(file_path)
    FileUtils.rm_f(file_path) if File.exist?(file_path)
  end
end
