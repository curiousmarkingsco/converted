# lib/converted/png.rb
require 'fileutils'

module Converted
  class PNG
    TMP_DIR = File.join(Dir.pwd, 'tmp') # Define the tmp directory path

    def initialize(input_file)
      @input_file = input_file
      unless File.exist?(@input_file)
        raise "Error: Input file #{@input_file} does not exist."
      end
    end

    def convert_to_jpg(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'jpg'))
      run_ffmpeg_command("-vf 'format=yuvj422p,scale=trunc(iw/2)*2:trunc(ih/2)*2'", output_file, "JPG", white_background: true)
    end

    def convert_to_gif(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'gif'))
      palette_file = tmp_file('palette.png')
    
      unless ffmpeg_installed?
        raise "Error: ffmpeg is not installed or not in the system PATH."
      end
    
      FileUtils.mkdir_p(TMP_DIR) # Ensure tmp directory exists
    
      # Generate a palette for better GIF quality
      palettegen_command = "ffmpeg -i \"#{@input_file}\" -vf \"palettegen\" \"#{palette_file}\" -y"
      puts "Generating palette for GIF conversion..."
      system(palettegen_command)
    
      if File.exist?(palette_file)
        # Use the palette for the actual GIF conversion
        gif_command = "ffmpeg -i \"#{@input_file}\" -i \"#{palette_file}\" -filter_complex \"paletteuse\" \"#{output_file}\" -y"
        puts "Converting to GIF: #{output_file}..."
        if system(gif_command)
          puts "GIF conversion complete: #{output_file}"
        else
          puts "Error: GIF conversion failed."
        end
        File.delete(palette_file) if File.exist?(palette_file) # Clean up temporary palette file
      else
        puts "Error: Failed to generate palette for GIF conversion."
      end
    end    

    def convert_to_webp(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'webp'))
      run_ffmpeg_command("-c:v libwebp -lossless 1", output_file, "WEBP", white_background: false)
    end

    def convert_to_avif(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'avif'))
      run_ffmpeg_command("-c:v libaom-av1 -crf 30", output_file, "AVIF", white_background: false)
    end

    def convert_to_bmp(output_file = nil, with_transparency: false)
      output_file ||= tmp_file(change_extension(@input_file, 'bmp'))
      options = with_transparency ? "" : "-vf 'format=bgr24'"
      run_ffmpeg_command(options, output_file, "BMP", white_background: !with_transparency)
    end

    def convert_to_ico(output_file = nil)
      output_file ||= tmp_file(change_extension(@input_file, 'ico'))
    
      unless ffmpeg_installed?
        raise "Error: ffmpeg is not installed or not in the system PATH."
      end
    
      FileUtils.mkdir_p(TMP_DIR) # Ensure tmp directory exists
    
      # Resize to a standard ICO size (e.g., 256x256 for high-quality icons)
      resize_command = "ffmpeg -i \"#{@input_file}\" -vf \"scale=256:256:force_original_aspect_ratio=decrease,pad=256:256:(ow-iw)/2:(oh-ih)/2:white\" \"#{output_file}\" -y"
      puts "Converting to ICO with resizing: #{output_file}..."
      if system(resize_command)
        puts "ICO conversion complete: #{output_file}"
      else
        puts "Error: ICO conversion failed."
      end
    end    

    private

    def run_ffmpeg_command(options, output_file, format, white_background: false)
      unless ffmpeg_installed?
        raise "Error: ffmpeg is not installed or not in the system PATH."
      end

      FileUtils.mkdir_p(TMP_DIR) # Ensure tmp directory exists
      command = if white_background
                  # Add `-vf "format=yuvj422p,pad=color=white"` for white background
                  "ffmpeg -i \"#{@input_file}\" -vf \"pad=iw:ih:0:0:color=white\" #{options} \"#{output_file}\" -y"
                else
                  "ffmpeg -i \"#{@input_file}\" #{options} \"#{output_file}\" -y"
                end

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
