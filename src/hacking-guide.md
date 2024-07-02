# Hacking into Fabric
Fabric is made to be a hackable package at its core. This guide will walk you through making your own modifications to Fabric's source!

## Notes

> [!NOTE]
>   Please note that Fabric is built using GTK version 3; widgets from other versions are either incompatible or will require more effort to get to work. 

> [!TIP]
> Having knowledge about how GTK and GObject works will greatly enhance your hacking ability while reducing issues along with the way; these are some useful resources to learn more about GTK and GObject.
> - [Sebastian's tutorial on PyGObject](https://python-gtk-3-tutorial.readthedocs.io/en/latest/)
> - [The official tutorial from PyGObject](https://gnome.pages.gitlab.gnome.org/pygobject/)
> - [The docs the maintainer personally uses](https://lazka.github.io/pgi-docs/)
> - [Foundations of PyGTK Development (book)](https://link.springer.com/book/10.1007/978-1-4842-4179-0)

> [!TIP]
> If the widget you're trying to implement was already implemented somewhere else (even if it was in another language) using GTK (version 3) and/or Cairo, porting it will be simple: you can just use the same drawing functions, since the Cairo bindings don't differ from language to another.

## Development Environment
Before doing anything else, you should prepare your development environment; to do that, read [this page](development-environment.md).

## Source Tree
### Widgets
Fabric has a very special widget at its core: `Widget`(`fabric.widgets.widget`). Nearly every other Fabric widget inherits properties and methods from this widget. This makes it simple to make a modification that is reflected across all widgets.

### Services and Objects
Fabric has the `Service` base class (at `fabric.service`). New Fabric services should be inherited from this class. When doing this, make sure to replace the decorator `@property` with `@Property` (imported from `fabric.service`) to get notifiable properties in your service.

To create signals, you can change the variable `__gsignals__`. `__gsignals__`  takes a `SignalContainer` object (from `fabric.service`), and that signal container takes `Signal` objects as arguments. An example:

```python
from fabric.service import *

class MyUsefulService(Service):
    __gsignals__ = SignalContainer(
        Signal("my-really-useful-signal", "run-first", None, (object,))
        # signal name, run flags, what does the call back return, the argument type of the callback
    )
    def __init__(self):
        self.emit("my-really-useful-signal", "this is my super useful argument passed to you, what a useful string")
```
For more details on services, head over to [this wiki page](services.md).

## Writing a New Widget
To start writing your own widget, you you should first check if GTK already includes that widget; after all, we don't want to reinvent the wheel. If GTK does implement the widget you're looking for, then the work will be much simpler. Even if it doesn't, you don't have to worry, since this page will also teach you how to write your own widget from scratch!

### My Widget Exists Within GTK
Do one of the following to get the widget:

- Just use it: Fabric is fully compatible with GTK widgets, so you can import the widget and use it however you need to. Note that this will not provide the new widget with all of Fabric's features (i.e setting the style within the construction), so if you require these see the option below.

- Fabricate the widget: _fabricating_ a widget means that you take a GTK widget and convert it into a Fabric widget; this will make it possible to use Fabric's features like special methods and properties.

#### Fabricating a GTK Widget
To start fabricating a widget, first check the type of the widget you want to fabricate. In general, there are two types of widgets: a regular widget and a container.

Normal widgets (AKA non-containers) are widgets that inherit properties and methods directly from the base `Widget` class and can't hold any child widgets (i.e. labels and images).

Containers are widgets that inherit properties and methods from the base `Container` class (which eventually inherits methods and properties from the base widget). These container widgets can hold one or multiple widgets as children (i.e. boxes and windows).


Next, you should locate where your widget class lives. For example, if your non-container widget is under the name `MyWidget` in GTK:
```python
import gi # import the gi repository to get GTK from it later
gi.require_version("Gtk", "3.0") # graps the version 3 of GTK since this is what fabric uses
from gi.repository import Gtk # now we have GTK (version 3) imported

from fabric.widgets.widget import Widget # imports fabric's base widget 


class MyFabricatedWidget(Gtk.MyWidget, Widget): # creates a new class named "MyFabricatedWidget", this class inherits the desired GTK widget and fabric's base widget

    def __init__(self, **kwargs): # the initializer function, **kwargs (a dict) means whatever you pass as extra argument will be in that dict
        # you can set more arguments to this newly created class, this is useful if you want to make this widget able to do more during the initialization phase
        # you may add more logic here to handle the new arguments (if any)
        super().__init__(**kwargs) # initializes the new mixed class
```

Fabricating a container widget is the same process as fabricating a normal widget; just use the `Container` widget from Fabric instead of `Widget` when inheriting.


## Debugging
Oh, you ran into an issue. Don't panic! If your code does not work at all, **read the error**; most of the time, it provides a lot of information (i.e the call stack).

There are some specific errors that may be more difficult to debug, such as errors produced by GTK itself due to your function/method call. These errors, in most cases, only provide the assertion error (which *might* be handy to get a traceback). Here's how to debug these invisible [Heisenbugs](https://en.wikipedia.org/wiki/Heisenbug):

- Check your environment variables
  - For example, I try running an X11 window under X11 but the environment variable `GDK_BACKEND` is set to `wayland` due to me forcing the editor to to set it this way and forgetting. This was the problem that caused my Wayland window to open as a normal window, not a layer. (Another possibility here was that I was using GNOME, which hasn't implemented the layer-shell protocol on Wayland and therefore makes it impossible to do anything to fix issues with it.)

- Use a debugger and breakpoints to identify the source of the problem
  - For example, I decide to use a function that I know  exists in the source of the GI repository package I'm trying to use, but my code produces a segmentation fault every time I run it. (Later, while reading the docs, I figured out that this specific function was not exposed to the binding I was using.)

- Check your thread-safety
  - For example, I make a new service and it works like a charm. After an unknown amount of time, though, the entire thing crashes. I later found out from a friend that I was updating the properties of an object defined in the main thread in a different thread, leading to a loss of [thread safety](https://en.wikipedia.org/wiki/Thread_safety). After discovering this issue, I found a function that did the same thing I needed to do (like `GLib.idle_add`) in a thread-safe way.
  
- Variable or method overwrites
  - For example, I make a new class that inherits `Service`. I then write a new method: `connect`, but when I run the code I get an `ArgumentError` even though I pass everything necessary into the method. I then find out that the `Service` class already has a `connect` method that is used internally, so when I try to use `connect` in my new class I'm actually calling the method in the `Service` class. I fixed this issue by using a different class to inherit from, though you can also solve this type of issue by simply renaming the method.

### Visual Bugs

There's another kind of bug - the visual bugs. A visual bug means that the code works as expected, but there are graphical issues with rendering or drawing. A great tool to use for these issues with Fabric or GTK is the [GTK Inspector](https://wiki.gnome.org/Projects/GTK/Inspector).

To get the inspector window in Fabric, set the environment variable `GTK_DEBUG` to `interactive` before running your code.

---
If you still can't find what's causing your code not to act as it should, you can always hop into Fabric's [Discord server](https://discord.gg/xKDnfGee) and ask your question - we're happy to help!
