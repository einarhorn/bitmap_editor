class MissingImageError < StandardError

  EXCEPTION_MSG = "There is no image associated with the image editor"

  def initialize()
    super(EXCEPTION_MSG)
  end

end
  