class InviteMailer < ActionMailer::Base
  def invite_nominee(nominee, nominator)
    @nominee = nominee
    @nominator = nominee
    if @nominee.email.present?
      mail(to: "'#{@nominee.full_name}' <#{@nominee.email}>", from: "'Do Good' <invites@dogood.mobi>", subject: "You've been nominated!") do |format|
        format.html
        format.text
      end
    end
  end
end
