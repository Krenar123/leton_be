# app/controllers/api/v1/projects/team_costs_controller.rb
module Api
  module V1
    module Projects
      class ProjectTeamCostsController < ApplicationController
        before_action :set_project

        # GET index with optional date filtering
        def index
          from = params[:from].presence
          to   = params[:to].presence

          rows = @project.team_costs.includes(:user)
                        .between(from, to)
                        .order(work_date: :desc, id: :desc)

          render json: TeamCostSerializer.new(rows).serializable_hash
        end

        def create
          payload = params.require(:team_costs).permit(:work_date, :description, entries: [:user_ref, :hours_worked, :hourly_rate, :description])
          date    = payload[:work_date].presence || Date.current
          common  = payload[:description].to_s.presence
          entries = Array(payload[:entries])

          if entries.blank?
            return render json: { errors: ["entries can't be blank"] }, status: :unprocessable_entity
          end

          created = []
          ActiveRecord::Base.transaction do
            entries.each do |e|
              user = current_user.organization.users.find_by!(ref: e[:user_ref])
              tc = @project.team_costs.new(
                ref: SecureRandom.hex(16),
                user: user,
                work_date: date,
                hours_worked: e[:hours_worked],
                hourly_rate: e[:hourly_rate],        # falls back to user.wage_per_hour if nil
                description: (e[:description].presence || common),
                created_by: current_user
              )
              tc.save!
              created << tc
            end
          end

          render json: TeamCostSerializer.new(created).serializable_hash, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
        rescue ActiveRecord::RecordNotFound
          render json: { errors: ["user not found"] }, status: :not_found
        end

        def destroy
          tc = @project.team_costs.find_by!(ref: params[:id])
          tc.destroy
          head :no_content
        end

        private

        def set_project
          @project = Project.find_by!(ref: params[:project_ref])
        end
      end
    end
  end
end
