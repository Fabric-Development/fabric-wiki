# What is Fabric?
Fabric is a widgets framework written and configured in [Python](https://www.python.org). Fabric's main goals are to provide you a simple, easy and high-level way to declare and manage desktop widgets. It follows signal control flow to make events handling much easier than ever. Fabric was heavily inspired from multiple other projects on the community like [eww](https://github.com/elkowar/eww), [ags](https://github.com/Aylur/ags), and [Waybar](https://github.com/Alexays/Waybar) to provide you a better experience in a familiar way.

# Why Fabric?
Fabric might be your framework of choice if you already know how to program in Python or if you don't know how to configure the other alternatives. Fabric is type hinted in a proper way and it integrates nicely with code editors to give you the best typed, auto-completed and docstringed experience you can get. Because Fabric is ultimately a Python library, it also gives you the option to use other Python libraries in your code.

# Fabric and GTK
Fabric uses [GTK](https://www.gtk.org/) version 3, a widget and application development toolkit. Specifically, Fabric uses the python bindings of GTK ([PyGObject](https://wiki.gnome.org/action/show/Projects/PyGObject)). Without GTK, Fabric wouldn't exist!

# What is Cairo?
[Cairo](https://www.cairographics.org/) is a 2D graphics library used by GTK to draw surfaces and widgets. GTK allows you to draw custom surfaces and widgets through Cairo, and Fabric extends GTK even more by adding widgets that don't exist in GTK.
