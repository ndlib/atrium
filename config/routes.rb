Atrium::Engine.routes.draw do
  resources :collections, :exhibits do
    resource :showcases, :only => [:new]
  end
  resources :showcases, :only => [:show]
  resources :descriptions do
    resource :essays
  end
  root :to => "collections#index"
end
