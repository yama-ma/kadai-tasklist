class TasksController < ApplicationController

  
  def index
      if logged_in? 
        @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      else
        redirect_to login_path
      end
  end

  def show
      @task = Task.find(params[:id])
  end

  def new
      @task = current_user.tasks.build
  end

  def create
      @task = current_user.tasks.build(message_params)

      if @task.save
        flash[:success] = 'Message が正常に投稿されました'
        redirect_to @task
      else
        flash.now[:danger] = 'Message が投稿されませんでした'
        render :new
      end
  end

  def edit
      @task = Task.find(params[:id])
  end

  def update
      @task = Task.find(params[:id])

      if @task.update(message_params)
        flash[:success] = 'Message は正常に更新されました'
        redirect_to @task
      else
        flash.now[:danger] = 'Message は更新されませんでした'
        render :edit
      end
  end

  def destroy
      @task = Task.find(params[:id])
      @task.destroy
      
      flash[:success] = 'Message は正常に削除されました'
      redirect_to tasks_url
  end

private

# Strong Parameter
def message_params
  params.require(:task).permit(:content,:status)
end

 def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
 end
end