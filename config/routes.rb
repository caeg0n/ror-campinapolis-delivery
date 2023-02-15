Rails.application.routes.draw do
  	mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
	mount ActionCable.server => '/cable'
	
	resources :notifications
	resources :deliveries
	resources :orders, param: :reference
	resources :addresses
	resources :products
	resources :organizations
	resources :organization_category_tags
  	resources :categories
  	resources :rankings

	get 'print', to: "print#index"
	
	post 'login', to: "organizations#login"
	post 'notification/register', to: "notifications#register"
	post 'notification/update_token', to: "notifications#update_token" 
	
	put 'update_delivery_state', to: "orders#update_delivery_state"
	put 'update_deliveryman_state', to: "orders#update_deliveryman_state"
	put 'update_sale_state', to: "orders#update_sale_state"
	put 'pause_product', to: "products#pause_product"
	put 'destroy_product', to: "products#destroy_product"

	get 'get_orders_lenght', to: "orders#get_orders_lenght"
	get 'get_orders_lenght_for_deliveryman',to: "orders#get_orders_lenght_for_deliveryman"
	get 'get_orders_lenght_for_salesman',to: "orders#get_orders_lenght_for_salesman"
	get 'get_deliveries_lenght', to: "deliveries#get_deliveries_lenght"
	get 'all_not_excluded_and_paused', to: "products#all_not_excluded_and_paused"
	get 'organizations/close/:id', to: "organizations#close"
	get 'organizations/open/:id', to: "organizations#open"
	get 'organizations/info/:id', to: "organizations#info"
	get 'get_products_length/:id', to: "products#get_length"
	get 'organizations_by_category/:name', to: "categories#get_organizations"

	get 'get_all_organizations_with_distinct_category', to: "organizations#get_all_with_distinct_category"
	get 'get_all_categories', to: "categories#index"
	get 'get_all_opened_organizations', to: "organizations#opened_organizations"
	get 'get_all_closed_organizations', to: "organizations#closed_organizations"
	get 'get_most_popular/:number', to: "organizations#most_popular"
	get 'get_recommended_places', to: "organizations#recommended_places"
	get 'get_hot_deals', to: "organizations#hot_deals"
end
