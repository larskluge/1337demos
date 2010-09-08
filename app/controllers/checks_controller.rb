class ChecksController < ApplicationController

  # action to check mail notification upon exceptions
  #
  def fail
    raise Exception, "You asked for it!"
  end
end

