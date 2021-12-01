class InstancesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @instances = Instance.all
    @ip_addresses = IpAddress.all
    #render json: @instances
  end

  def show
    @instance = Instance.find(params[:id])
    render json: {id: @instance[:id], name: @instance[:name], machine_id: @instance[:machine_id], ip_addr: @instance[:ip_addr],
                  status: @instance[:status], key: @instance[:key]}
  end

  def new
  end

  def create

    @instance = Instance.new(instance_params)
    @instance.save
    threads = []
    #ret = @instance.send_instance
    th = Thread.new do |thr| 
      ret =@instance.send_instance
      #key = File.read(ret[:priv_key])
    end
    #render json: {name: ret[:name], machine_id: ret[:machine_id], ip_addr: ret[:ip_addr], priv_key: key}
    render json: {status: 'Success'}
  end

  def update
    @instance = Instance.find(params[:id])
    @instance.update(instance_params)
    @instance.save
  end

  def destroy
    @instance = Instance.find(params[:id])
    ret = @instance.release
    @instance.destroy
  end

  private
  def instance_params
    return {name: params[:name], machine_id: params[:machine_id], cpu: params[:cpu], memory: params[:memory], disk_space: params[:disk_space], status: 'preparing'}
  end
end
