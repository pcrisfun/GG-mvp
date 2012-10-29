if Rails.env == 'production'
  Stripe.api_key = "sk_live_N5qXhrr53n7AugwYrsPwTrID"
  STRIPE_PUBLIC_KEY = "pk_live_rGypauEyvX1eS6TRAllHJjP0"
else 
  Stripe.api_key = "sk_test_nIvcIxpwsJ9qBFScxU2vkKnD"
  STRIPE_PUBLIC_KEY = "pk_test_8f4vXOu39d1v3RyyYb3XyA4I"
end