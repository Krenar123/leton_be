class MeetingSerializer
  include JSONAPI::Serializer
  attributes :ref, :title, :description, :meeting_date, :duration_minutes,
             :location, :meeting_type, :status, :created_at, :updated_at

  belongs_to :project
  belongs_to :organizer, serializer: UserSerializer 
end
