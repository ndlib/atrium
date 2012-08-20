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
  match 'showcases/add_featured/:id',     :to => 'showcases#add_featured',                  :as => 'add_featured'
  match 'showcases/remove_featured/:id',  :to => 'showcases#remove_featured',           :as => 'remove_featured', :via => :post
  match 'showcases/parent/:id',           :to => 'showcases#parent',           :as => 'showcase_parent'

end

