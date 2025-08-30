# app/serializers/team_cost_serializer.rb
class TeamCostSerializer
  include JSONAPI::Serializer

  set_type :team_cost

  attributes :ref, :work_date, :hours_worked, :hourly_rate, :total_cost, :description

  attribute :user do |tc|
    { ref: tc.user.ref, full_name: tc.user.full_name, wage_per_hour: tc.user.wage_per_hour }
  end
end
