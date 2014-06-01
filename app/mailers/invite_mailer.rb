class InviteMailer < ActionMailer::Base
  def invite_nominee(post)
    @good = post
    @nominee = post.nominee
    @nominator = post.user
    if @nominee.email.present?
      mail(to: "'#{@nominee.full_name}' <#{@nominee.email}>", from: "'Do Good' <invites@dogood.mobi>", subject: "You've been nominated!") do |format|
        format.html
        format.text
      end
    end
  end
end
