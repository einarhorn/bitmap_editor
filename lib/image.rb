class Image
  attr_reader :rows, :cols, :image

  # Constants
  MIN_ROW_SIZE = MIN_COL_SIZE = 1
  MAX_ROW_SIZE = MAX_COL_SIZE = 250
  DEFAULT_EMPTY_COLOR = 'O'

  # Error messages
  OUT_OF_BOUNDS_ERR_MSG = "Row or col is out of image bounds"
  OUT_OF_MAX_BOUNDS_ERR_MSG = "Row or col size is outside allowed range [1..250]"
  INVALID_COLOR_ERR_MSG = "Color is not a capital letter"
  INVALID_ROW_START_END_ORDER_ERR_MSG = "Expected start row to be less than end row"
  INVALID_COL_START_END_ORDER_ERR_MSG = "Expected start column to be less than end column"

  # Initialize a blank image of rows x cols pixels
  def initialize(rows, cols)
    # Verify rows and cols are within allowed range [1..250]
    raise ArgumentError, OUT_OF_MAX_BOUNDS_ERR_MSG if outside_max_image_bounds?(rows, cols)
    
    # Set rows and cols
    @rows = rows
    @cols = cols

    # Create rows x cols grid filled with 'O's
    @image = Array.new(rows) { Array.new(cols, DEFAULT_EMPTY_COLOR) }
  end

  # Color a specific pixel (row,col) with a color
  def color_pixel(row, col, color)
    raise IndexError, OUT_OF_BOUNDS_ERR_MSG if outside_curr_image_bounds?(row, col)
    raise ArgumentError, INVALID_COLOR_ERR_MSG if !is_valid_color?(color)
    @image[row-1][col-1] = color
  end

  # Get the character representing the color at (row, col)
  def get_pixel(row, col)
    raise IndexError, OUT_OF_BOUNDS_ERR_MSG if outside_curr_image_bounds?(row, col)
    @image[row-1][col-1]
  end

  # Print out the image as a 2d grid
  def show()
    @image.each { |x|
      puts x.join(" ")
    }
  end

  # Draw a vertical segment of color in col between rowStart and rowEnd (inclusive)
  # NOTE: Expects rowStart <= rowEnd
  def draw_vertical_segment(col, rowStart, rowEnd, color)
    is_out_of_bounds = outside_curr_image_bounds?(rowStart, col) || outside_curr_image_bounds?(rowEnd, col)
    raise IndexError, OUT_OF_BOUNDS_ERR_MSG if is_out_of_bounds
    raise ArgumentError, INVALID_COLOR_ERR_MSG if !is_valid_color?(color)
    raise ArgumentError, INVALID_ROW_START_END_ORDER_ERR_MSG if rowStart > rowEnd
    
    # Convert start and end values to a continuous array
    # e.g. rowStart = 1, rowEnd = 3 => rows = [1,2,3]
    rows = (rowStart..rowEnd).to_a

    # Update color for each pixel that needs to be changed
    rows.each do |row|
      @image[row-1][col-1] = color
    end
  end

  # Draw a horizontal segment of color in row between colStart and colEnd (inclusive)
  # NOTE: Expects colStart <= colEnd
  def draw_horizontal_segment(row, colStart, colEnd, color)
    is_out_of_bounds = outside_curr_image_bounds?(row, colStart) || outside_curr_image_bounds?(row, colEnd)
    raise IndexError, OUT_OF_BOUNDS_ERR_MSG if is_out_of_bounds
    raise ArgumentError, INVALID_COLOR_ERR_MSG if !is_valid_color?(color)
    raise ArgumentError, INVALID_COL_START_END_ORDER_ERR_MSG if colStart > colEnd

    # Convert start and end values to a continuous array
    # e.g. colStart = 1, colEnd = 3 => cols = [1,2,3]
    cols = (colStart..colEnd).to_a

    # Update color for each pixel that needs to be changed
    cols.each do |col|
      @image[row-1][col-1] = color
    end
  end

  private # Everything from here below are private methods

  # Check if (row, col) is outside allowed range [1..250]
  def outside_max_image_bounds?(rows, cols)
    if rows < MIN_ROW_SIZE or cols < MIN_COL_SIZE
      true
    elsif rows > MAX_ROW_SIZE or cols > MAX_COL_SIZE
      true
    else
      false
    end
  end

  # Check if (row, col) is outside this image's bounds
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
  def is_valid_color?(color)
    color == color.upcase and color.length == 1
  end
end