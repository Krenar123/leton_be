module Api
  module V1
    module Projects
      class ProjectObjectivesController < ApplicationController
        before_action :set_project
        before_action :set_objective, only: [:update]

        def index
          objectives = @project.objectives
          render json: ObjectiveSerializer.new(objectives)
        end

        def create
          objective = @project.objectives.build(objective_params)
          objective.created_by = current_user

          if objective.save
            render json: ObjectiveSerializer.new(objective), status: :created
          else
            render json: { errors: objective.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @objective.update(objective_params)
            render json: ObjectiveSerializer.new(@objective), status: :ok
          else
            render json: { errors: @objective.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          objective = Objective.find_by!(ref: params[:ref])
          objective.destroy!
          render json: { success: true }, status: :ok
        end

        private

        def set_project
          @project = Project.find_by!(ref: params[:project_ref])
        end

        def set_objective
          @objective = @project.objectives.find_by!(ref: params[:ref])
        end

        def objective_params
          params.require(:objective).permit(
            :title,
            :description,
            :start_date,
            :end_date,
            :status,
            participants: []
          )
        end
      end
    end
  end
end
