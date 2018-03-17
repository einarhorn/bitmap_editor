class UnrecognisedCommandError < StandardError

  EXCEPTION_MSG = "Command could not be recognised."

  def initialize()
    super(EXCEPTION_MSG)
  end

end
  