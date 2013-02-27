class AppSignup < Signup

#validates :parent, :presence => true
#validates :waiver, :acceptance => true

  def is_parent
    :parent == true
  end

  def process_apprent_fee
    logger.info "Processing payment"
    unless charge_id.present?
      charge = Stripe::Charge.create(
        :amount => 2900, # amount in cents, again
        :currency => "usd",
        :card => stripe_card_token,
        :description => "Apprenticeship fee for #{self.event.title} from #{self.user.email}"
      )
      update_attribute(:charge_id, charge.id)
      logger.info "Processed payment #{charge.id}"
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def deliver
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
          :from => "GirlsGuild<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Application for #{event.title}",
      :html_body => %(<h1>Thanks!</h1> <p>You've applied for '<a href="#{url_for(self.event)}">#{event.title}</a>. (Fill out this email with more info, etc)</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
end