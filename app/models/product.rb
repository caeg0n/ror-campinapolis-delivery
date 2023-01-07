class Product < ApplicationRecord
	has_many :orders
	belongs_to :organization


	enum category: [
		             :generico,
		             :tabacaria,
		             :bebida,
		             :alimento,
		             :eletronico
		           ]

    enum status: [
    				:excluded,
    				:paused,
    				:active
    			]
end
