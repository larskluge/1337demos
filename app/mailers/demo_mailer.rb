class DemoMailer < ActionMailer::Base
  default :to => "me@aekym.com"

  def uploaded_info(demo)
    @demo = demo
    @map = demo.map
    @players = demo.players

    subject = "New demo uploaded"
    subject += " by #{@players}"

    mail(:subject => subject, :from => "newdemo@1337demos.com")
  end
end

