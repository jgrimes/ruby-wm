
class Window
  attr_accessor :window
  include AXElement
  def self.active
    Application.active.focused_window
  end

  def self.all
    Application.all.map(&:windows).flatten
  end

  def focused
    if Window.active == self
      return true
    end
    return false
  end

  def initialize window
    @window = window
    @axui_element = window
  end

  def ==(other)
    if other.respond_to?( :position ) and other.respond_to? (:size) and other.respond_to? (:title)
      return (self.position == other.position) && (self.size == other.size) && (self.title == other.title)
    end
    return false
  end

  def position
    ax_position = self.get_attribute "AXPosition"
    pos_pt = Pointer.new("{CGPoint=dd}")
    err = AXValueGetValue(ax_position, KAXValueCGPointType, pos_pt)
    pos_pt[0]
  end

  def position= a
    x, y = a
    position = Pointer.new("{CGPoint=dd}")
    position.assign(NSPoint.new(x, y))
    position_ref = AXValueCreate(KAXValueCGPointType, position)
    AXUIElementSetAttributeValue(@window,
                                 NSAccessibilityPositionAttribute,
                                 position_ref)
  end

  def size
    size_ref = Pointer.new(:id)
    err = AXUIElementCopyAttributeValue(@window,
                                        NSAccessibilitySizeAttribute,
                                        size_ref)
    size_pt = Pointer.new("{CGSize=dd}")
    err = AXValueGetValue(size_ref[0], KAXValueCGSizeType, size_pt)
    size_pt[0]
  end

  def size= a
    w, h =a
    size = Pointer.new("{CGSize=dd}")
    size.assign(NSSize.new(w,h))
    size_ref = AXValueCreate(KAXValueCGSizeType, size)
    AXUIElementSetAttributeValue(@window,
                                 NSAccessibilitySizeAttribute,
                                 size_ref)
  end

  def self.on_screen
    blah = CGWindowListCopyWindowInfo(KCGWindowListOptionOnScreenOnly | KCGWindowListExcludeDesktopElements, KCGNullWindowID)
    newblah = blah.reject { | b |
      b["kCGWindowOwnerName"] == "SystemUIServer"
    }

    newblah.map { | m |
      m["kCGWindowName"]
    }
  end

  def minimized
    return self.get_attribute "AXMinimized"
  end

  def visible
    if self.title == ""
      false
    else
      Window.on_screen.include? self.title
    end
  end

  def visible= bool
    puts bool
    size = Pointer.new(:id)
    size[0] = not(bool)
    puts size[0]

    AXUIElementSetAttributeValue(@window,
                                 NSAccessibilityMinimizedAttribute,
                                 bool)

  end

  def title
    self.get_attribute "AXTitle"
  end
end
