class PersonSerializer < ActiveModel::Serializer
  attributes :id, :name, :cpf, :birth_date
end
