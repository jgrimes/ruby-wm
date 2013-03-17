module AXElement
  def attributes
    array_pointer = Pointer.new("^{__CFArray}")
    AXUIElementCopyAttributeNames(@axui_element, array_pointer)
    array_pointer[0]
  end

  def get_attribute name
    pointer = Pointer.new(:id)
    err = AXUIElementCopyAttributeValue(@axui_element, name, pointer)
    if err == 0
      pointer[0]
    else
      nil
    end
  end
end
