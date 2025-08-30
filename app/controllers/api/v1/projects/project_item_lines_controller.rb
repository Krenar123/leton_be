# app/controllers/api/v1/projects/project_item_lines_controller.rb
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
          attrs = normalize_supplier!(item_line_params.to_h.symbolize_keys, current_user)
          attrs[:level] = determine_level(params.dig(:project_item_line, :item_line, :actionType))
          @item_line = @project.item_lines.build(attrs)
          @item_line.created_by = current_user
          @item_line.parent_cost_code = determine_parent_cost_code(params[:project_item_line])

          if @item_line.save
            render json: ItemLineSerializer.new(@item_line).serializable_hash, status: :created
          else
            render json: { errors: @item_line.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          attrs = normalize_supplier!(item_line_params.to_h.symbolize_keys, current_user)
          if @item_line.update(attrs)
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
          when "add-main-category" then 1
          when "add-category"      then 2
          when "add-item-line", "add-vendor" then 3
          else nil
          end
        end

        def set_project
          @project = Project.find_by!(ref: params[:project_ref])
        end

        def set_item_line
          @item_line = @project.item_lines.find_by!(ref: params[:ref])
        end

        def item_line_params
          # NOTE: allow multiple ways to identify/select a supplier
          params.require(:project_item_line).require(:item_line).permit(
            :item_line,
            :contractor,        # free text fallback
            :vendor,            # free text alias from FE
            :supplier_id,       # numeric id from FE
            :supplier_ref,      # ref from FE (preferred)
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
            :parent_id,
            :depends_on_id,
            :level
          )
        end

        # --- supplier normalization ---
        def normalize_supplier!(attrs, user)
          # Prefer explicit ref/id if provided
          if attrs[:supplier_ref].present?
            if (sup = Supplier.find_by(ref: attrs.delete(:supplier_ref)))
              attrs[:supplier_id] = sup.id
              attrs[:contractor] ||= sup.company
              return attrs
            end
          end

          if attrs[:supplier_id].present?
            if (sup = Supplier.find_by(id: attrs[:supplier_id]))
              attrs[:contractor] ||= sup.company
              return attrs
            end
          end

          # Fallback: free-text vendor/contractor → find_or_create Supplier
          raw_name = attrs.delete(:vendor).presence || attrs[:contractor].presence
          if raw_name.present?
            sup = Supplier.find_by(company: raw_name)
            unless sup
              sup = Supplier.create!(
                company: raw_name,
                contact_name: raw_name,   # minimal placeholder
                created_by: user
              )
            end
            attrs[:supplier_id] = sup.id
            attrs[:contractor] = sup.company
          end

          attrs
        end
      end
    end
  end
end
