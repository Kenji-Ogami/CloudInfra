class InstancesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @instances = Instance.all
    render json: @instances
  end

  def show
    @instance = Instance.find(params[:id])
    render json: @instance
  end

  def new
  end

  def create
    @instance = Instance.new(instance_params)
    @instance.save
    ret = @instance.send_instance
    key = File.read(ret[:priv_key])

    render json: {ip_addr: ret[:ip_addr], priv_key: key} 
  end

  def update
    @instance = Instance.find(parame[:id])
    @instance.update(instance_params)
    @instance.save
  end

  private
  def instance_params
    return {name: params[:name], machine_id: params[:machine_id], cpu: params[:cpu], memory: params[:memory], disk_space: params[:disk_space]}
  end
end
