GirlsGuild::Application.routes.draw do


  resources :signups
  resources :app_signups do
    collection do
      post :accept
      post :decline
      post :confirm
      post :cancel
    end
  end
  resources :work_signups

  match '/preregs/create', to: 'preregs#create'

  devise_for :users, :admins
    #get 'users/avatar.:id' => 'devise/registrations#avatar'


  resources :galleries, only: [:new, :create, :destroy]

  resources :albums, path: 'portfolio' do
    collection do
      post :add_photos
      post :remove_photos
      post :set_featured
    end
  end

  resources :photos do
    collection do
      post :sort
    end
  end

  resources :apprenticeships do
    resources :app_signups
    collection do
      post :cancel
      get :info
      get :checkmarks
    end
  end
  match 'apprenticeships/:id/private' => 'apprenticeships#private', as: :private_apprenticeship
  match 'apprenticeships/:id/payment' => 'apprenticeships#payment', as: :payment_apprenticeship
  match 'apprenticeships/:id/confirmation' => 'apprenticeships#payment_confirmation', as: :payment_confirmation_apprenticeship

  resources :workshops do
    resources :work_signups
    collection do
      get :workshop_album
      post :cancel
    end
  end

  resources :event_skills, only: [:index]
  resources :event_tools, only: [:index]
  resources :event_requirements, only: [:index]

  resources :inquiries, only: [:create] do
    get 'static_pages/thanks', :on => :collection
  end

  root to: 'static_pages#home'

  match '/stripe/webhook', to: 'stripe#webhook'

  match '/faq', to: 'static_pages#faq'
  match '/about', to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/thankyou', to: 'static_pages#thankyou'
  match '/newsletter', to: 'static_pages#newsletter'
  match '/get_involved', to: 'static_pages#get_involved'
  match '/testimonials', to: 'static_pages#testimonials'
  match '/privacypolicy', to:'static_pages#privacypolicy'
  match '/termsandconditions', to:'static_pages#termsandconditions'

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
