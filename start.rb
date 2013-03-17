framework 'Cocoa'
framework 'ApplicationServices'
require 'rubygems'
require 'hotkeys'

module Start
  LIB_DIR = File.expand_path(File.dirname(__FILE__))
  RESOURCE_DIR = "#{LIB_DIR}/../resources"
#  require "#{LIB_DIR}/AppDelegate"
  require "#{LIB_DIR}/layout"
  require "#{LIB_DIR}/main"



  class Runner
    def setup_menu
      menu = NSMenu.new
      menu.initWithTitle 'Tiler'

      mi = NSMenuItem.new
      mi.title = 'Quit'
      mi.action = 'quit:'
      mi.target = self
      menu.addItem mi
      menu
    end

    def init_status_bar(menu)
      status_bar = NSStatusBar.systemStatusBar
      status_item = status_bar.statusItemWithLength(NSVariableStatusItemLength)
      status_item.setMenu menu
      status_item.setHighlightMode true
    end

    def quit(sender)
      app = NSApplication.sharedApplication
      app.terminate(self)
    end

    def start
      app = NSApplication.sharedApplication
      # Create the status bar item, add the menu and set the image

      init_status_bar setup_menu
      app.setDelegate(AppDelegate.new)
      app.run
    end
  end
end

Start::Runner.new.start
