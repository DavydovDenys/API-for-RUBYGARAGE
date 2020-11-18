class ProjectController < ApplicationController
  def create
    project = Project.create!(name:params['name'])
    if project
      session[:project] = project.id
      render json: {status: 'created', project: project}
    else
      render json: {status: 401}
    end
  end

  # def edit
  #   project = Project.find(params[:id])
  #   render json: {status: 'ready to edit!', project: project}
  # end

  def update
    project = Project.find(params[:id])

    if project.update(name: params['name'])
      render json: {status: 'updated successfully!', project: project}
    end
  end

  def index
    n_letter = Project.find_by_sql("SELECT projects.name, tasks.name
                                    FROM tasks INNER JOIN projects
                                    ON tasks.project_id=projects.id
                                    WHERE tasks.name LIKE 'N%'")
    projects_tasks_by_project_name = Project.find_by_sql("SELECT projects.name,COUNT(tasks.*)
                                                          AS task_count FROM tasks RIGHT JOIN projects
                                                          ON tasks.project_id=projects.id
                                                          GROUP BY projects.id
                                                          ORDER BY task_count")
    projects_by_tasks_count = Project.left_joins(:tasks).group(:id).order('COUNT(tasks.id) DESC')
    tasks = Project.find_by_sql('select * from projects right outer join tasks on projects.id=tasks.id')
    projects = Project.find_by_sql('SELECT * FROM projects ORDER BY id DESC')
    render json: {projects: projects,
                  tasks: tasks,
                  sql_tasks_count: projects_by_tasks_count,
                  sql_by_project_name: projects_tasks_by_project_name,
                  n_letter: n_letter}
  end

  def show
    project = Project.find(params[:id])
    if project
      render json: {project: project}
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    render json: {message: "deleted", project: project.id}
  end

end
