class Order < ApplicationRecord
	belongs_to :product
	
	enum salesman_state: [:waiting,
		                 :processing,
		                  :inprogress,
		                  :delivering,
		                  :fail,
		                  :canceled,
		                  :finished ], _suffix: true
	

    enum delivery_state: [:waiting,
    	                  :accepted_to_salesman,
    	                  :accepted_to_camp,      #vendedor disse q a entrega é da camp
    	                  :camp_inprogress,       #entregador pegou, preparando a entrega(esperando o vendedor fazer)
                          :camp_in_route,         #saiu para a entrega
    	                  :camp_fail,
    	                  :camp_canceled,
    	                  :camp_finished,
    	              	  :salesman_inprogress,
    	              	  :salesman_fail,
    	              	  :salesman_canceled,
    	              	  :salesman_finished], _suffix: true

    enum payment: [ :cc,:cd,:d,:ac ]

	default_scope { order id: :DESC }

	def to_param
  		reference
	end

end


