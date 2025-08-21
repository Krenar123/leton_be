# app/serializers/user_serializer.rb
class UserSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  set_id :ref  # make JSON:API id = ref

  attributes :ref, :email, :full_name, :avatar_url,
             :position, :department, :phone, :address, :wage_per_hour

  attribute :stats do |user|
    obj_completed =
      if defined?(Objective) && Objective.respond_to?(:statuses) && Objective.statuses.is_a?(Hash)
        Objective.statuses[:completed]
      end
    obj_completed ||= 2  # fallback

    task_completed =
      if defined?(Task) && Task.respond_to?(:statuses) && Task.statuses.is_a?(Hash)
        Task.statuses[:completed]
      end
    task_completed ||= 2 # fallback

    {
      objectivesTotal:     Objective.where(assigned_to_id: user.id).count,
      objectivesCompleted: Objective.where(assigned_to_id: user.id, status: obj_completed).count,
      tasksTotal:          Task.where(assigned_to_id: user.id).count,
      tasksCompleted:      Task.where(assigned_to_id: user.id, status: task_completed).count
    }
  end

  attribute :nextMeeting do |user|
    m = Meeting.left_joins(:meeting_participants)
               .where("meetings.organizer_id = :uid OR meeting_participants.user_id = :uid", uid: user.id)
               .where("meeting_date >= ?", Time.current)
               .order(meeting_date: :asc)
               .first
    if m
      { date: m.meeting_date&.iso8601, title: m.title }
    end
  end
end
