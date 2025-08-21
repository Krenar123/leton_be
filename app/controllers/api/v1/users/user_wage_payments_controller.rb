# app/controllers/api/v1/users/user_wage_payments_controller.rb
module Api
  module V1
    module Users
      class UserWagePaymentsController < ApplicationController
        def index
          user = User.find_by!(ref: params[:user_ref])
          team_costs = TeamCost.where(user_id: user.id).order(work_date: :desc)
          render json: TeamCostSerializer.new(team_costs).serializable_hash
        end
      end
    end
  end
end
