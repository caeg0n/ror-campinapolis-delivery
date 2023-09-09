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

  def open
    id = params[:id]
    organization = Organization.find(id)
    if (!organization.nil?)
      organization.open = true
      organization.save
    end
    render json: "ok"
  end

  def close
    id = params[:id]
    organization = Organization.find(id)
    if (!organization.nil?)
      organization.open = false
      organization.save
    end
    render json: "ok"
  end

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
    id = params.permit(['id'])["id"].to_i
    categories = Category.where(id: Product.where(organization_id: id))
    result = categories.map do |category|
      {
        title: category.name,
        data: Product.where(organization_id: id).map do |product|
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
