require_relative "image_editor"
require_relative "exceptions/unrecognised_command_error"
require_relative "exceptions/invalid_command_error"
# This class iterates through the input file, and executes the commands in the
# order they are presented in the file. Invalid lines are ignored and print out
# error messages to stdout. This class only handles validation of types (e.g. Integer)
# and does not do any validation of values.
class InputParse

  # Error messages
  INCORRECT_NUMBER_OF_ARGS_ERR_MSG = "Incorrect number of arguments"
  INVALID_FILE_ERR_MSG = "Please provide correct file"

  # General command
  COMMAND_IDX = 0

  # Create Image
  CREATE_IMG_COMMAND = 'I'
  CREATE_IMG_PARAM_COUNT = 3
  CREATE_IMG_PARAM_COLS_IDX = 1
  CREATE_IMG_PARAM_ROWS_IDX = 2

  # Clear image
  CLEAR_IMG_COMMAND = 'C'
  CLEAR_IMG_PARAM_COUNT = 1

  # Colour pixel
  COLOUR_PIXEL_COMMAND = 'L'
  COLOUR_PIXEL_PARAM_COUNT = 4
  COLOUR_PIXEL_PARAM_COL_IDX = 1
  COLOUR_PIXEL_PARAM_ROW_IDX = 2
  COLOUR_PIXEL_PARAM_COLOR_IDX = 3

  # Draw vertical segment
  DRAW_VERTICAL_COMMAND = 'V'
  DRAW_VERTICAL_PARAM_COUNT = 5
  DRAW_VERTICAL_COL_IDX = 1
  DRAW_VERTICAL_ROW_START_IDX = 2
  DRAW_VERTICAL_ROW_END_IDX = 3
  DRAW_VERTICAL_COLOR_IDX = 4

  # Draw horizontal segment
  DRAW_HORIZONTAL_COMMAND = 'H'
  DRAW_HORIZONTAL_PARAM_COUNT = 5
  DRAW_HORIZONTAL_ROW_IDX = 3
  DRAW_HORIZONTAL_COL_START_IDX = 1
  DRAW_HORIZONTAL_COL_END_IDX = 2
  DRAW_HORIZONTAL_COLOR_IDX = 4

  # Show
  SHOW_COMMAND = 'S'
  SHOW_COMMAND_PARAM_COUNT = 1


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
  #                      split_input[COMMAND_IDX] is the letter representing the operation
  #                      The rest of the items in array are args for the operation
  # * *Raises* :
  #   - +InvalidCommandError+ -> if input is not in the expected format
  #   - +UnrecognisedCommandError+ -> if operation could not be determined
  #
  def execute_line(split_input)
    case split_input[COMMAND_IDX]
    when CREATE_IMG_COMMAND
      create_image(split_input)
    when CLEAR_IMG_COMMAND
      clear_image(split_input)
    when COLOUR_PIXEL_COMMAND
      color_pixel(split_input)
    when DRAW_VERTICAL_COMMAND
      draw_vertical_segment(split_input)
    when DRAW_HORIZONTAL_COMMAND
      draw_horizontal_segment(split_input)
    when SHOW_COMMAND
      show(split_input)
    else
      raise UnrecognisedCommandError
    end
  end

  # Create a new M x N image with all pixels coloured white ('O').
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings.
  #                      split_input[CREATE_IMG_PARAM_COLS_IDX] is number of columns
  #                      split_input[CREATE_IMG_PARAM_ROWS_IDX] is number of rows
  # * *Raises* :
  #   - +InvalidCommandError+ -> if input is not in the format "I N M", where
  #                               N and M are integers
  #
  def create_image(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != CREATE_IMG_PARAM_COUNT
      cols = Integer(split_input[CREATE_IMG_PARAM_COLS_IDX])
      rows = Integer(split_input[CREATE_IMG_PARAM_ROWS_IDX])
      @editor.create_image(rows, cols)
    rescue ArgumentError => e
      raise InvalidCommandError, e.message
    end
  end

  # Clears the image, setting all pixels to white (O).
  #
  # * *Args*    :
  #   - +split_input+ -> array of strings
  # * *Raises* :
  #   - +InvalidCommandError+ -> if input is not in the format "C"
  #
  def clear_image(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != CLEAR_IMG_PARAM_COUNT
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
  #   - +InvalidCommandError+ -> if input is not in the format "L X Y C", where
  #                         X and Y are integers, C is an uppercase character
  #
  def color_pixel(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != COLOUR_PIXEL_PARAM_COUNT
      col = Integer(split_input[COLOUR_PIXEL_PARAM_COL_IDX])
      row = Integer(split_input[COLOUR_PIXEL_PARAM_ROW_IDX])
      color = split_input[COLOUR_PIXEL_PARAM_COLOR_IDX]
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
  #   - +InvalidCommandError+ -> if input is not in the format "V X Y1 Y2 C", where
  #                         X, Y1, Y2 are integers, C is an uppercase character
  #
  def draw_vertical_segment(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != DRAW_VERTICAL_PARAM_COUNT
      col = Integer(split_input[DRAW_VERTICAL_COL_IDX])
      rowStart = Integer(split_input[DRAW_VERTICAL_ROW_START_IDX])
      rowEnd = Integer(split_input[DRAW_VERTICAL_ROW_END_IDX])
      color = split_input[DRAW_VERTICAL_COLOR_IDX]
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
  #   - +InvalidCommandError+ -> if input is not in the format "H X1 X2 Y C ", where
  #                         X, Y1, Y2 are integers, C is an uppercase character
  #
  def draw_horizontal_segment(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != DRAW_HORIZONTAL_PARAM_COUNT
      colStart = Integer(split_input[DRAW_HORIZONTAL_COL_START_IDX])
      colEnd = Integer(split_input[DRAW_HORIZONTAL_COL_END_IDX])
      row = Integer(split_input[DRAW_HORIZONTAL_ROW_IDX])
      color = split_input[DRAW_HORIZONTAL_COLOR_IDX]
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
  #   - +InvalidCommandError+ -> if input is not in the format "S"
  #
  def show(split_input)
    begin
      raise ArgumentError, INCORRECT_NUMBER_OF_ARGS_ERR_MSG if split_input.length != SHOW_COMMAND_PARAM_COUNT
      @editor.show()
    rescue ArgumentError, MissingImageError => e
      raise InvalidCommandError, e.message
    end
  end


end
  