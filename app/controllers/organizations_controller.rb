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
