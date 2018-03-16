class MissingImageError < StandardError

    def initialize(message, action)
      # Call the parent's constructor to set the message
      super(message)
    end
  
  end
  