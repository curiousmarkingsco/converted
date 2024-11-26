# test/converted/mp4_test.rb
require_relative '../test_helper'

class TestConvertedMP4 < Minitest::Test
  include TestHelpers

  TMP_DIR = File.join(Dir.pwd, 'tmp')

  def setup
    @input_file = "test/test_assets/video/test_video.mp4"
    @converter = Converted::MP4.new(@input_file)
    FileUtils.mkdir_p(TMP_DIR) # Ensure tmp directory exists for the tests
  end

  def teardown
    FileUtils.rm_rf(TMP_DIR) # Clean up all temporary files after each test
  end

  def test_initialize_with_valid_file
    assert_instance_of Converted::MP4, @converter
  end

  def test_initialize_with_invalid_file
    assert_raises(RuntimeError) { Converted::MP4.new("invalid.mp4") }
  end

  def test_convert_to_mp3
    output_file = File.join(TMP_DIR, "test_video.mp3")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_mp3(output_file)
      assert File.exist?(output_file), "Expected MP3 output file to exist"
    end
  end

  def test_convert_to_gif_within_size_limit
    output_file = File.join(TMP_DIR, "test_video.gif")
    temp_file = File.join(TMP_DIR, "temp_test_video.gif")
  
    FileUtils.touch(temp_file) # Simulate the temporary GIF creation
    File.stub(:size, 5 * 1024 * 1024) do # Simulate a 5 MB file
      @converter.stub(:system, true) do
        @converter.convert_to_gif(output_file)
        assert File.exist?(output_file), "Expected GIF output file to exist"
      end
    end
  end  

  def test_convert_to_gif_exceeds_size_limit
    output_file = File.join(TMP_DIR, "test_video.gif")
    temp_file = File.join(TMP_DIR, "temp_test_video.gif")
  
    FileUtils.touch(temp_file) # Simulate the temporary GIF creation
    File.stub(:size, 11 * 1024 * 1024) do # Simulate a 11 MB file
      @converter.stub(:system, true) do
        @converter.convert_to_gif("test_video.gif")
        refute File.exist?(File.join(TMP_DIR, "test_video.gif")), "Expected oversized GIF file to not exist"
        refute File.exist?(temp_file), "Expected temporary oversized GIF file to be deleted"
      end
    end
  end

  def test_convert_to_webm
    output_file = File.join(TMP_DIR, "test_video.webm")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_webm(output_file)
      assert File.exist?(output_file), "Expected WEBM output file to exist"
    end
  end

  def test_convert_to_avi
    output_file = File.join(TMP_DIR, "test_video.avi")
    @converter.stub(:system, true) do
      FileUtils.touch(output_file) # Simulate successful conversion
      @converter.convert_to_avi(output_file)
      assert File.exist?(output_file), "Expected AVI output file to exist"
    end
  end

  def test_ffmpeg_installed
    @converter.stub(:system, true) do
      assert @converter.send(:ffmpeg_installed?), "Expected FFmpeg to be installed"
    end

    @converter.stub(:system, false) do
      refute @converter.send(:ffmpeg_installed?), "Expected FFmpeg to not be installed"
    end
  end
end
