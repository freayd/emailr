class AccountMailer < ActionMailer::Base
  def signup_notification(account)
    setup_email(account)
    @subject    += 'Please activate your new account'
    @body[:url]  = activate_url(:activation_code => account.activation_code)
  end

  def activation(account)
    setup_email(account)
    @subject    += 'Your account has been activated!'
    @body[:url]  = root_url
  end

  protected
    def setup_email(account)
      @recipients  = "#{account.email}"
      @from        = ApplicationConfig['email.from']
      @subject     = ApplicationConfig['email.subject.prefix']
      @sent_on     = Time.now
      @body[:account] = account
    end
end
