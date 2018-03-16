# The Image class holds information about a 2D image. Each pixel in the image
# consists of a color, represented by a color. By default, the image consists
# of blank pixels, represented by the character 'O'.
class Image

  # Accessors for the number of rows, columns, and 2D-array representation of image
  attr_reader :rows, :cols, :imageGrid

  # Constants
  MIN_ROW_SIZE = MIN_COL_SIZE = 1
  MAX_ROW_SIZE = MAX_COL_SIZE = 250
  DEFAULT_EMPTY_COLOR = 'O'

  # Error messages
  OUT_OF_BOUNDS_ERR_MSG = "Row or col is out of image bounds"
  OUT_OF_MAX_BOUNDS_ERR_MSG = "Row or col size is outside allowed range [1..250]"
  INVALID_COLOR_ERR_MSG = "Color is not a capital letter"


  # Initializes the Image class. Generates an image of rows by cols pixels, 
  # where each pixel is an empty color. The empty color is represented
  # by the character 'O'. Internally, the image is stored as a 2D-array of chars.
  #
  # * *Args*    :
  #   - +rows+ -> number of rows in generated image
  #   - +cols+ -> number of columns in generated image
  # * *Returns* :
  #   -
  # * *Raises* :
  #   - +ArgumentError+ -> if image dimensions are outside of allowed image 
  #                         dimensions (1 to 250 inclusive)
  #
  def initialize(rows, cols)
    # Verify rows and cols are within allowed range [1..250]
    raise ArgumentError, OUT_OF_MAX_BOUNDS_ERR_MSG if outside_max_image_bounds?(rows, cols)
    
    # Set rows and cols
    @rows = rows
    @cols = cols

    # Create rows x cols grid filled with 'O's
    @imageGrid = Array.new(rows) { Array.new(cols, DEFAULT_EMPTY_COLOR) }
  end

  # Sets a specific pixel (row,col) to have a specific color
  #
  # * *Args*    :
  #   - +row+ -> row of the pixel that will be changed
  #   - +col+ -> column of the pixel that will be changed
  #   - +color+ -> character representation of the new color for the pixel
  # * *Raises* :
  #   - +IndexError+ -> if either row or col is out of the bounds of the image
  #   - +ArgumentError+ -> if the provided `color` variable is not an uppercase character
  #
  def set_pixel(row, col, color)
    raise IndexError, OUT_OF_BOUNDS_ERR_MSG if outside_curr_image_bounds?(row, col)
    raise ArgumentError, INVALID_COLOR_ERR_MSG if !is_valid_color?(color)
    @imageGrid[row-1][col-1] = color
  end

  # Get the character representing the color at (row, col)
  #
  # * *Args*    :
  #   - +row+ -> row of the pixel to retrieve
  #   - +col+ -> column of the pixel to retrieve
  # * *Returns* :
  #   - a character representing the color at (row, col)
  # * *Raises* :
  #   - +IndexError+ -> if either row or col is out of the bounds of the image
  #
  def get_pixel(row, col)
    raise IndexError, OUT_OF_BOUNDS_ERR_MSG if outside_curr_image_bounds?(row, col)
    @imageGrid[row-1][col-1]
  end

  # Print out the image as a 2d grid to standard output
  #
  def show()
    @imageGrid.each { |x|
      puts x.join(" ")
    }
  end

 



  # NOTE: Everything from here below are private methods
  private 

  # Check if row or column is outside allowed range of 1 to 250 (inclusive)
  #
  # * *Args*    :
  #   - +row+ -> row to check
  #   - +col+ -> column to check
  # * *Returns* :
  #   - true if row or column is outside the maximum allowed bounds for an image
  #
  def outside_max_image_bounds?(rows, cols)
    if rows < MIN_ROW_SIZE or cols < MIN_COL_SIZE
      true
    elsif rows > MAX_ROW_SIZE or cols > MAX_COL_SIZE
      true
    else
      false
    end
  end

  # Check if (row, col) is outside of this image's bounds
  #
  # * *Args*    :
  #   - +row+ -> row to check
  #   - +col+ -> column to check
  # * *Returns* :
  #   - true if row or column is outside the maximum bounds for this image
  #
  def outside_curr_image_bounds?(row, col)
    if row <= 0 or row > @rows
      true
    elsif col <= 0 or col > @cols
      true
    else
      false
    end
  end

  # Check if the character representing a color is a capital letter
  #
  # * *Args*    :
  #   - +color+ -> character representation of a color
  # * *Returns* :
  #   - true if the character representing a color is a capital letter
  #
  def is_valid_color?(color)
    color == color.upcase and color.length == 1
  end
end