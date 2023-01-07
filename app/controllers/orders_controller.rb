class OrdersController < ApplicationController
  before_action :set_orders, only: [:show, :update, :destroy]

  def index
    #[{},{},{},{}]
    if !organization_id['organization_id']
      id = device_id['device_id']
      orders = Order.where(device_id: id).group_by(&:reference)
    else
      id = organization_id['organization_id']
      if (Organization.find(id).organization_type == 'salesman')
        orders = Order.joins(:product).where("products.organization_id = ?", id).group_by(&:reference)
      end
      aux = []
      result = []
      if (Organization.find(id).organization_type == 'deliveryman')
        orders = Order.select("products.*,orders.*").joins(:product)
                                                    .where(delivery_state: :accepted_to_camp)
                                                    .group_by(&:reference)
        orders.each do |key,value|
          b = value.group_by{ |a| a["organization_id"] }
          b.each_value do |v|
            result << v
          end
        end
        orders = result
      end
    end
    render json: orders
  end

  def get_orders_lenght
    pa = params.permit(['device_id'])
    id = pa['device_id']
    render json: Order.where(device_id:id).count
  end

  def get_orders_lenght_for_deliveryman
    pa = params.permit(['organization_id'])
    id = pa['organization_id']
    if (Organization.find(id).organization_type == 'deliveryman')
      render json: Order.where(delivery_state: :accepted_to_camp).count
    end
  end


  def get_orders_lenght_for_salesman
    pa = params.permit(['organization_id'])
    id = pa['organization_id']
    if (Organization.find(id).organization_type == 'salesman')
      result = Order.joins(:product).where("products.organization_id = ?",id).count
      render json: result
    end
  end


  # def show
  #   render json: @order
  # end

  def create
    order = Order.new(order_params)
    client = order.consumer_name
    if order.save
      id = order.product_id
      organization_id = Product.find(id).organization_id
      organization_name = Organization.find(organization_id).name
      send_message_to_admins({client:client,organization:organization_name})
      send_message_to_organization({client:client,organization_id:organization_id})
      render json: "ok", status: :created, location: order
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def update_sale_state
    pa = params['order'].permit(['sale_state','organization_id','reference'])
    sale_state = pa["sale_state"]
    reference = pa['reference']
    organization_id = pa['organization_id'].to_i
    orders = Order.where(reference:reference).joins(:product).where("products.organization_id = ?",organization_id)
    orders.each do |order|
      order.update(salesman_state:"waiting") if sale_state == 0
      order.update(salesman_state:"processing") if sale_state == 1
      order.update(salesman_state:"inprogress") if sale_state == 2
      order.update(salesman_state:"delivering") if sale_state == 3
      order.update(salesman_state:"fail") if sale_state == 4
      order.update(salesman_state:"canceled") if sale_state == 5
      order.update(salesman_state:"finished") if sale_state == 6
    end
      ActionCable.server.broadcast 'salesman_channel', data: "update"
      ActionCable.server.broadcast 'client_channel', data: "update"
      ActionCable.server.broadcast 'deliveryman_channel', data: "update"
      render json: "ok"
  end

  def update_delivery_state
    pa = params['order'].permit(['delivery_state','organization_id','reference'])
    delivery_state = pa['delivery_state']
    organization_id = pa['organization_id'].to_i
    reference = pa['reference']
    order = Order.where(reference:reference).joins(:product).where("products.organization_id = ?",organization_id)
    order.each do |o|
      o.delivery_state = "waiting" if delivery_state == 0
      o.delivery_state = "accepted_to_salesman" if delivery_state == 1
      o.delivery_state = "accepted_to_camp" if delivery_state == 2
      o.delivery_state = "camp_inprogress" if delivery_state == 3
      o.delivery_state = "camp_in_route" if delivery_state == 4
      o.delivery_state = "camp_fail" if delivery_state == 5
      o.delivery_state = "camp_canceled" if delivery_state == 6
      o.delivery_state = "camp_finished" if delivery_state == 7
      o.delivery_state = "salesman_inprogress" if delivery_state == 8
      o.delivery_state = "salesman_fail" if delivery_state == 9
      o.delivery_state = "salesman_caceled" if delivery_state == 10
      o.delivery_state = "salesman_finished" if delivery_state == 11
      o.save
    end
    ActionCable.server.broadcast 'salesman_channel', data: "update"
    ActionCable.server.broadcast 'client_channel', data: "update"
    ActionCable.server.broadcast 'deliveryman_channel', data: "update"
    render json: "ok"
  end

  def update_deliveryman_state
    data = params["data"]
    data = convert_data(data)
    order_id = params["order"]
    order = Order.find(order_id)
    if data == 3 && order.delivery_state == 'accepted_to_camp'
      order.delivery_state = data
      order.save
      render json: "ok",status: :ok
    else
      render json: "erro",status: :empty
    end 
  end

  def destroy
    @order.destroy
  end

  
private

  def send_message_to_admins(data)
    admins = Organization.select(:token).where(organization_type:2).pluck(:token).compact  
    send_message({client:data[:client],organization:data[:organization],to:admins,type:'admin_new_order'}) if action_name == 'create'
  end

  def send_message_to_organization(data)
    token = Organization.find(data[:organization_id].to_i).token 
    send_message({client:data[:client],to:token,type:'new_order'}) if action_name == 'create'
  end

  def send_message(params)
    NotificationService.new(params).send_notification
  end
  

  def set_orders
    organization_id = order_params["organization_id"]
    organization = Organization.find(organization_id)
    if (organization.organization_type == 'salesman')
      reference = params[:reference]
      @orders = Order.where(reference:reference).joins(:product).where("products.organization_id = ?",organization_id)
    end
    if (organization.organization_type == 'deliveryman')
      reference = params[:reference]
      @orders = Order.where(reference:reference)
    end
  end

  def order_params
    params.require(:order).permit(:device_id,:reference,:product_id,:address,
                                  :payment,:total,:amount,:consumer_name,:salesman_state,
                                  :organization_id,:order_id,:delivery_state,:data)
  end

  def device_id
    params.permit(:device_id) 
  end 

  def organization_id
    params.permit(:organization_id) 
  end 
  
  def order_id
    params.permit(:order_id) 
  end 

  def convert_data(data)
    if data == 'CI'
      return 3
    end
  end

end
