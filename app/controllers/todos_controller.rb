class TodosController < ApplicationController
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      list_redirect(@todo.list_id)
    else
      list_redirect(@todo.list_id, @todo.errors.full_messages.join(', '))
    end
  end

  def update
    @todo = Todo.find_by(id: params[:id])

    if @todo.blank?
      redirect_to lists_path, alert: t('invalid_todo')
    elsif @todo.update(todo_params)
      list_redirect(@todo.list_id)
    else
      list_redirect(@todo.list_id, @todo.errors.full_messages.join(', '))
    end
  end

  def destroy
    Todo.where(list_id: params[:id], done: true).destroy_all
    redirect_to lists_path(list_id: params[:id])
  end

  private

  def todo_params
    params.require(:todo).permit(:description, :due, :done, :list_id)
  end

  def list_redirect(list_id, alert = nil)
    if alert
      redirect_to(lists_path(list_id:), alert:)
    else
      redirect_to lists_path(list_id:)
    end
  end
end
