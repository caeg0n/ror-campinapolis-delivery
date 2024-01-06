class OrganizationDevicesController < ApplicationController
  
  def find
    if find_organization_device_params["device_id"].present?
      device_id = find_organization_device_params["device_id"]
      device = OrganizationDevice.enabled.where(device_id:device_id)
      organization = Organization.find(device[0].organization_id) if device.count > 0
      filtered_organization = organization.attributes.slice("name","cover","logo") if device.count > 0
      return render json: {device:device[0].id, status:1, organization:filtered_organization}, status: :ok if device.count > 0 
      device = OrganizationDevice.disabled.where(device_id:device_id)
      return render json: {device:device[0].id, status:2}, status: :ok if device.count > 0 
      if not device.count > 0
        organization_device = OrganizationDevice.new
        organization_device.device_id = device_id
        organization_device.status = :disabled
        organization_device.save
        return render json: {device:organization_device.id, status:2}, status: :created
      end
    else
      return render json: "error", status: :unprocessable_entity #422
    end
  end


  # def create
    # render json: :ok, status: :ok
    # binding.pry
    # @organization_device = OrganizationDevices.new(create_organization_device_params)
    # if @organization_device.save
    #   # render json: @organization, status: :created, location: @organization
    # else
    #   # render json: @organization.errors, status: :unprocessable_entity
    # end
  # end

private

  def find_organization_device_params
    params.require(:organization_device).permit(:device_id)
  end

  def create_organization_device_params
    params.require(:organization_device).permit(:device_id, :organization_id, :organization_device_type)
  end
end
