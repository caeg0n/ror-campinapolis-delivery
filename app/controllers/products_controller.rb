class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # def index
  #   products = Product.all
  #   render json: products
  # end

  def all_not_excluded_and_paused
    products1 = Product.where(status:'active')
    products2 = Product.where(status: nil)
    render json: products1+products2
  end

  # def show
  #   render json: @product
  # end

  def get_length
    render json: Product.where(organization_id:params[:id].to_i).count
  end

  def create
    binding.pry
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # def update
  #   if @product.update(product_params.except(:id,:img))
  #     render json: @product
  #   else
  #     render json: @product.errors, status: :unprocessable_entity
  #   end
  # end

  # def pause_product
  #   pa = params['product'].permit(['id','status'])
  #   id = pa['id']
  #   status = pa['status']
  #   status = 'paused' if status == "1"
  #   status = 'active' if status == "2"
  #   product = Product.find(id)
  #   if product.status == 'active'
  #     product.status = 'paused'
  #   else
  #     if product.status == 'paused'
  #       product.status = 'active'
  #     end 
  #   end
  #   product.status = status if product.status.nil?
  #   if product.save
  #     render json: product
  #   else
  #     render json: product.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy_product
  #   pa = params['product'].permit(['id','status'])
  #   id = pa['id']
  #   status = pa['status']
  #   status = 'paused' if status == "1"
  #   status = 'active' if status == "2"
  #   status = 'excluded' if status == "0"
  #   product = Product.find(id)
  #   if product.status == 'active'
  #     product.status = 'excluded'
  #   else
  #     if product.status == 'paused'
  #       product.status = 'excluded'
  #     end 
  #   end
  #   product.status = status if product.status.nil?
  #   if product.save
  #     render json: product
  #   else
  #     render json: product.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @product.destroy
  # end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :category,:description, :price, :img,:organization_id)
    end
end
