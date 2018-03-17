# spec/image_spec.rb
require_relative "../lib/image"

describe Image do

  let(:image) { Image.new(5, 6) }
  
  describe "#initialize" do
    context "given a valid row/col pair" do


      it "returns the correct row value" do
        expect(image.rows).to eql(5)
      end
      
      it "returns the correct column value" do
        expect(image.cols).to eql(6)
      end
    end

    context "given an row/col pair which is outside the allowed dimensions" do
      it "raises an ArgumentError" do
        expect {Image.new(-1, 5)}.to raise_error ArgumentError
        expect {Image.new(0, 5)}.to raise_error ArgumentError
        expect {Image.new(251, 5)}.to raise_error ArgumentError        
        expect {Image.new(5, -1)}.to raise_error ArgumentError
        expect {Image.new(5, 0)}.to raise_error ArgumentError
        expect {Image.new(5, 251)}.to raise_error ArgumentError
      end
    end
  end

  describe "#set_pixel" do
    it "colors pixels successfully" do
      expect(image.get_pixel(1,1)).to eql 'O'
      expect(image.get_pixel(1,2)).to eql 'O'
      image.set_pixel(1,1, 'A')
      image.set_pixel(1,2, 'A')
      expect(image.get_pixel(1,1)).to eql 'A'
      expect(image.get_pixel(1,2)).to eql 'A'
    end

    it "raises error on attempt to color pixel that is out of bounds" do
      expect {image.set_pixel(2, 7, 'A')}.to raise_error IndexError
      expect {image.set_pixel(7, 2, 'A')}.to raise_error IndexError
      expect {image.set_pixel(0, 0, 'A')}.to raise_error IndexError
    end

    it "raises error on attempt to use color that is not a single capital letter" do
      expect {image.set_pixel(2, 2, 'a')}.to raise_error ArgumentError
      expect {image.set_pixel(2, 2, 'AA')}.to raise_error ArgumentError
      expect {image.set_pixel(2, 2, '1')}.to raise_error ArgumentError
      expect {image.set_pixel(2, 2, '1a')}.to raise_error ArgumentError
      expect {image.set_pixel(2, 2, 'Aa')}.to raise_error ArgumentError
      expect {image.set_pixel(2, 2, '.')}.to raise_error ArgumentError
    end
  end

  describe "#get_pixel" do
    it "gets pixel successfully" do
      expect(image.get_pixel(1,1)).to eql 'O'
    end

    it "raises error on attempt to get pixel that is out of bounds" do
      expect {image.get_pixel(2, 7)}.to raise_error IndexError
      expect {image.get_pixel(7, 2)}.to raise_error IndexError
      expect {image.get_pixel(0, 0)}.to raise_error IndexError
    end

  end

  describe "#outside_curr_image_bounds?" do
    it "returns false when row/col is within image bounds" do
      expect(image.outside_curr_image_bounds?(1,1)).to eql false
      expect(image.outside_curr_image_bounds?(2,3)).to eql false
      expect(image.outside_curr_image_bounds?(5,6)).to eql false
    end

    it "returns true when row/col is outside image bounds" do
      expect(image.outside_curr_image_bounds?(0,0)).to eql true
      expect(image.outside_curr_image_bounds?(-1,0)).to eql true
      expect(image.outside_curr_image_bounds?(3,8)).to eql true
      expect(image.outside_curr_image_bounds?(8,3)).to eql true
    end
  end
end