class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :update, :destroy]
  
  def login
    gatilho = false
    token = nil
    organization = {}
    #rsa_private = OpenSSL::PKey::RSA.generate 2048
    #rsa_public = rsa_private.public_key
    data = login_data['login']
    Organization.all.each do |org|
      username = org.username
      password = org.password
      organization = org
      result = Digest::MD5.hexdigest(username.upcase+password)
      if (result == data)
        gatilho = true
        #token = JWT.encode result, rsa_private, 'RS256'
        break
      end
    end
    if (gatilho)
      render json: {"token":token,"organization":organization}
    else
      render json: {error: "erro",status: 400}, status: 400
    end 
  end

  def index
    #@organizations = Organization.all
    @organizations = Organization.all
    render json: @organizations
  end

  def update_state
    binding.pry
  end

  def update_organization_delivery_type
    params = delivery_type_params
    uuid = params["uuid"]
    delivery_type = params["delivery_type"]
    state = params["state"]
    organization_device = OrganizationDevice.where(device_id:uuid)
    organization = Organization.find(organization_device.first.organization_id) if organization_device.count > 0
    organization.delivery_type = :my_org if delivery_type == "my_org" and state == true and organization_device.count > 0
    organization.delivery_type = :camp_entregas if delivery_type == "camp_entregas" and state == true if organization_device.count > 0
    organization.save if organization_device.count > 0
  end

  # def open
  #   id = params[:id]
  #   organization = Organization.find(id)
  #   if (!organization.nil?)
  #     organization.open = true
  #     organization.save
  #   end
  #   render json: "ok"
  # end

  # def close
  #   id = params[:id]
  #   organization = Organization.find(id)
  #   if (!organization.nil?)
  #     organization.open = false
  #     organization.save
  #   end
  #   render json: "ok"
  # end

  def info
    id = params[:id]
    organization = Organization.find(id)
    if (!organization.nil?)
      render json: organization.to_json
    end
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      render json: @organization, status: :created, location: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  def get_all_with_distinct_category
    render json: Organization.all.uniq.group_by(&:category_base)
  end

  def opened_organizations
    render json: Organization.where(open: true)
  end

  def closed_organizations
    tempObj = {}
    result = []
    organizations = Organization.where(open: false)
    organizations.each do |organization|
      tempObj = { "distance": "",
                  "id": organization.id,
                  "image": organization.logo,
                  "rating": 5,
                  "subTitle": organization.category_base,
                  "time": "",
                  "title": organization.name,
                }
      result.push(tempObj)
    end
    render json: result 
  end

  def opened_organizations
    tempObj = {}
    result = []
    organizations = Organization.where(open: true)
    organizations.each do |organization|
      tempObj = { "distance": "",
                  "id": organization.id,
                  "image": organization.logo,
                  "rating": 5,
                  "subTitle": organization.category_base,
                  "time": "",
                  "title": organization.name,
                }
      result.push(tempObj)
    end
    render json: result 
  end

  def most_popular
    tempObj = {}
    result = []
    organizations = Organization.where(open: true)
    organizations.each do |organization|
      tempObj = {
        image: organization.cover, 
        id: organization.id,
        title: organization.name,
        subTitle: organization.category_base,
        distance: "",
        time: "",
        rating: 5,
      }
      result.push(tempObj)
    end
    render json: result
  end

  def recommended_places
    tempObj = {}
    result = []
    organizations = Organization.where(open: true)
    organizations.each do |organization|
      tempObj = { "distance": "",
                  "id": organization.id,
                  "image": organization.cover,
                  "rating": 5,
                  "subTitle": organization.category_base,
                  "time": "",
                  "title": organization.name,
                }
      result.push(tempObj)
    end
    render json: result
  end

  def hot_deals
    tempObj = {}
    result = []
    organizations = Organization.where(open: true)
    organizations.each do |organization|
      tempObj = { "distance": "",
                  "id": organization.id,
                  "image": organization.logo,
                  "rating": 5,
                  "subTitle": organization.category_base,
                  "time": "",
                  "title": organization.name,
                }
      result.push(tempObj)
    end
    render json: result
  end

  def get_categories_and_products
    categories = Category.all
    grouped_categories = categories.group_by { |category| category.organization_id }
    result = grouped_categories.map do |organization_id, categories|
      {
        organization_id: organization_id,
        categories: categories.map do |category|
          {
            title: category.name,
            products: Product.where(category_id:category.id).map do |product|
              {
                id: product.id,
                title: product.name,
                description: product.description,
                price: product.price,
                image: product.img,
                organization_id: product.organization_id
              }
            end
          }
        end
      }  
    end
    render json: result
  end

  # def update
  #   if @organization.update(organization_params)
  #     render json: @organization
  #   else
  #     render json: @organization.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @organization.destroy
  # end

  private
    
    def delivery_type_params
      params.require(:organization).permit(:uuid, :delivery_type, :state)
    end

    def status_params
      params.require(:organization).permit(:organization, :state)
    end

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:name, :cel, :logo)
    end

    def login_data
      params.permit(:login) 
    end 
end
