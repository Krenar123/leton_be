class ObjectiveSerializer
  include JSONAPI::Serializer
  attributes :id, :ref, :title, :description, :status, :priority,
             :start_date, :end_date, :assigned_to, :depends_on,
             :created_by, :project_id, :created_at, :updated_at, :participants
end
