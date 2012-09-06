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

  resources :showcases, only: [:show]
  resources :showcases do
    resources :descriptions do
      resources :essays
    end
  end
  root to: "collections#index"

  match 'collections/:id/exhibit_order/update',
    to: 'order#update_collection_exhibits_order',
    as: 'update_collection_exhibit_order',
    via: :post
  match 'collections/:id/showcase_order/update',
    to: 'order#update_collection_showcases_order',
    as: 'update_collection_showcase_order',
    via: :post
  match 'exhibits/:id/facet_order/update',
    to: 'order#update_exhibit_facets_order',
    as: 'update_exhibit_facet_order',
    via: :post
  match 'exhibits/:id/showcase_order/update',
    to: 'order#update_exhibit_showcases_order',
    as: 'update_exhibit_showcase_order',
    via: :post
  match 'showcase/browse_level_showcase/exhibit_id',
    to: 'showcases#add_or_update',
    as: 'get_browse_level_showcase'
end
