framework '/System/Library/Frameworks/CoreGraphics.framework'
require 'hotkeys'

class AppDelegate
    attr_accessor :window
    def initialize
      @tiled = []
    end

    def applicationDidFinishLaunching(a_notification)
      puts "Tiler running..."
      # Insert code here to initialize your application
      @hotkeys = HotKeys.new

      @hotkeys.addHotString("V+OPTION+COMMAND") do
        Tall.new.tile
      end
      @hotkeys.addHotString("V+OPTION") do
        Tall.new.tile
      end
      @hotkeys.addHotString("B+OPTION+COMMAND") do
        Full.new.tile
      end
      @hotkeys.addHotString("X+OPTION+COMMAND+SHIFT") do
        @saved = Saved.new
      end
      @hotkeys.addHotString("X+OPTION+COMMAND") do
        @saved.tile
      end
    end
  end


class Workspace
  def initialize
    CGWindowListCopyWindowInfo(KCGWindowListOptionOnScreenOnly | KCGWindowListExcludeDesktopElements, KCGNullWindowID)
  end
end

class Saved
  def initialize
    puts "Saved Window Positions"
    @applications = Application.all
    @menuBarHeight = NSMenu.menuBarHeight

    screenArray = NSScreen.screens()
    mainScreen = NSScreen.mainScreen()
    screenRect = mainScreen.visibleFrame()

    @screenWidth = screenRect.size.width
    @screenHeight = screenRect.size.height

    @focused = Application.active.focused_window
    windows = @applications.map(&:windows).flatten
    @saved_positions = Array.new
    windows.each do |w|
      @saved_positions << [w, w.position, w.size]
    end
  end

  def tile
    puts "Restored Window Positions"
    @saved_positions.each do |w,pos,size|
      w.position = pos.x, pos.y
      w.size = size.width, size.height
    end

  end

  def change_focus

  end
end

class Full
  def initialize
    @applications = Application.all
    @menuBarHeight = NSMenu.menuBarHeight

    screenArray = NSScreen.screens()
    mainScreen = NSScreen.mainScreen()
    screenRect = mainScreen.visibleFrame()

    @screenWidth = screenRect.size.width
    @screenHeight = screenRect.size.height

    @focused = Application.active.focused_window
  end

  def tile

    x = 0
    y = @menuBarHeight
    windows = @applications.map(&:windows).flatten


    windows = windows.reject(&:focused)
    windows = windows.reject{ |w |
      w.visible == false
    }

    numberWindows = windows.count

    @focused.position = x, y
    @focused.size = @screenWidth, @screenHeight


    windows.each do | w |
      w.visible = true
      puts w.title
    end
  end

  def change_focus

  end
end


class Tall
  def initialize
    @applications = Application.all
    @menuBarHeight = NSMenu.menuBarHeight

    screenArray = NSScreen.screens()
    mainScreen = NSScreen.mainScreen()
    screenRect = mainScreen.visibleFrame()

    @screenWidth = screenRect.size.width
    @screenHeight = screenRect.size.height

    @focused = Application.active.focused_window
  end

  def tile

    x = 0
    y = @menuBarHeight
    windows = @applications.map(&:windows).flatten


    windows = windows.reject(&:focused)
    windows = windows.reject{ |w |
      w.visible == false
    }

    numberWindows = windows.count

    @focused.position = x, y
    @focused.size = @screenWidth/2, @screenHeight


    he = @screenHeight/numberWindows

    x = @screenWidth/2
    for j in 0...numberWindows
      w2 = windows.pop()
      w2.size = @screenWidth/2, he
      puts w2.title
      w2.position = x, y

      y = y + he
    end

  end

  def change_focus

  end
end
