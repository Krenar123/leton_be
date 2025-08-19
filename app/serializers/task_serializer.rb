class TaskSerializer
  include JSONAPI::Serializer
  attributes :id, :ref, :title, :description, :status,
             :start_date, :due_date, :created_by,
             :created_at, :updated_at, :participants 

  attribute :objective_id do |task|
    task.objective&.ref
  end
end
