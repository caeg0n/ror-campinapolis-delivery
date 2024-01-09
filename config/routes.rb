Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
	mount ActionCable.server => '/cable'
	
	#resources :addresses
	#resources :payments
	#resources :orders, param: :reference
	#resources :notifications
  #resources :rankings
	#resources :products
	resources :deliveries
	resources :organizations
	resources :organization_category_tags
  resources :categories
  	
	delete 'addresses', to: 'addresses#destroy'

	post 'orders', to: "orders#create"
	post 'login', to: "organizations#login"
	post 'notification/register', to: "notifications#register"
	post 'notification/update_token', to: "notifications#update_token"
	post 'addresses', to: "addresses#create"
	post 'products', to: "products#create"
  #post 'organization_devices', to: 'organization_devices#create', defaults: { format: :json }

	put 'update_delivery_state', to: "orders#update_delivery_state"
	put 'update_deliveryman_state', to: "orders#update_deliveryman_state"
	put 'update_sale_state', to: "orders#update_sale_state"
	put 'pause_product', to: "products#pause_product"
	put 'destroy_product', to: "products#destroy_product"
	put 'organization_state', to: "organizations#update_state"
	put 'organization_delivery_type', to: "organizations#update_organization_delivery_type", defaults: { format: :json }

	#get 'print', to: "print#index"
	#get 'get_products_length/:id', to: "products#get_length"
	get 'get_orders/organization/:organization_id', to: "orders#index"
	get 'get_orders/device/:device_id', to: "orders#index", defaults: { format: :json }
	get 'get_orders_lenght', to: "orders#get_orders_lenght"
	get 'get_orders_lenght_for_deliveryman',to: "orders#get_orders_lenght_for_deliveryman"
	get 'get_orders_lenght_for_salesman',to: "orders#get_orders_lenght_for_salesman"
	get 'get_deliveries_lenght', to: "deliveries#get_deliveries_lenght"
	get 'get_addresses/:device_id', to: "addresses#index"
	get 'all_not_excluded_and_paused', to: "products#all_not_excluded_and_paused"
	get 'organizations/close/:id', to: "organizations#close"
	get 'organizations/open/:id', to: "organizations#open"
	get 'organizations/info/:id', to: "organizations#info"
	get 'organizations_by_category/:name', to: "categories#get_organizations"
	get 'order_status_list', to: "orders#get_order_status_list"
	get 'order_status_base_list', to: "orders#get_order_status_base_list"
	get 'order_status_block_list', to: "orders#get_order_status_block_list"
	
	get 'get_all_organizations_with_distinct_category', to: "organizations#get_all_with_distinct_category"
	get 'get_all_categories', to: "categories#index"
	get 'get_all_opened_organizations', to: "organizations#opened_organizations"
	get 'get_all_closed_organizations', to: "organizations#closed_organizations"
	get 'get_most_popular/:number', to: "organizations#most_popular"
	get 'get_recommended_places', to: "organizations#recommended_places"
	get 'get_hot_deals', to: "organizations#hot_deals"
	get 'get_categories_and_products', to: "organizations#get_categories_and_products"
	get 'get_payments_methods', to: "payments#list_all_methods"
	get 'organization_devices', to: "organization_devices#find", defaults: { format: :json }
end
