Atrium::Engine.routes.draw do
  resources :collections do
    resources :exhibits do
      member do
        get :include_filter
        get :exclude_filer
      end
    end
    resources :showcases
  end
  resources :exhibits do
    resources :showcases
  end

  resources :showcases, :only => [:show]
  resources :showcases do
    resources :descriptions do
      resources :essays
    end
  end
  root :to => "collections#index"

  match "showcase/browse_level_showcase/exhibit_id",    :to => "showcases#add_or_update",    :as => "get_browse_level_showcase"
end

