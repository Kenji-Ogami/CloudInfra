class MachinesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @machines = Machine.all
    render json: @machines
  end

  def show
    @machine = Machine.find(params[:id])
    reender json: @machine
  end

  def new
  end

  def create
    @machine = Machine.new(machine_params)
    @machine.save
  end

  def update
    @machine = Machine.find(parame[:id])
    @machine.update(machine_params)
    @machine.save
  end

  private
  def machine_params
    return {name: params[:name], model: params[:model], cpu: params[:cpu], memory: params[:memory], disk_space: params[:disk_space], ip_addr: params[:ip_addr]}
  end
end
