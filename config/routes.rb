Atrium::Engine.routes.draw do
  resources :collections do
    resources :exhibits
    resource :showcases, :only => [:new]
  end
  resources :exhibits do
    resource :showcases, :only => [:new]
  end
resources :showcases, :only => [:show]
  resources :descriptions do
    resources :essays
  end
  root :to => "collections#index"
end
