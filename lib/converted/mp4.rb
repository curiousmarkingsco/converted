# lib/converted/mp4.rb
require 'fileutils'

module Converted
  class MP4
    MAX_GIF_SIZE_MB = 10

    TMP_DIR = File.join(Dir.pwd, 'tmp') # Define the tmp directory path

    def initialize(input_file)
      @input_file = input_file
      unless File.exist?(@input_file)
        raise "Error: Input file #{@input_file} does not exist."
      end
    end

    def convert_to_mp3(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'mp3'))
      run_ffmpeg_command("-q:a 0 -map a", output_file, "MP3")
    end

    def convert_to_gif(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'gif'))

      temp_gif = tmp_file("temp_#{File.basename(output_file)}")
      run_ffmpeg_command("-vf 'fps=10,scale=320:-1:flags=lanczos' -t 10", temp_gif, "GIF")
      
      gif_size_mb = File.size(temp_gif).to_f / (1024 * 1024)
      if gif_size_mb > MAX_GIF_SIZE_MB
        puts "GIF size (#{gif_size_mb.round(2)} MB) exceeds the maximum allowed size of #{MAX_GIF_SIZE_MB} MB."
        File.delete(temp_gif) if File.exist?(temp_gif)
      else
        FileUtils.mv(temp_gif, output_file)
        puts "GIF conversion successful: #{output_file}"
      end
    end

    def convert_to_webm(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'webm'))
      run_ffmpeg_command("-c:v libvpx-vp9 -b:v 1M -c:a libopus", output_file, "WEBM")
    end

    def convert_to_avi(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'avi'))
      run_ffmpeg_command("-c:v mpeg4 -vtag xvid -qscale:v 3", output_file, "AVI")
    end

    private

    # Run the ffmpeg command for a given format
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

    # Check if ffmpeg is installed
    def ffmpeg_installed?
      system('ffmpeg -version > /dev/null 2>&1')
    end

    # Change the file extension
    def change_extension(file, new_extension)
      File.basename(file, File.extname(file)) + ".#{new_extension}"
    end

    # Prepend the TMP_DIR path to a filename
    def tmp_file(filename)
      File.join(TMP_DIR, filename)
    end
  end
end
