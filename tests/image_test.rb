
require_relative "../lib/image"
require "test/unit"
 
class TestImage < Test::Unit::TestCase
 
  def test_initialization_successful
    im = Image.new(10, 20)
    assert_equal(10, im.rows)
    assert_equal(20, im.cols)

    # Test boundary cases of row and col size (i.e. 1 and 250)
    min_coordinate_val = 1
    im = Image.new(min_coordinate_val, min_coordinate_val)
    assert_equal(min_coordinate_val, im.rows)
    assert_equal(min_coordinate_val, im.cols)

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
end