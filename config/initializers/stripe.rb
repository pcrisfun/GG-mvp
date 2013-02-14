if Rails.env == 'production'
  Stripe.api_key = ENV["STRIPE_API_KEY"]
  STRIPE_PUBLIC_KEY = ENV["STRIPE_PUBLIC_KEY"]
else 
  Stripe.api_key = "sk_test_nIvcIxpwsJ9qBFScxU2vkKnD"
  STRIPE_PUBLIC_KEY = "pk_test_8f4vXOu39d1v3RyyYb3XyA4I"
end