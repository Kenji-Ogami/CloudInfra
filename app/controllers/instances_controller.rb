class InstancesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @instances = Instance.all
    render json: @instances
  end

  def show
    @instance = Instance.find(params[:id])
    reender json: @instance
  end

  def new
  end

  def create
    @instance = Instance.new(instance_params)
    @instance.save
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
