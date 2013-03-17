class Application
  include AXElement
  def self.active
    info = NSWorkspace.sharedWorkspace.activeApplication
    pid = info["NSApplicationProcessIdentifier"]
    new pid
  end

  def self.all
    NSWorkspace.sharedWorkspace.runningApplications.map{|app|
      new app.processIdentifier
    }
  end

  def initialize pid
    @pid = pid
    @app = AXUIElementCreateApplication pid
    @axui_element = @app
  end

  def focused_window
    window = self.get_attribute "AXFocusedWindow"
    Window.new window
  end

  def windows
    windows = self.get_attribute "AXWindows"
    (windows || []).map{|w| Window.new w} || []
  end

  def title
    self.get_attribute "AXTitle"
  end

  def hidden
    self.get_attribute "AXHidden"
  end
end
