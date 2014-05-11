class InviteMailer < ActionMailer::Base
  def invite_nominee(nominee)
    @nominee = nominee
    mail(:to => @nominee.email, :from => "invites@dogood.mobi", :subject => "You've been nominated at Do Good") do |format|
      format.html
      format.text
    end
  end
end
