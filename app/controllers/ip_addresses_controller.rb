class IpAddressesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @ip_addresses = Ip_address.all
    render json: @ip_addresses
  end

  def show
    @ip_address = Ip_address.find(params[:id])
    reender json: @ip_address
  end

  def new
  end

  def create
    @ip_address = Ip_address.new(ip_address_params)
    @ip_address.save
  end

  def update
    @ip_address = Ip_address.find(parame[:id])
    @ip_address.update(ip_address_params)
    @ip_address.save
  end

  private
  def ip_address_params
    return {ip_addr: params[:ip_addr], instance_id: params[:instance_id]}
  end
end
