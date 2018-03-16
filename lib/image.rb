class Image
  attr_reader :rows, :cols, :image

  # Constants
  MIN_ROW_SIZE = MIN_COL_SIZE = 1
  MAX_ROW_SIZE = MAX_COL_SIZE = 250
  DEFAULT_EMPTY_COLOR = 'O'
  

  # Initialize a blank image of rows x cols pixels
  def initialize(rows, cols)
    # Verify rows and cols are within allowed range [1..250]
    if outside_max_image_bounds?(rows, cols)
      raise ArgumentError, "Row or col size is outside allowed range [1..250]"
    end
    
    # Set rows and cols
    @rows = rows
    @cols = cols

    # Create rows x cols grid filled with 'O's
    @image = Array.new(rows) { Array.new(cols, DEFAULT_EMPTY_COLOR) }
  end

  # Color a specific pixel (row,col) with a color
  def color_pixel(row, col, color)
    raise IndexError, "Row or col is out of image bounds" if outside_curr_image_bounds?(row, col)
    raise ArgumentError, "Color is not a capital letter" if !is_capital_letter?(color)
    @image[row-1][col-1] = color
  end

  # Get the character representing the color at (row, col)
  def get_pixel(row, col)
    raise IndexError, "Row or col is out of image bounds" if outside_curr_image_bounds?(row, col)
    @image[row-1][col-1]
  end

  # Print out the image as a 2d grid
  def show()
    @image.each { |x|
      puts x.join(" ")
    }
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
  def is_capital_letter?(color)
    color == color.upcase and color.length == 1
  end
end