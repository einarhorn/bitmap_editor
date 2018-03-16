class InputParse

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    # Iterate through each line in file
    File.open(file).each do |line|
      line = line.chomp

      # Split line based on spaces
      split_line = line.split(' ')

      # If line is empty, move to next line
      if split_line.length == 0
        next
      end
      
      case split_line[0]
      when 'I'
        puts 'Create'
      when 'C'
        puts 'Clears'
      when 'L'
        puts 'Color'
      when 'V'
        puts 'Vertical'
      when 'H'
        puts 'Horizontal'
      when 'S'
        puts "Show"
      else
        puts 'Unrecognised command'
      end
    end
  end
end
  