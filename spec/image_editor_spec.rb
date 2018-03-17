# spec/image_spec.rb
require_relative "../lib/image_editor"
require_relative "../lib/image"
describe ImageEditor do

  
  

  context "with image created" do
    let(:editor) { ImageEditor.new() }
    let(:mock_image) { mock_image = instance_double(Image) }
    before(:each) {
      # Create a mocked version of image class for checking method calls
      
      expect(Image).to receive(:new).and_return(mock_image).at_least(:once)
      editor.create_image(5,5)
    }

    it "should have an image associated with it" do
      expect(editor.has_image?).to eql true
    end

    describe "#create_image" do
      it "trying to create image is successful" do
        editor.create_image(2,5)
        expect(editor.has_image?).to eql true
      end
    end

    describe "#rows" do
      it "should call rows in Image class" do
        # Verify that this method calls :row in Image class
        expect(mock_image).to receive(:rows)
        editor.rows
      end
    end

    describe "#cols" do
      it "should call cols in Image class" do
        # Verify that this method calls :cols in Image class
        expect(mock_image).to receive(:cols)
        editor.cols
      end
    end

    describe "#imageGrid" do
      it "should call imageGrid in Image class" do
        # Verify that this method calls :imageGrid in Image class
        expect(mock_image).to receive(:imageGrid)
        editor.imageGrid
      end
    end

    describe "#clear_image" do
      it "calls create_image in ImageEditor" do
        expect(editor).to receive(:create_image).and_return(nil)
        editor.clear_image()
      end
    end

    describe "#color_pixel" do
      it "should call set_pixel in Image class" do
        expect(mock_image).to receive(:set_pixel)
        editor.color_pixel(1,1,'A')
      end
    end

    describe "#get_pixel" do
      it "should call get_pixel in Image class" do
        expect(mock_image).to receive(:get_pixel)
        editor.get_pixel(1,1)
      end
    end

    describe "#draw_vertical_segment" do
      it "should call color_pixel equival to the number of pixels that need to be filled" do
        expect(mock_image).to receive(:outside_curr_image_bounds?).and_return(false).at_least(:once)
        expect(editor).to receive(:color_pixel).and_return(nil).exactly(5).times
        editor.draw_vertical_segment(1,1,5,'A')
      end

      it "should draw succesfully regardless of start and end order" do
        expect(mock_image).to receive(:outside_curr_image_bounds?).and_return(false).at_least(:once)
        expect(editor).to receive(:color_pixel).and_return(nil).exactly(5*2).times
        editor.draw_vertical_segment(1,1,5,'A')
        editor.draw_vertical_segment(1,5,1,'B')
      end

      it "should raise error if any portion of the segment would be out of bounds" do
        expect(mock_image).to receive(:outside_curr_image_bounds?).and_return(true).at_least(:once)
        expect {editor.draw_vertical_segment(1,0,5,'A')}.to raise_error IndexError
        expect {editor.draw_vertical_segment(1,3,8,'B')}.to raise_error IndexError
      end
    end

    describe "#draw_horizontal_segment" do
      it "should call color_pixel equival to the number of pixels that need to be filled" do
        expect(mock_image).to receive(:outside_curr_image_bounds?).and_return(false).at_least(:once)
        expect(editor).to receive(:color_pixel).and_return(nil).exactly(5).times
        editor.draw_horizontal_segment(1,1,5,'A')
      end

      it "should draw succesfully regardless of start and end order" do
        expect(mock_image).to receive(:outside_curr_image_bounds?).and_return(false).at_least(:once)
        expect(editor).to receive(:color_pixel).and_return(nil).exactly(5*2).times
        editor.draw_horizontal_segment(1,1,5,'A')
        editor.draw_horizontal_segment(1,5,1,'B')
      end

      it "should raise error if any portion of the segment would be out of bounds" do
        expect(mock_image).to receive(:outside_curr_image_bounds?).and_return(true).at_least(:once)
        expect {editor.draw_horizontal_segment(1,0,5,'A')}.to raise_error IndexError
        expect {editor.draw_horizontal_segment(1,3,8,'B')}.to raise_error IndexError
      end
    end
  end

  context "without image created" do

    let(:editor) { ImageEditor.new() }
    
    describe "#create_image" do
      it "trying to create image is successful" do
        editor.create_image(2,5)
        expect(editor.has_image?).to eql true
      end
    end

    describe "#has_image?" do
      it "should not have an image associated with it" do
        expect(editor.has_image?).to eql false
      end
    end

    describe "#rows" do
      it "trying to retrieve number of rows in image raises an error" do
        expect {editor.rows}.to raise_error MissingImageError
      end
    end

    describe "#cols" do
      it "trying to retrieve number of cols in image raises an error" do
        expect {editor.cols}.to raise_error MissingImageError
      end
    end

    describe "#imageGrid" do
      it "trying to retrieve image as grid raises an error" do
        expect {editor.imageGrid}.to raise_error MissingImageError
      end
    end

    describe "#clear_image" do
      it "trying to clear image raises an error" do
        expect {editor.clear_image}.to raise_error MissingImageError
      end
    end

    describe "#color_pixel" do
      it "trying to color a pixel raises an error" do
        expect {editor.color_pixel(1,1,'A')}.to raise_error MissingImageError
      end
    end

    describe "#get_pixel" do
      it "trying to get a pixel raises an error" do
        expect {editor.get_pixel(1,1)}.to raise_error MissingImageError
      end
    end

    describe "#draw_vertical_segment" do
      it "trying to draw vertical segment raises an error" do
        expect {editor.draw_vertical_segment(1,1,2,'A')}.to raise_error MissingImageError
      end
    end

    describe "#draw_horizontal_segment" do
      it "trying to draw horizontal segment image raises an error" do
        expect {editor.draw_horizontal_segment(1,1,2,'A')}.to raise_error MissingImageError
      end
    end

    describe "#show" do
      it "trying to show image raises an error" do
        expect {editor.clear_image}.to raise_error MissingImageError
      end
    end
  end
end