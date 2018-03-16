class Image
  attr_reader :rows, :cols

  # Constants
  MIN_ROW_SIZE = MIN_COL_SIZE = 1
  MAX_ROW_SIZE = MAX_COL_SIZE = 250
  DEFAULT_EMPTY_COLOR = 'O'
  

  # Initialize a blank image of rows x cols pixels
  def initialize(rows, cols)
    # Verify rows and cols are within allowed range [1-250]
    if outside_max_image_size?(rows, cols)
      raise ArgumentError, "Row or col size is outside allowed range [1..250]"
    end
    
    # Set rows and cols
    @rows = rows
    @cols = cols

    # Create rows x cols grid filled with 'O's
    @grid = Array.new(rows) { Array.new(cols, DEFAULT_EMPTY_COLOR) }
  end

  def outside_max_image_size?(rows, cols)
    if rows < MIN_ROW_SIZE or cols < MIN_COL_SIZE
      true
    elsif rows > MAX_ROW_SIZE or cols > MAX_COL_SIZE
      true
    else
      false
    end
  end

end