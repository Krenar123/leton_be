module Api
  module V1
    module Projects
      class ProjectTasksController < ApplicationController
        include CreatedByAssignable
        before_action :set_objective

        def index
          render json: TaskSerializer.new(@objective.tasks.order(:start_date)), status: :ok
        end

        def create
          task = @objective.tasks.build(task_params)
          assign_created_by(task)

          if task.save
            render json: TaskSerializer.new(task), status: :created
          else
            render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          task = @objective.tasks.find_by!(ref: params[:task_ref])
          task.update!(task_params)
          render json: task, status: :ok
        end

        def destroy
          task = @objective.tasks.find_by!(ref: params[:task_ref])
          task.destroy!
          head :no_content
        end

        private

        def set_objective
          @objective = Objective.find_by!(ref: params[:ref])
        end

        def task_params
          params.require(:task).permit(:title, :description, :start_date, :due_date, participants: [])
        end
      end
    end
  end
end
