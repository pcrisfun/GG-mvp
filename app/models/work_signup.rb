class WorkSignup < Signup

  validates :waiver, :acceptance => true

  def default_url_options
    { :host => 'localhost:3000'}
  end

  def process_workshop_fee
    logger.info "Processing payment"
    unless charge_id.present?
      charge = Stripe::Charge.create(
        :amount => (self.event.price*1.2*100).to_i, # amount in cents, again
        :currency => "usd",
        :card => stripe_card_token,
        :description => "Workshop fee for #{self.event.title} from #{self.user.email}"
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
      :subject => "You signed up for #{event.topic} with #{event.host_firstname} #{event.host_lastname}",
      :html_body => %(<h1>Thanks!</h1> <p>You're all signed up for '<a href="#{url_for(self.event)}">#{event.title}</a>. (Fill out this email with more info, etc)</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def self.complete_work_signup
    work_signups = self.event.where(:begins_at => Date.today).all
    work_signups.each {|w| w.complete}
  end

  state_machine :state, :initial => :started do
    event :complete do
      transition :confirmed => :completed
    end
  end
end



