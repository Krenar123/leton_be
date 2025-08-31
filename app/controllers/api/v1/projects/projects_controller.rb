module Api
  module V1
    module Projects
      class ProjectsController < ApplicationController
        include CreatedByAssignable

        def index
          projects = Project.order(created_at: :desc).includes(:client, invoices: :payments, bills: :payments)
          render json: ProjectSerializer.new(projects)
        end

        def show
          project = Project.find_by!(ref: params[:ref])
          render json: ProjectSerializer.new(project)
        end

        def create
          project = Project.new(project_params)
          project.project_manager ||= current_user
          assign_created_by(project)# or replace with actual user id if not using auth yet
          
          if project.save
            render json: ProjectSerializer.new(project), status: :created
          else
            puts "🚨 Project validation errors: #{project.errors.full_messages}" 
            render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          project = Project.find_by!(ref: params[:ref])
          if project.update(project_params)
            render json: ProjectSerializer.new(project), status: :ok
          else
            render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def project_params
          params.require(:project).permit(
            :name, :description, :client_id, :status,
            :start_date, :end_date, :budget, :project_manager_id, :location
          )
        end
      end
    end
  end
end
