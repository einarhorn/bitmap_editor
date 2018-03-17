require_relative "image_editor"
require_relative "exceptions/unrecognised_command_error"
require_relative "exceptions/invalid_command_error"
# This class iterates through the input file, and executes the commands in the
# order they are presented in the file. Invalid lines are ignored and print out
# error messages to stdout. This class only handles validation of types (e.g. Integer)
# and does not do any validation of values.
class InputParse

  # Constants
  INCORRECT_NUMBER_OF_ARGS_ERR_MSG = "Incorrect number of arguments"
  INVALID_FILE_ERR_MSG = "Please provide correct file"

  # For testing purposes, we make the image editor accessible
  attr_reader :editor

  # Executes a text file, which contains a list of commands
  #
  # * *Args*    :
  #   - +file+ -> location of a text file to execute
  #
  def run(file=nil)
    return puts INVALID_FILE_ERR_MSG if file.nil? || !File.exists?(file)

    # Create an image editor instance, used by the commands that are executed
    @editor = ImageEditor.new()

    # Iterate through each line in file
    File.open(file).each do |line|
      line = line.chomp

      # Split line based on spaces
      split_line = line.split(' ')

      # If line is empty, move to next line
      if split_line.empty?
        next
      end
      
      # Execute line, display error message if line fails
      begin
        execute_line(split_line)
      rescue UnrecognisedCommandError, InvalidCommandError => e
        puts line << ": " << e.message
      end
    end
  end

  private

  # Execute a command
  #
  # * *Args*    :
  #   - +split_input+ -> command to execute, as an array of strings.
  #                      split_input[0] is the letter representing the operation
  #                      The rest of the items in array are args for the operation
  # * *Raises* :
  #   - +InvalidCommandError+ -> if input is not in the expected format
  #   - +UnrecognisedCommandError+ -> if operation could not be determined
  #
  def execute_line(split_input)
    case split_input[0]
    when 'I'
      create_image(split_input)
    when 'C'
      clear_image(split_input)
    when 'L'
      color_pixel(split_input)
    when 'V'
      draw_vertical_segment(split_input)
    when 'H'
      draw_horizontal_segment(split_input)
    when 'S'
      show(split_input)
    else
      raise UnrecognisedCommandError
    end
  end

  # Create a new M x N image with all pixels coloured white ('O').
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings.
  #                      split_input[1] is number of columns
  #                      split_input[2] is number of rows
  # * *Raises* :
  #   - +InvalidCommandError+ -> if input is not in the format "I N M", where
  #                               N and M are integers
  #
  def create_image(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != 3
      cols = Integer(split_input[1])
      rows = Integer(split_input[2])
      @editor.create_image(rows, cols)
    rescue ArgumentError => e
      raise InvalidCommandError, e.message
    end
  end

  # Clears the table, setting all pixels to white (O).
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings
  # * *Raises* :
  #   - +ArgumentError+ -> if input is not in the format "C"
  #
  def clear_image(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != 1
      @editor.clear_image()
    rescue ArgumentError, MissingImageError => e
      raise InvalidCommandError, e.message
    end
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
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != 4
      col = Integer(split_input[1])
      row = Integer(split_input[2])
      color = split_input[3]
      @editor.color_pixel(row, col, color)
    rescue ArgumentError, MissingImageError, IndexError => e
      raise InvalidCommandError, e.message
    end
  end

  # Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings
  # * *Raises* :
  #   - +ArgumentError+ -> if input is not in the format "V X Y1 Y2 C", where
  #                         X, Y1, Y2 are integers, C is an uppercase character
  #
  def draw_vertical_segment(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != 5
      col = Integer(split_input[1])
      rowStart = Integer(split_input[2])
      rowEnd = Integer(split_input[3])
      color = split_input[4]
      @editor.draw_vertical_segment(col, rowStart, rowEnd, color)
    rescue ArgumentError, MissingImageError, IndexError => e
      raise InvalidCommandError, e.message
    end
  end

  # Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings
  # * *Raises* :
  #   - +ArgumentError+ -> if input is not in the format "H X1 X2 Y C ", where
  #                         X, Y1, Y2 are integers, C is an uppercase character
  #
  def draw_horizontal_segment(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != 5
      colStart = Integer(split_input[1])
      colEnd = Integer(split_input[2])
      row = Integer(split_input[3])
      color = split_input[4]
      @editor.draw_horizontal_segment(row, colStart, colEnd, color)
    rescue ArgumentError, MissingImageError, IndexError => e
      raise InvalidCommandError, e.message
    end
  end

  # Show the contents of the current image
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings
  # * *Raises* :
  #   - +ArgumentError+ -> if input is not in the format "S"
  #
  def show(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != 1
      @editor.show()
    rescue ArgumentError, MissingImageError => e
      raise InvalidCommandError, e.message
    end
  end


end
  