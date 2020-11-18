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
    # sql
    tasks_more_10_completed = Project.find_by_sql("SELECT projects.name , projects.id
                                                              FROM tasks RIGHT JOIN projects
                                                              ON tasks.project_id = projects.id
                                                              WHERE tasks.status = 'completed'
                                                              GROUP BY projects.id HAVING COUNT(tasks) >10
                                                              ORDER BY projects.id")

    tasks_with_duplicate_names = Project.find_by_sql("SELECT id, name
                                                      FROM tasks
                                                      WHERE name IN
                                                      (SELECT name FROM tasks GROUP BY name HAVING COUNT(*) >1)
                                                      ORDER BY name")

    projects_by_name_a = Project.find_by_sql("SELECT projects.name, COUNT(tasks) AS task_count
                                              FROM tasks RIGHT JOIN projects
                                              ON tasks.project_id = projects.id
                                              WHERE projects.name LIKE '%a%'
                                              GROUP BY projects.id")

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
    #
    tasks = Project.find_by_sql('select * from projects right outer join tasks on projects.id=tasks.id')
    projects = Project.find_by_sql('SELECT * FROM projects ORDER BY id DESC')
    render json: {projects: projects,
                  tasks: tasks,
                  sql_tasks_count: projects_by_tasks_count,
                  sql_by_project_name: projects_tasks_by_project_name,
                  sql_n_letter: n_letter,
                  sql_a_letter: projects_by_name_a,
                  sql_tasks_with_duplicate_names: tasks_with_duplicate_names,
                  sql_tasks_more_10_completed: tasks_more_10_completed}
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
