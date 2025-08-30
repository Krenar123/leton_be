# app/controllers/api/v1/users/users_controller.rb
module Api
  module V1
    module Users
      class UsersController < ApplicationController
        before_action :require_org!

        # POST /api/v1/users/users
        def create
          attrs = user_params.to_h
          attrs[:email] = attrs[:email].to_s.strip.downcase
          ensure_password!(attrs)

          user = @organization.users.new(attrs)

          if user.save
            render json: UserSerializer.new(user).serializable_hash, status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def index
          users = @organization.users
          render json: UserSerializer.new(users).serializable_hash
        end

        def show
          user = @organization.users.find_by!(ref: params[:ref])
          render json: UserSerializer.new(user).serializable_hash
        end

        def update
          user  = @organization.users.find_by!(ref: params[:ref])
          attrs = user_params.to_h
          attrs[:email] = attrs[:email].to_s.strip.downcase if attrs.key?(:email)

          if user.update(attrs)
            render json: UserSerializer.new(user).serializable_hash
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def user_params
          params.require(:user).permit(
            :full_name, :email, :avatar_url,
            :position, :department, :phone, :address, :wage_per_hour,
            :password, :password_confirmation, :role
          )
        end

        def ensure_password!(attrs)
          return if attrs[:password].present?
          temp = SecureRandom.base58(16) + "aA1!"
          attrs[:password] = temp
          attrs[:password_confirmation] = temp
        end

        def require_org!
          # assumes you already have authentication and current_user
          if !current_user || !current_user.organization
            render json: { errors: ["No organization found for current user"] }, status: :forbidden
          else
            @organization = current_user.organization
          end
        end
      end
    end
  end
end
