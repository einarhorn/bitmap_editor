class InvalidCommandError < StandardError

  EXCEPTION_MSG = "Command is invalid"

  def initialize(message=nil)
      message = EXCEPTION_MSG + ": " + message
      super(message)
  end

end