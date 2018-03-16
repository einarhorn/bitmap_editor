
require_relative "../lib/image"
require "test/unit"
 
class TestImage < Test::Unit::TestCase
 
  # Test Initialization of Image

  def test_initialization_successful
    im = Image.new(2, 5)
    expected_img_grid = Array[
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O']
    ]
    assert_equal(2, im.rows)
    assert_equal(5, im.cols)
    assert_equal(expected_img_grid, im.image)

    # Test boundary cases of row and col size (i.e. 1 and 250)
    min_coordinate_val = 1
    im = Image.new(min_coordinate_val, min_coordinate_val)
    expected_img_grid = Array[
      ['O'],
    ]
    assert_equal(min_coordinate_val, im.rows)
    assert_equal(min_coordinate_val, im.cols)
    assert_equal(expected_img_grid, im.image)

    max_coordinate_val = 250
    im = Image.new(max_coordinate_val, max_coordinate_val)
    assert_equal(max_coordinate_val, im.rows)
    assert_equal(max_coordinate_val, im.cols)
  end

  def test_initialization_throws_on_invalid_dimensions
    assert_raise(ArgumentError) do
        Image.new(-1, -1)
    end

    assert_raise(ArgumentError) do
      Image.new(251, 251)
    end

    assert_raise(ArgumentError) do
      Image.new(0, 0)
    end
  end

  # get_pixel

  def test_get_pixel
    im = Image.new(2, 5)
    assert_equal('O', im.get_pixel(1, 1))
    assert_equal('O', im.get_pixel(1, 2))
    assert_equal('O', im.get_pixel(1, 3))
    assert_equal('O', im.get_pixel(1, 4))
    assert_equal('O', im.get_pixel(1, 5))

    # get_pixel(row, col) should be equal to im.image[row-1][col-1]
    assert_equal(im.image[1][0], im.get_pixel(2, 1))
    assert_equal(im.image[1][1], im.get_pixel(2, 2))
    assert_equal(im.image[1][2], im.get_pixel(2, 3))
    assert_equal(im.image[1][3], im.get_pixel(2, 4))
    assert_equal(im.image[1][4], im.get_pixel(2, 5))
  end

  def test_get_pixel_throws_on_out_of_bounds
    im = Image.new(2, 5)
    assert_raise(IndexError) do
      im.get_pixel(3, 4)
    end

    assert_raise(IndexError) do
      im.get_pixel(-1, 4)
    end

    assert_raise(IndexError) do
      im.get_pixel(10, 3)
    end
  end

  # color_pixel

  def test_color_pixel_successful
    im = Image.new(2, 5)
    row = col = 1
    assert_equal('O', im.get_pixel(row, col))

    # Color pixel
    im.color_pixel(row, col,'A')
    assert_equal('A', im.get_pixel(row, col))
  end

  def test_color_pixel_throws_on_out_of_bounds
    im = Image.new(2, 5)
    assert_raise(IndexError) do
      im.color_pixel(3, 4, 'A')
    end

    assert_raise(IndexError) do
      im.color_pixel(-1, 4, 'A')
    end

    assert_raise(IndexError) do
      im.color_pixel(10, 3, 'A')
    end
  end

  def test_color_pixel_throws_on_invalid_color_string
    im = Image.new(2, 5)

    # Lowercase character
    assert_raise(ArgumentError) do
      im.color_pixel(1, 1, 'z')
    end

    # Multiple uppercase characters
    assert_raise(ArgumentError) do
      im.color_pixel(1, 1, 'ABC')
    end

    # Combination of above
    assert_raise(ArgumentError) do
      im.color_pixel(1, 1, 'aBc')
    end
  end

end