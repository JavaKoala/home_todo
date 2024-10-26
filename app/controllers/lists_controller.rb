class ListsController < ApplicationController
  before_action :set_lists, only: %i[index]

  def index; end

  def create
    @list = List.new(list_params)

    if @list.save
      redirect_to lists_path
    else
      set_lists
      render :index
    end
  end

  def destroy
    List.find_by(id: params[:id])&.destroy
    redirect_to lists_path
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def set_lists
    @lists = List.all
    @list = List.find_by(id: params[:list_id])
    @new_list = List.new
    @todos = @list.present? ? Todo.list_order(@list) : []
    @new_todo = Todo.new
  end
end
