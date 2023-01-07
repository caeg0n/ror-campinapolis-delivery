class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :update, :destroy]

  def index
    pa = params.permit(['device_id','get_length'])
    id = pa['device_id']
    gl = pa["get_length"]
    if (id)
      addresses = Address.where(device_id: id)
    else
      addresses = Address.all
    end
    
    if not gl.nil?
      resp = Address.where(device_id:id).count.to_i
      render json: resp
    else
      render json: addresses
    end

  end

  # def show
  #   render json: @address
  # end

  def create
    @address = Address.new(address_params)
    if @address.save
      render json: @address, status: :created, location: @address
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  # def update
  #   if @address.update(address_params)
  #     render json: @address
  #   else
  #     render json: @address.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @address.destroy
  # end

  private
    def set_address
      @address = Address.find(params[:id])
    end

    def address_params
      params.require(:address).permit(:device_id, :name, :cel, :address)
    end
    
end
