require_relative "../lib/input_parse"
require "test/unit"
 
class TestInputParse < Test::Unit::TestCase
 

# Invalid input breaks immediately, so no editor will be instantiated
  def test_invalid_input_file
    parser = InputParse.new()
    parser.run()
    assert_equal(true, parser.editor.nil?)

    parser = InputParse.new()
    parser.run("tests/test_files/non_existant_file.txt")
    assert_equal(true, parser.editor.nil?)
  end

  # Empty file will instantiate an editor, but no image will be associated with it
  def test_valid_empty_file
    parser = InputParse.new()
    parser.run("tests/test_files/empty_file.txt")
    assert_equal(false, parser.editor.has_image?)
  end

  def test_create_image_successful
    parser = InputParse.new()
    parser.run("tests/test_files/create_image_valid.txt")
    assert_equal(true, parser.editor.has_image?)

    # Test file has the instruction:
    #   "I 4 5"
    assert_equal(4, parser.editor.rows)
    assert_equal(5, parser.editor.cols)
  end

  # Test file has the instruction:
  #   
  def test_create_image_fails_on_invalid_input
    parser = InputParse.new()
    parser.run("tests/test_files/create_image_invalid.txt")
    assert_equal(false, parser.editor.has_image?)
  end
  

end