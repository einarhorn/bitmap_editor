require_relative "image_editor"
# This class iterates through the input file, and executes the commands in the
# order they are presented in the file. Invalid lines are ignored and print out
# error messages to stdout. This class only handles validation of types (e.g. Integer)
# and does not do any validation of values.
class InputParse

  # For testing purposes, make this accessible
  attr_reader :editor

  def run(file=nil)
    return puts "Please provide correct file" if file.nil? || !File.exists?(file)

    @editor = ImageEditor.new()

    # Iterate through each line in file
    File.open(file).each do |line|
      line = line.chomp

      # Split line based on spaces
      split_line = line.split(' ')

      # If line is empty, move to next line
      if split_line.length == 0
        next
      end
      
      begin
        execute_line(split_line)
      rescue ArgumentError => e
        puts e.message
      end

      
    end
  end

  private

  def execute_line(split_input)
    case split_input[0]
    when 'I'
      puts 'Create'
      create_image(split_input)
    when 'C'
      puts 'Clears'
    when 'L'
      puts 'Color'
      color_pixel(split_input)
    when 'V'
      puts 'Vertical'
    when 'H'
      puts 'Horizontal'
    when 'S'
      puts "Show"
    else
      puts 'Unrecognised command'
    end
  end

  # Create a new M x N image with all pixels coloured white ('O').
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings
  # * *Raises* :
  #   - +ArgumentError+ -> if input is not in the format "I N M", where
  #                         N and M are integers
  #
  def create_image(split_input)
    raise ArgumentError if split_input.length != 3
    rows = Integer(split_input[1])
    cols = Integer(split_input[2])
    @editor.create_image(rows, cols)
  end

  # Colours the pixel (X,Y) with colour C.
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings
  # * *Raises* :
  #   - +ArgumentError+ -> if input is not in the format "L X Y C", where
  #                         X and Y are integers, C is an uppercase character
  #
  def color_pixel(split_input)
    raise ArgumentError if split_input.length != 4
    row = Integer(split_input[1])
    col = Integer(split_input[2])
    color = String(split_input[3])
    @editor.color_pixel(row, col, color)
  end


end
  