# app/serializers/note_serializer.rb
class NoteSerializer
  include JSONAPI::Serializer

  set_type :note
  set_key_transform :camel_lower

  attributes :ref, :title, :content, :created_at, :updated_at

  attribute :category do |note|
    note.note_type # enum key (e.g., "general", "meeting", ...)
  end
end
