def array_to_active_record_relation(array, model)
  model.where(id: array.map(&:id))
end
