class ClientSerializer
  include JSONAPI::Serializer
  attributes :ref, :company, :contact_name, :email, :phone, :address,
             :website, :industry, :status, :created_at, :updated_at 
end
