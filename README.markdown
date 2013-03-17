ruby-wm
========

A very simple implementation of a tiling window manager for OS X, in MacRuby
---------

This is something I hacked together fairly quickly, and it can be greatly improved. I primarily use this on a 27" screen, and usually only have 2-3 windows open at a time. It works reasonably well for this setup, but there are several problems that can occur due to the APIs used (Accessibility APIs).

* Some windows have a lower bound on how small they can get. This messes up the current tiling procedures.
* Occasionally windows will fail to resize completely. This can usually be fixed by telling it to tile again.
* The windows will flash with focus as they are resized. This is a limitation in the API.

You can run it from the command line with `macruby start.rb`. Note: You will need to have MacRuby and the "hotkeys" MacRuby gem installed.
* Command + Option + V tiles with the "Tall" layout, which puts focused window on the left and the rest on the right.
* Command + Option + B tiles with the "Full" layout, which minimizes all of the windows except the focused one, and maximizes the focused one.

Future work
---------

Where to begin? I started investigating a way to reverse engineer the code that makes Mission Control work. It may be possible to use those hidden APIs to make something as functional as tiling WMs for X11. The code can be cleaned up substantially. It might also be possible to spark window resizes on their own threads to help speed up the tiling process, but I haven't tried this. There also need to be more layouts, and there is currently a bug with restoring windows that have been minimized.