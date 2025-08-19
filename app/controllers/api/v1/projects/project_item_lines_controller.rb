module Api
  module V1
    module Projects
      class ProjectItemLinesController < ApplicationController
        before_action :set_project
        before_action :set_item_line, only: [:update, :destroy, :complete]

        def index
          @item_lines = @project.item_lines.order(:created_at)
          render json: ItemLineSerializer.new(@item_lines).serializable_hash
        end

        def create
          sanitized_params = item_line_params
          sanitized_params[:level] = determine_level(params[:project_item_line][:item_line][:actionType])
          @item_line = @project.item_lines.build(sanitized_params)
          @item_line.created_by = current_user
          @item_line.parent_cost_code = determine_parent_cost_code(params[:project_item_line])

          if @item_line.save
            render json: ItemLineSerializer.new(@item_line).serializable_hash, status: :created
          else
            render json: { errors: @item_line.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @item_line.update(item_line_params)
            render json: ItemLineSerializer.new(@item_line).serializable_hash
          else
            render json: { errors: @item_line.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @item_line.destroy
          head :no_content
        end

        def complete
          if @item_line.update(status: "completed")
            render json: ItemLineSerializer.new(@item_line).serializable_hash
          else
            render json: { errors: @item_line.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def determine_parent_cost_code(params)
          case determine_level(params[:actionType])
          when 2 then params[:level1]
          when 3 then params[:level2]
          else nil
          end
        end

        def determine_level(action_type)
          case action_type
          when "add-main-category"
            1
          when "add-category"
            2
          when "add-item-line", "add-vendor"
            3
          else
            nil
          end
        end

        def set_project
          @project = Project.find_by!(ref: params[:project_ref])
        end

        def set_item_line
          @item_line = @project.item_lines.find_by!(ref: params[:ref])
        end

        def item_line_params
          params.require(:project_item_line).require(:item_line).permit(
            :item_line,
            :contractor,
            :cost_code,
            :parent_cost_code,
            :estimated_cost,
            :actual_cost,
            :estimated_revenue,
            :actual_revenue,
            :start_date,
            :due_date,
            :status,
            :unit,
            :quantity,
            :unit_price,
            :vendor,
            :parent_id,
            :depends_on_id,
            :level
          )
        end        
      end
    end
  end
end
