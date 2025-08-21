# app/controllers/api/v1/clients/client_notes_controller.rb
module Api
  module V1
    module Clients
      class ClientNotesController < ApplicationController
        include CreatedByAssignable

        before_action :load_client

        def index
          notes = @client.notes.order(created_at: :desc)
          render json: NoteSerializer.new(notes).serializable_hash
        end

        def create
          note = @client.notes.new(note_params)
          note.created_by = current_user
          
          if note.save
            render json: NoteSerializer.new(note).serializable_hash, status: :created
          else
            render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          note = @client.notes.find_by!(ref: params[:note_ref])
          if note.update(note_params)
            render json: NoteSerializer.new(note).serializable_hash
          else
            render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          note = @client.notes.find_by!(ref: params[:note_ref])
          note.destroy!
          head :no_content
        end

        private

        def load_client
          @client = Client.find_by!(ref: params[:client_ref])
        end

        # We accept `category` from FE, map it to enum note_type
        def note_params
          p = params.require(:note).permit(:title, :content, :category)
          if p[:category].present?
            key = p[:category].to_s.parameterize.underscore
            if Note.note_types.key?(key)
              p[:note_type] = key
            else
              p[:note_type] = "general"
            end
          end
          p.except(:category)
        end
      end
    end
  end
end
