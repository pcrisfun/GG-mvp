class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    $customerio.identify(
      id: @id,
      created_at: @created_at,
      email: @email,
      first_name: @first_name,
      last_name: @last_name,
    )
  end

  def update
    super
  end
end
