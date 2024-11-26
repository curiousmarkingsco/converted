# test/converted/jpg_test.rb
require_relative '../test_helper'

class TestConvertedJPG < Minitest::Test
  include TestHelpers

  TMP_DIR = File.join(Dir.pwd, 'tmp')

  def setup
    @input_file = "test/test_assets/image/test_image.jpg"
    @converter = Converted::JPG.new(@input_file)
    FileUtils.mkdir_p(TMP_DIR) # Ensure tmp directory exists for the tests
  end

  def teardown
    FileUtils.rm_rf(TMP_DIR) # Clean up all temporary files after each test
  end

  def test_initialize_with_valid_file
    assert_instance_of Converted::JPG, @converter
  end

  def test_initialize_with_invalid_file
    assert_raises(RuntimeError) { Converted::JPG.new("invalid.jpg") }
  end

  def test_convert_to_gif
    output_file = File.join(TMP_DIR, "test_image.gif")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_gif(output_file)
      assert File.exist?(output_file), "Expected GIF output file to exist"
    end
  end

  def test_convert_to_png
    output_file = File.join(TMP_DIR, "test_image.png")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_png(output_file)
      assert File.exist?(output_file), "Expected PNG output file to exist"
    end
  end

  def test_convert_to_webp
    output_file = File.join(TMP_DIR, "test_image.webp")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_webp(output_file)
      assert File.exist?(output_file), "Expected WEBP output file to exist"
    end
  end

  def test_convert_to_avif
    output_file = File.join(TMP_DIR, "test_image.avif")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_avif(output_file)
      assert File.exist?(output_file), "Expected AVIF output file to exist"
    end
  end

  def test_convert_to_bmp
    output_file = File.join(TMP_DIR, "test_image.bmp")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_bmp(output_file)
      assert File.exist?(output_file), "Expected BMP output file to exist"
    end
  end

  def test_convert_to_ico
    output_file = File.join(TMP_DIR, "test_image.ico")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_ico(output_file)
      assert File.exist?(output_file), "Expected ICO output file to exist"
    end
  end
end
