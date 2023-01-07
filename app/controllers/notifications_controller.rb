class NotificationsController < ApplicationController
  before_action :send_message_to_admins, only: [ :update_token,:register ]
  
  def register
    @notification = Notification.new(notification_params)
    notification = Notification.where(device:@notification.device)
    begin
      notification.token = @notification.token if notification.count > 0 
      notification.save if notification.count > 0
      return if notification.count > 0
    rescue
      return 
    end
    if @notification.save
      render json: @notification, status: :created, location: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def update_token
    token = notification_params["token"]
    organization = notification_params["organization"]
    if (organization.to_i>0)
      aux = Organization.find(organization)
      aux.token = token
      aux.save
    end
    render json: :ok
  end

  
  private

    def send_message_to_admins
      organization_id = notification_params["organization"].to_i if action_name == 'update_token'
      organization_name = Organization.find(organization_id).name if action_name == 'update_token'
      
      admins = Organization.select(:token).where(organization_type:2).pluck(:token).compact
      
      send_message({organization:organization_name,to:admins,type:'organization_updated_token'}) if action_name == 'update_token'
      send_message({to:admins,type:'app_activity'}) if action_name == 'register'
    end

    def send_message(params)
      NotificationService.new(params).send_notification
    end

    def notification_params
      params.require(:notification).permit(:device,:token,:organization)
    end
end
