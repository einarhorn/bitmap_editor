class UnrecognisedCommandError < StandardError

    EXCEPTION_MSG = "This command could not be recognised."

    def initialize()
      super(EXCEPTION_MSG)
    end

  end
  