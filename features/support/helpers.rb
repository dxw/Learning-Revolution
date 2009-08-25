def find_or_build(object, attrs = {})
  result = object.send(:find, :first, {:conditions => attrs})
  unless result.blank?
    result
  else
    object.send(:new, attrs)
  end  
end

def find_or_create(object, attrs={})
  result = object.send(:find, :first, {:conditions => attrs})
  unless result.blank?
    result
  else
    object.send(:create!, attrs)
  end
end