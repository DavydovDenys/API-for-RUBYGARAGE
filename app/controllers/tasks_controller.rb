class TasksController < ApplicationController
  def create
    project = Project.find(params[:project_id])
    task = project.tasks.create!(
      name: params['name'],
      status: params['status'])

    if task
      render json: {status: 'created', task: task}
    else
      render json: {status: '500'}
    end
  end

  def update
    project = Project.find(params[:project_id])
    task = project.tasks.find(params[:id])
    task.update!(name: params['name'], status: params['status'])
    render json: {status: "updated", task: task}
  end

  def destroy
    project = Project.find(params[:project_id])
    task = project.tasks.find(params[:id])
    task.destroy
    render json: {status: "deleted"}
  end

  def index
    project = Project.find(params[:project_id])
    task = project.tasks.find_by_sql("SELECT * FROM tasks WHERE project_id = #{project.id}")
    tasks = Task.find_by_sql("SELECT * FROM tasks ORDER BY id DESC")
    render json: {message: "ok", task: task}
  end

  def show
    project = Project.find(params[:project_id])
    task = project.tasks.find(params[:id])
    render json: {status: 'successfully!', task: task}
  end

end
