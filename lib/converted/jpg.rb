# lib/converted/jpg.rb
require 'fileutils'

module Converted
  class JPG
    TMP_DIR = File.join(Dir.pwd, 'tmp') # Define the tmp directory path

    def initialize(input_file)
      @input_file = input_file
      unless File.exist?(@input_file)
        raise "Error: Input file #{@input_file} does not exist."
      end
    end

    def convert_to_gif(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'gif'))
      run_ffmpeg_command("-vf 'palettegen,paletteuse'", output_file, "GIF")
    end

    def convert_to_png(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'png'))
      run_ffmpeg_command("", output_file, "PNG")
    end

    # For WEBP and AVIF, we could tweak compression settings (-crf, etc.) 
    # if higher quality or smaller file size is desired.
    def convert_to_webp(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'webp'))
      run_ffmpeg_command("-c:v libwebp -lossless 0", output_file, "WEBP")
    end

    def convert_to_avif(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'avif'))
      run_ffmpeg_command("-c:v libaom-av1 -crf 30", output_file, "AVIF")
    end

    def convert_to_bmp(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'bmp'))
      run_ffmpeg_command("-vf 'format=bgr24'", output_file, "BMP")
    end

    def convert_to_ico(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'ico'))
      run_ffmpeg_command("-vf \"scale=256:256:force_original_aspect_ratio=decrease,pad=256:256:(ow-iw)/2:(oh-ih)/2:white\"", output_file, "ICO")
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
