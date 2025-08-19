class ProjectSerializer
  include JSONAPI::Serializer
  attributes :ref, :name, :description, :status,
             :start_date, :end_date, :budget,
             :created_at, :updated_at, :location

  attribute :client do |project|
    project.client&.company
  end

  attribute :value do |project|
    project.budget.to_f
  end

  attribute :profitability do |_project|
    rand(10.0..30.0).round(2) # simulate until actual logic exists
  end
end
