class Order < ApplicationRecord
	belongs_to :product

	enum order_status: { 
											 client_order_sent: 1,
	 										 client_canceled: 2, 
											 organization_receive: 3, 
											 organization_confirm: 4,
											 organization_canceled: 5,
											 organization_preparing: 6,
											 organization_request_deliver: 7,
											 organization_order_sent: 8,
											 deliveryman_accepted: 9,
											 deliveryman_giveup: 10,
											 deliveryman_on_the_way: 11,
											 deliveryman_fail_and_return: 12, #ex: endereço errado
											 deliveryman_fail_without_return: 13, #ex:accident
											 organization_delivery_new_attempt: 14,
											 organization_giveup: 15,
											 client_giveup: 16,
											 deliveryman_comfirm_finish: 17,
											 client_confirm_finish: 18,
											 organization_confirm_finish: 19
										 }
	
	# enum salesman_state: [:waiting,
	# 	                 :processing,
	# 	                  :inprogress,
	# 	                  :delivering,
	# 	                  :fail,
	# 	                  :canceled,
	# 	                  :finished ], _suffix: true
	

  #   enum delivery_state: [:waiting,
  #   	                  :accepted_to_salesman,
  #   	                  :accepted_to_camp,      #vendedor disse q a entrega é da camp
  #   	                  :camp_inprogress,       #entregador pegou, preparando a entrega(esperando o vendedor fazer)
  #                       :camp_in_route,         #saiu para a entrega
  #   	                  :camp_fail,
  #   	                  :camp_canceled,
  #   	                  :camp_finished,
  #   	              	  :salesman_inprogress,
  #   	              	  :salesman_fail,
  #   	              	  :salesman_canceled,
  #   	              	  :salesman_finished], _suffix: true

	enum payment: [ :nada,
									:dinheiro,
									:cartao_credito,
									:cartao_debito,
									:fiado,
									:pix 
								]

	default_scope { order id: :DESC }

	def to_param
  		reference
	end

end


