require_relative "../lib/input_parse"
require "test/unit"
 
class TestInputParse < Test::Unit::TestCase
 

# Invalid input breaks immediately, so no editor will be instantiated
  def test_invalid_input_file
    parser = InputParse.new()
    parser.run()
    assert_equal(true, parser.editor.nil?())

    parser = InputParse.new()
    parser.run("tests/test_files/non_existant_file.txt")
    assert_equal(true, parser.editor.nil?())
  end

  # Empty file will instantiate an editor, but no image will be associated with it
  def test_valid_empty_file
    parser = InputParse.new()
    parser.run("tests/test_files/empty_file.txt")
    assert_equal(false, parser.editor.has_image?())
  end

  def test_create_image_successful
    parser = InputParse.new()
    parser.run("tests/test_files/create_image_valid.txt")
    assert_equal(true, parser.editor.has_image?())

    # Test file has the instruction:
    #   "I 4 5"
    assert_equal(4, parser.editor.rows)
    assert_equal(5, parser.editor.cols)
  end

  # Test file has the instruction:
  #   I
  #   I 1
  #   IM 1 2
  #   I 1a 2
  #   I 1 c
  #   I 251 251
  #   I12
  #   I -1 -2
  #   
  #   I 1 2zz
  #   I '1' '2' 
  def test_create_image_fails_on_invalid_input
    parser = InputParse.new()
    parser.run("tests/test_files/create_image_invalid.txt")
    assert_equal(false, parser.editor.has_image?())
  end
  
  # Test file has the instruction:
  #   I 5 5
  #   L 2 2 A
  def test_color_pixel_successful
    parser = InputParse.new()
    parser.run("tests/test_files/color_pixel_valid.txt")
    assert_equal(true, parser.editor.has_image?())
    assert_equal('A', parser.editor.get_pixel(2, 2))
  end

  # Test file has the instruction:
  #   L 1 2 A
  #   I 5 5
  #   L
  #   L 1
  #   L 1 2
  #   La 2 2 A
  #   L 2a 2 A
  #   L 2 2a A
  #   L 2 2 1
  #   L 2 2 A123
  #   L 2 2 a
  #   L 2 2 A 5
  #   L 2 2 'A'
  def test_color_pixel_fails_on_invalid_input
    parser = InputParse.new()
    parser.run("tests/test_files/color_pixel_invalid.txt")
    
    # Image is successfully created..
    assert_equal(true, parser.editor.has_image?())

    # ..but none of the pixels should have been changed
    assert_equal('O', parser.editor.get_pixel(2, 2))
  end

  # Test file has the instruction:
  #   I 5 5
  #   V 2 1 4 A
  def test_draw_vertical_segment_successful
    parser = InputParse.new()
    parser.run("tests/test_files/draw_vertical_segment_valid.txt")
    assert_equal(true, parser.editor.has_image?())
    assert_equal('A', parser.editor.get_pixel(1, 2))
    assert_equal('A', parser.editor.get_pixel(2, 2))
    assert_equal('A', parser.editor.get_pixel(3, 2))
    assert_equal('A', parser.editor.get_pixel(4, 2))
  end

  # Test file has the instruction:
  #    V 1 2 3 A
  #    I 5 5
  #    V
  #    V 1
  #    V 1 2
  #    V 1 2 3
  #    Va 1 2 3 A
  #    V 1a 2 3 A
  #    V 1 2a 3 A
  #    V 1 2 3a A
  #    V 1 2 3 Aa
  #    V 1 2 3 1
  #    V 1 2 3 A a
  #    V 1 2 3 A 1
  #    V 7 2 3 A
  def test_draw_vertical_segment_fails_on_invalid_input
    parser = InputParse.new()
    parser.run("tests/test_files/draw_vertical_segment_invalid.txt")
    
    # Image is successfully created..
    assert_equal(true, parser.editor.has_image?())

    # ..but none of the pixels have been changed
    expected_img_grid = Array[
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O']
    ]
    assert_equal(expected_img_grid, parser.editor.imageGrid)
  end

  # Test file has the instruction:
  #   I 5 5
  #   H 1 2 3 A
  def test_draw_horizontal_segment_successful
    parser = InputParse.new()
    parser.run("tests/test_files/draw_horizontal_segment_valid.txt")
    assert_equal(true, parser.editor.has_image?())
    expected_img_grid = Array[
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['A', 'A', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O']
    ]
    assert_equal(expected_img_grid, parser.editor.imageGrid)
  end

  # Test file has the instruction:
  #   H 1 2 3 A
  #   I 5 5
  #   H
  #   H 1
  #   H 1 2
  #   H 1 2 3
  #   Ha 1 2 3 A
  #   H 1a 2 3 A
  #   H 1 2a 3 A
  #   H 1 2 3a A
  #   H 1 2 3 Aa
  #   H 1 2 3 1
  #   H 1 2 3 A a
  #   H 1 2 3 A 1
  #   H 7 2 3 A
  def test_draw_horizontal_segment_fails_on_invalid_input
    parser = InputParse.new()
    parser.run("tests/test_files/draw_horizontal_segment_invalid.txt")
    
    # Image is successfully created..
    assert_equal(true, parser.editor.has_image?())

    # ..but none of the pixels have been changed
    expected_img_grid = Array[
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O'],
      ['O', 'O', 'O', 'O', 'O']
    ]
    assert_equal(expected_img_grid, parser.editor.imageGrid)
  end

  # Test file has the instruction:
  #   I 5 5
  #   S
  # Note: Unsure how to test against stdout, so no testcase for the failed situation
  def test_show_successful
    parser = InputParse.new()
    parser.run("tests/test_files/show_valid.txt")
    assert_equal(true, parser.editor.has_image?())
  end


end