if Rails.env == 'production'
  Stripe.api_key = "sk_live_Insert Stripe key here when deploying to production"
  STRIPE_PUBLIC_KEY = "pk_live_Insert Stripe key here when deploying to production"
else 
  Stripe.api_key = "sk_test_nIvcIxpwsJ9qBFScxU2vkKnD"
  STRIPE_PUBLIC_KEY = "pk_test_8f4vXOu39d1v3RyyYb3XyA4I"
end