class IpAddressesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @ip_addresses = IpAddress.all
    render json: @ip_addresses
  end

  def show
    @ip_address = IpAddress.find(params[:id])
    reender json: @ip_address
  end

  def new
    
  end

  def create
    @ip_address = IpAddress.new(ip_address_params)
    debugger
    @ip_address.save
  end

  def update
    @ip_address = IpAddress.find(parame[:id])
    @ip_address.update(ip_address_params)
    @ip_address.save
  end

  private
  def ip_address_params
    return {instance_id: params[:instance_id], ip_addr: params[:ip_addr]}
  end
end
