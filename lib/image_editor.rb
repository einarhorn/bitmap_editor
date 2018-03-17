require_relative "image"
require_relative "exceptions/missing_image_error"

# ImageEditor class
# This handles editing an Image object in various ways. Some of these methods are 
# simply wrappers around identical methods on the Image class. As there is no
# initialize() method for this class, the class can exist without an image attached to it.
# Methods for editing an image cannot be successfully called without create_image(row, col)
# being called first.
class ImageEditor

  # Error messages
  INVALID_ROW_START_END_ORDER_ERR_MSG = "Expected start row to be less than end row"
  INVALID_COL_START_END_ORDER_ERR_MSG = "Expected start column to be less than end column"

  # Verifies if the current instance of the ImageEditor has an image associated with it
  #
  # * *Returns* :
  #   - true if there is an image associated with the editor instance
  def has_image?()
    instance_variable_defined?("@image")
  end

  # Generate a new image
  #
  # * *Args*    :
  #   - +rows+ -> number of rows in generated image
  #   - +cols+ -> number of columns in generated image
  # * *Raises* :
  #   - +ArgumentError+ -> if image dimensions are outside of allowed image 
  #                         dimensions (1 to 250 inclusive)
  #
  def create_image(rows, cols)
    @image = Image.new(rows, cols)
  end

  # Get the number of rows in the image
  #
  # * *Returns* :
  #   - number of rows in the image
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #
  def rows()
    validate_editor_has_image()
    @image.rows
  end

  # Get the number of columns in the image
  #
  # * *Returns* :
  #   - number of columns in the image
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #
  def cols()
    validate_editor_has_image()
    @image.cols
  end

  # Get the image as a 2D array
  #
  # * *Returns* :
  #   - the image as a 2D array
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #
  def imageGrid()
    validate_editor_has_image()
    @image.imageGrid
  end
  
  # Clear the current image, resetting all elements to 'O'
  #
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #
  def clear_image()
    validate_editor_has_image()
    create_image(rows, cols)
  end

  # Color a specific pixel (row,col) with a color
  #
  # * *Args*    :
  #   - +row+ -> row of the pixel that will be changed
  #   - +col+ -> column of the pixel that will be changed
  #   - +color+ -> character representation of the new color for the pixel
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #   - +IndexError+ -> if either row or col is out of the bounds of the image
  #   - +ArgumentError+ -> if the provided `color` variable is not an uppercase character
  #
  def color_pixel(row, col, color)
    validate_editor_has_image()
    @image.set_pixel(row, col, color)
  end

  # Get the character representing the color at (row, col)
  #
  # * *Args*    :
  #   - +row+ -> row of the pixel to retrieve
  #   - +col+ -> column of the pixel to retrieve
  # * *Returns* :
  #   - a character representing the color at (row, col)
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #   - +IndexError+ -> if either row or col is out of the bounds of the image
  #
  def get_pixel(row, col)
    validate_editor_has_image()
    @image.get_pixel(row, col)
  end

  # Draw a vertical segment of color in colomn col between rowStart and rowEnd (inclusive)
  #
  # * *Args*    :
  #   - +col+ -> column in which to draw the vertical segment
  #   - +rowStart+ -> starting row of the vertical segment
  #   - +rowEnd+ -> ending row of the vertical segment
  #   - +color+ -> color of the vertical segment
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #   - +IndexError+ -> if any portion of the vertical segment would be out of the bounds of the image
  #   - +ArgumentError+ -> if the provided `color` variable is not an uppercase character
  #   - +ArgumentError+ -> if the starting row of the segnment is greater than the ending row
  #
  def draw_vertical_segment(col, rowStart, rowEnd, color)
    validate_editor_has_image()
    raise ArgumentError, INVALID_ROW_START_END_ORDER_ERR_MSG if rowStart > rowEnd
    
    # Convert start and end values to a continuous array
    # e.g. rowStart = 1, rowEnd = 3 => rows = [1,2,3]
    rows = (rowStart..rowEnd).to_a

    # Update color for each pixel that needs to be changed
    rows.each do |row|
      color_pixel(row, col, color)
    end
  end

  # Draw a horizontal segment of color in given row between colStart and colEnd (inclusive)
  #
  # * *Args*    :
  #   - +row+ -> row in which to draw the horizontal segment
  #   - +colStart+ -> starting column of the horizontal segment
  #   - +colEnd+ -> ending column of the horizontal segment
  #   - +color+ -> color of the horizontal segment
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #   - +IndexError+ -> if any portion of the horizontal segment would be out of the bounds of the image
  #   - +ArgumentError+ -> if the provided `color` variable is not an uppercase character
  #   - +ArgumentError+ -> if the starting column of the segnment is greater than the ending column
  #
  def draw_horizontal_segment(row, colStart, colEnd, color)
    validate_editor_has_image()
    raise ArgumentError, INVALID_COL_START_END_ORDER_ERR_MSG if colStart > colEnd

    # Convert start and end values to a continuous array
    # e.g. colStart = 1, colEnd = 3 => cols = [1,2,3]
    cols = (colStart..colEnd).to_a

    # Update color for each pixel that needs to be changed
      cols.each do |col|
        color_pixel(row, col, color)
      end
  end

  # Print out the image as a 2d grid to standard output
  #
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #
  def show()
    validate_editor_has_image()
    @image.show()
  end

  # Validate that editor instance has an image associated with it
  #
  # * *Raises* :
  #   - +MissingImageError+ -> if no image is associated with this image editor
  #
  def validate_editor_has_image
    raise MissingImageError if !has_image?()
  end


end