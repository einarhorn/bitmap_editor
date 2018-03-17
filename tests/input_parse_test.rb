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
  
  def test_color_pixel_successful
    parser = InputParse.new()
    parser.run("tests/test_files/color_pixel_valid.txt")
    assert_equal(true, parser.editor.has_image?())

    # Test file has the instruction:
    #   I 5 5
    #   L 2 2 A
    assert_equal('A', parser.editor.get_pixel(2, 2))
  end

  # Test file has the instruction:
  #   I 5 5
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

    # ..but none of the pixels have been changed
    assert_equal('O', parser.editor.get_pixel(2, 2))
  end

end