# lib/converted/gif.rb
require 'fileutils'

module Converted
  class GIF
    TMP_DIR = File.join(Dir.pwd, 'tmp') # Define the tmp directory path

    def initialize(input_file)
      @input_file = input_file
      unless File.exist?(@input_file)
        raise "Error: Input file #{@input_file} does not exist."
      end
    end

    def convert_to_jpg(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'jpg'))
      run_ffmpeg_command("-vf 'format=yuvj422p,pad=iw:ih:0:0:color=white'", output_file, "JPG")
    end

    def convert_to_png(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'png'))
      run_ffmpeg_command("", output_file, "PNG")
    end

    def convert_to_webp(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'webp'))
      run_ffmpeg_command("-c:v libwebp -lossless 1", output_file, "WEBP")
    end

    def convert_to_avif(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'avif'))
      run_ffmpeg_command("-c:v libaom-av1 -crf 30", output_file, "AVIF")
    end

    def convert_to_bmp(output_file = nil, with_transparency: false)
      output_file ||= tmp_file(change_extension(@input_file, 'bmp'))
      options = with_transparency ? "" : "-vf 'format=bgr24,pad=iw:ih:0:0:color=white'"
      run_ffmpeg_command(options, output_file, "BMP")
    end

    def convert_to_ico(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'ico'))
      run_ffmpeg_command("", output_file, "ICO")
    end

    def convert_to_webm(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'webm'))
      run_ffmpeg_command("-c:v libvpx-vp9 -b:v 1M -an", output_file, "WEBM")
    end

    def convert_to_avi(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'avi'))
      run_ffmpeg_command("-c:v mpeg4 -vtag xvid -qscale:v 3", output_file, "AVI")
    end

    def convert_to_mp4(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'mp4'))
      run_ffmpeg_command("-c:v libx264 -crf 23 -preset fast", output_file, "MP4")
    end

    private

    def run_ffmpeg_command(options, output_file, format)
      unless ffmpeg_installed?
        raise "Error: ffmpeg is not installed or not in the system PATH."
      end

      FileUtils.mkdir_p(TMP_DIR) # Ensure tmp directory exists
      command = "ffmpeg -i \"#{@input_file}\" #{options} \"#{output_file}\" -y"
      puts "Converting to #{format}: #{output_file}..."
      if system(command)
        puts "#{format} conversion complete: #{output_file}"
      else
        puts "Error: #{format} conversion failed."
      end
    end

    def ffmpeg_installed?
      system('ffmpeg -version > /dev/null 2>&1')
    end

    def change_extension(file, new_extension)
      File.basename(file, File.extname(file)) + ".#{new_extension}"
    end

    def tmp_file(filename)
      File.join(TMP_DIR, filename)
    end
  end
end
