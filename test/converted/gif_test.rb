# test/converted/gif_test.rb
require_relative '../test_helper'

class TestConvertedGIF < Minitest::Test
  include TestHelpers

  TMP_DIR = File.join(Dir.pwd, 'tmp')

  def setup
    @input_file = "test/test_assets/image/test_image.gif"
    @converter = Converted::GIF.new(@input_file)
    FileUtils.mkdir_p(TMP_DIR) # Ensure tmp directory exists for the tests
  end

  def teardown
    FileUtils.rm_rf(TMP_DIR) # Clean up all temporary files after each test
  end

  def test_initialize_with_valid_file
    assert_instance_of Converted::GIF, @converter
  end

  def test_initialize_with_invalid_file
    assert_raises(RuntimeError) { Converted::GIF.new("invalid.gif") }
  end

  def test_convert_to_jpg
    output_file = File.join(TMP_DIR, "test_image.jpg")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_jpg(output_file)
      assert File.exist?(output_file), "Expected JPG output file to exist"
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

  def test_convert_to_bmp_without_transparency
    output_file = File.join(TMP_DIR, "test_image.bmp")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_bmp(output_file, with_transparency: false)
      assert File.exist?(output_file), "Expected BMP output file to exist"
    end
  end

  def test_convert_to_bmp_with_transparency
    output_file = File.join(TMP_DIR, "test_image_transparent.bmp")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_bmp(output_file, with_transparency: true)
      assert File.exist?(output_file), "Expected transparent BMP output file to exist"
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

  def test_convert_to_webm
    output_file = File.join(TMP_DIR, "test_image.webm")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_webm(output_file)
      assert File.exist?(output_file), "Expected WEBM output file to exist"
    end
  end

  def test_convert_to_avi
    output_file = File.join(TMP_DIR, "test_image.avi")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_avi(output_file)
      assert File.exist?(output_file), "Expected AVI output file to exist"
    end
  end

  def test_convert_to_mp4
    output_file = File.join(TMP_DIR, "test_image.mp4")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_mp4(output_file)
      assert File.exist?(output_file), "Expected MP4 output file to exist"
    end
  end
end
