# app/serializers/meeting_serializer.rb
class MeetingSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attributes :ref, :title, :description, :meeting_date, :duration_minutes,
             :location, :meeting_type, :status

  attribute :participants do |obj|
    obj.meeting_participants.includes(:user, :client, :supplier).map do |mp|
      {
        userName: mp.user&.full_name,
        clientName: mp.client&.company,
        supplierName: mp.supplier&.company,
        response: mp.response
      }.compact
    end
  end
end
