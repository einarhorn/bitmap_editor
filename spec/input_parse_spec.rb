# spec/image_spec.rb
require_relative "../lib/input_parse"

describe InputParse do

  let(:parser) { InputParse.new() }
  
  context "unit tests" do
    describe "#run" do
      context "given a nonexistant file" do
        it "outputs an invalid file message" do
          expected_msg = "Please provide correct file\n"
          expect{ parser.run("nonexistant_file.txt") }.to output(expected_msg).to_stdout
        end
      end

      context "given no params" do
        it "outputs an invalid file message" do
          expected_msg = "Please provide correct file\n"
          expect{ parser.run() }.to output(expected_msg).to_stdout
        end
      end

      context "given a valid file" do

        let(:mock_editor) { mock_editor = instance_double(ImageEditor) }
        before(:each) {
          # Create a mocked version of ImageEditor class for checking method calls
          expect(ImageEditor).to receive(:new).and_return(mock_editor).at_least(:once)
        }
    
        context "attempting to create image" do
          it "calls the appropriate create image function in editor" do
            file = "examples/create_image_valid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            parser.run(file)
          end
          
          it "never calls the create image function if input is invalid" do
            file = "examples/create_image_invalid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).not_to receive(:create_image)
            parser.run(file)
          end
          
        end

        context "attempting to clear image" do
          it "calls the appropriate clear image function in editor" do
            file = "examples/clear_image_valid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).to receive(:clear_image).and_return(nil)
            parser.run(file)
          end

          it "never calls the clear image function if input is invalid" do
            file = "examples/clear_image_invalid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).not_to receive(:clear_image)
            parser.run(file)
          end
        end

        context "attempting to color pixel" do
          it "calls the appropriate color pixel function in editor" do
            file = "examples/color_pixel_valid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).to receive(:color_pixel).and_return(nil)
            parser.run(file)
          end

          it "never calls the color pixel function if input is invalid" do
            file = "examples/color_pixel_invalid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).not_to receive(:color_pixel)
            parser.run(file)
          end
        end
        
        context "attempting to draw vertical segment" do
          it "calls the appropriate draw vertical segment function in editor" do
            file = "examples/draw_vertical_segment_valid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).to receive(:draw_vertical_segment).and_return(nil)
            parser.run(file)
          end

          it "never calls the draw vertical function if input is invalid" do
            file = "examples/draw_vertical_segment_invalid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).not_to receive(:draw_vertical_segment)
            parser.run(file)
          end

        end

        context "attempting to draw horizontal segment" do
          it "calls the appropriate draw horizontal segment function in editor" do
            file = "examples/draw_horizontal_segment_valid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).to receive(:draw_horizontal_segment).and_return(nil)
            parser.run(file)
          end

          it "never calls the draw horizontal function if input is invalid" do
            file = "examples/draw_horizontal_segment_invalid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).not_to receive(:draw_horizontal_segment)
            parser.run(file)
          end
        end

        context "attempting to show image" do 
          it "calls the appropriate show image function in editor" do
            file = "examples/show_valid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).to receive(:show).and_return(nil)
            parser.run(file)
          end

          it "never calls the show image function if input is invalid" do
            file = "examples/show_invalid.txt"
            expect(mock_editor).to receive(:create_image).and_return(nil)
            expect(mock_editor).not_to receive(:show)
            parser.run(file)
          end

        end
        
        context "attempting to execute unknown command" do
          it "prints out error message" do
            file = "examples/unknown_command.txt"
            expected_msg = "Z: Command could not be recognised.\n"
            expect{ parser.run(file) }.to output(expected_msg).to_stdout
          end
        end

        
      end
    end
  end

  context "integration testing" do
    context "attempting to print example file" do
      it "prints out expected grid" do
        file = "examples/example1.txt"
        expected_output =
          "O O O O O\n" +
          "O O Z Z Z\n" +
          "A W O O O\n" +
          "O W O O O\n" +
          "O W O O O\n" +
          "O W O O O\n"
        expect{ parser.run(file) }.to output(expected_output).to_stdout
      end
    end
  end
end