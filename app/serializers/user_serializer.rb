class UserSerializer
  include JSONAPI::Serializer
  attributes :ref, :full_name, :email, :role 
end
