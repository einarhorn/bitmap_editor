
require_relative "../lib/image_editor"
require "test/unit"
 
# As several of the methods in the ImageEditor class are simply wrappers
# around identical methods in the Image class, and those methods are
# heavily tested in the TestImage class, those methods will only
# be tested for the success case and 'image not created' case in this class.
# Methods which implement new features in the ImageEditor class are tested
# in full here.
class TestImageEditor < Test::Unit::TestCase
 
  # Tests: Initialization of ImageEditor
  def test_initialization_successful
    editor = ImageEditor.new()
    assert_equal(false, editor.has_image?)
  end

  def test_create_image_successful
    editor = ImageEditor.new()
    editor.create_image(2,5)
    expected_img_grid = Array[
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O']
    ]
    assert_equal(2, editor.rows)
    assert_equal(5, editor.cols)
    assert_equal(expected_img_grid, editor.imageGrid)
  end

  # Tests: get_pixel

  def test_get_pixel
    editor = ImageEditor.new()
    editor.create_image(2, 5)
    assert_equal('O', editor.get_pixel(1, 1))
    assert_equal('O', editor.get_pixel(1, 2))
    assert_equal('O', editor.get_pixel(1, 3))
    assert_equal('O', editor.get_pixel(1, 4))
    assert_equal('O', editor.get_pixel(1, 5))

    # get_pixel(row, col) should be equal to editor.image[row-1][col-1]
    assert_equal(editor.imageGrid[1][0], editor.get_pixel(2, 1))
    assert_equal(editor.imageGrid[1][1], editor.get_pixel(2, 2))
    assert_equal(editor.imageGrid[1][2], editor.get_pixel(2, 3))
    assert_equal(editor.imageGrid[1][3], editor.get_pixel(2, 4))
    assert_equal(editor.imageGrid[1][4], editor.get_pixel(2, 5))
  end

  # Tests: color_pixel

  def test_color_pixel_successful
    editor = ImageEditor.new()
    editor.create_image(2, 5)
    row = col = 1
    assert_equal('O', editor.get_pixel(row, col))

    # Color pixel
    editor.color_pixel(row, col,'A')
    assert_equal('A', editor.get_pixel(row, col))
  end

  # Tests: draw_vertical_segment

  def test_draw_vertical_segment_successful
    # Draw segment
    editor = ImageEditor.new()
    editor.create_image(5, 5)
    col = 3
    startRow = 2
    endRow = 5
    editor.draw_vertical_segment(col, startRow, endRow, 'A')

    # Verify
    expected_img_grid = Array[
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'A', 'O', 'O'],
      ['O', 'O', 'A', 'O', 'O'],
      ['O', 'O', 'A', 'O', 'O'],
      ['O', 'O', 'A', 'O', 'O']
    ]
    assert_equal(expected_img_grid, editor.imageGrid)
  end

  def test_draw_vertical_segment_throws_on_out_of_bounds
    editor = ImageEditor.new()
    editor.create_image(5, 5)

    valid_col = 2
    valid_row_start = 2
    valid_row_end = 3
    valid_color = 'A'

    invalid_col = 8
    invalid_row_start = -1
    invalid_row_end = 8

    # Invalid column value
    assert_raise(IndexError) do
      editor.draw_vertical_segment(
        invalid_col,
        valid_row_start, 
        valid_row_end, 
        valid_color
      )
    end

    # Invalid row start value
    assert_raise(IndexError) do
      editor.draw_vertical_segment(
        valid_col,
        invalid_row_start, 
        valid_row_end, 
        valid_color
      )
    end

    # Invalid row end value
    assert_raise(IndexError) do
      editor.draw_vertical_segment(
        valid_col,
        valid_row_start, 
        invalid_row_end, 
        valid_color
      )
    end
  end

  def test_draw_vertical_segment_throws_on_invalid_color_string
    editor = ImageEditor.new()
    editor.create_image(5, 5)

    # Lowercase character
    assert_raise(ArgumentError) do
      editor.draw_vertical_segment(1, 1, 2, 'z')
    end

    # Multiple uppercase characters
    assert_raise(ArgumentError) do
      editor.draw_vertical_segment(1, 1, 2, 'ABC')
    end

    # Combination of above
    assert_raise(ArgumentError) do
      editor.draw_vertical_segment(1, 1, 2, 'aBc')
    end
  end

  def test_draw_vertical_segment_throws_on_invalid_row_order
    editor = ImageEditor.new()
    editor.create_image(5, 5)

    # row_start > row_end should throw
    row_start = 2
    row_end = 1
    assert_raise(ArgumentError) do
      editor.draw_vertical_segment(1, row_start, row_end, 'z')
    end
  end

  # Tests: draw_horizontal_segment
  
  def test_draw_horizontal_segment_successful
    # Draw segment
    editor = ImageEditor.new()
    editor.create_image(5, 5)
    row = 3
    startCol = 2
    endCol = 5
    editor.draw_horizontal_segment(row, startCol, endCol, 'A')

    # Verify
    expected_img_grid = Array[
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'A', 'A', 'A', 'A'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O']
    ]
    assert_equal(expected_img_grid, editor.imageGrid)
  end

  def test_draw_horizontal_segment_throws_on_out_of_bounds
    editor = ImageEditor.new()
    editor.create_image(5, 5)

    valid_row = 2
    valid_col_start = 2
    valid_col_end = 3
    valid_color = 'A'

    invalid_row = 8
    invalid_col_start = -1
    invalid_col_end = 8

    # Invalid column value
    assert_raise(IndexError) do
      editor.draw_horizontal_segment(
        invalid_row,
        valid_col_start, 
        valid_col_end, 
        valid_color
      )
    end

    # Invalid row start value
    assert_raise(IndexError) do
      editor.draw_horizontal_segment(
        valid_row,
        invalid_col_start, 
        valid_col_end, 
        valid_color
      )
    end

    # Invalid row end value
    assert_raise(IndexError) do
      editor.draw_horizontal_segment(
        valid_row,
        valid_col_start, 
        invalid_col_end, 
        valid_color
      )
    end
  end

  def test_draw_horizontal_segment_throws_on_invalid_color_string
    editor = ImageEditor.new()
    editor.create_image(5, 5)

    # Lowercase character
    assert_raise(ArgumentError) do
      editor.draw_horizontal_segment(1, 1, 2, 'z')
    end

    # Multiple uppercase characters
    assert_raise(ArgumentError) do
      editor.draw_horizontal_segment(1, 1, 2, 'ABC')
    end

    # Combination of above
    assert_raise(ArgumentError) do
      editor.draw_horizontal_segment(1, 1, 2, 'aBc')
    end
  end

  def test_draw_horizontal_segment_throws_on_invalid_row_order
    editor = ImageEditor.new()
    editor.create_image(5, 5)

    # col_start > col_end should throw
    col_start = 2
    col_end = 1
    assert_raise(ArgumentError) do
      editor.draw_horizontal_segment(1, col_start, col_end, 'z')
    end
  end

end