# What is Fabric?
Fabric is a widgets framework written and configured in _python_. Fabric main goals is to provide you a simple, easy and high-level way to declare and manage desktop widgets, it follows the signal controlled flow to make events handling much easier than ever, Fabric was heavily inspired from multiple other projects on the community like [eww](https://github.com/elkowar/eww), [ags](https://github.com/Aylur/ags) and [Waybar](https://github.com/Alexays/Waybar) to provide you a better experience in a familiar way
# Why Fabric?
Fabric might be your choice if you already know how to program in python or if you don't know how to configure the other alternatives, Fabric is type hinted in a proper way and it integrates nicely with code editors to give you the best typed, auto-completed and docstringed experience you can get, also Fabric gives you the ability to use other python library's since Fabric is a python library at the end
# Fabric and GTK
Fabric uses [GTK](https://www.gtk.org/), which's a widget and application development toolkit, Fabric uses the python bindings of GTK under the name [PyGObject](https://wiki.gnome.org/action/show/Projects/PyGObject)
without GTK Fabric won't be a thing since it's one of the head dependencies of the project
# What is Cairo?
[Cairo](https://www.cairographics.org/) is a graphics and shape drawing library, GTK (version 3) uses Cairo to draw surfaces and widgets
GTK makes you able to draw custom surfaces and widgets using Cairo, see [Gtk.Bin](https://docs.gtk.org/gtk3/class.Bin) and [Gtk.DrawingArea](https://docs.gtk.org/gtk3/class.DrawingArea) for more info
also, Fabric uses Cairo to draw custom widgets that does not exist in GTK
