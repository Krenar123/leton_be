class SupplierSerializer
  include JSONAPI::Serializer
  attributes :id, :ref, :company, :contact_name, :email, :phone, :address,
             :website, :category, :status, :created_at, :updated_at 
end
