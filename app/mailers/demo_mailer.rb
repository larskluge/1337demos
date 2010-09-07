class DemoMailer < ActionMailer::Base
  default :to => "me@aekym.com"

  def uploaded_info(demo)
    @demo = demo
    @map = demo.map
    @players_str = demo.players.map{|p| p.to_s(:plain)}.join(", ")

    subject = "New demo uploaded"
    subject += " by #{@players_str}"

    mail(:subject => subject, :from => "newdemo@1337demos.com")
  end
end

