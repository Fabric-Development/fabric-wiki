# Hacking into Fabric!

In the guts, Fabric is made to be a hackable package, this wiki page will walk you through doing your own modifications into Fabric's source!

# Acknowledgements and Notes

> [!NOTE]
> Please note that Fabric is built using GTK version 3, widgets from other versions are incompatible or will require more work to get it to work

> [!TIP]
> Having knowledge about how GTK and GObject works will make you able to hack more without having issues along with the way, these are some useful resources to learn more about GTK and GObject
>
> -   [Sebastian's tutorial on PyGObject](https://python-gtk-3-tutorial.readthedocs.io/en/latest/)
> -   [The official tutorial from PyGObject](https://gnome.pages.gitlab.gnome.org/pygobject/)
> -   [The docs i personally use](https://lazka.github.io/pgi-docs/)
> -   [Foundations of PyGTK Development (book)](https://link.springer.com/book/10.1007/978-1-4842-4179-0)

> [!TIP]
> If the widget you're trying to implement was already implemented somewhere else (even if it was in whole another language) using GTK (version 3) and/or Cairo, porting it will be nothing hard, if that widget was drawn using Cairo, you can just use the same exact drawing functions since the Cairo bindings doesn't differ from language to another

# Development Environment

Before anything you should prepare your own development environment, to do that read [this page](development-environment.md)

# Source Tree

### Widgets

Fabric has a very special widget, which's `Widget` (at `fabric.widgets.widget`), and that's because pretty much every other Fabric widget inherit properties and methods from this widget, this make's easier to make a modification that's intended to get reflected on all of the other widgets

### Services and Objects

Fabric has the `Service` base class (at `fabric.service`), inherit from this class if you're looking create a new Fabric service, also you should replace the decorator `@property` with the `@Property` decorator (imported from `fabric.service`) so you get notifiable properties in your service
to get signals you can change the variable `__gsignals__`, it takes a `SignalContainer` object (from `fabric.service`), that signal container takes `Signal` objects as an argument, here is an example...

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

for more details on services, head over to [this wiki page](services.md)

# Write a New Widget?

To start writing your own widget you can firstly check if GTK do already support that widget, at the end, we don't want to reinvent the wheel, if GTK does implement the widget you're looking for, then the work will be much less harder, otherwise you don't have to worry since this page will also teach you how to write your own widget from scratch!

# My Widget Exists Within GTK

You can do one of the following to get the widget...

-   Just use it: Fabric is fully compatible with GTK widgets so you can import the widget and use it as you want, note that this will not provide the new widget with all of Fabric's features (i.e setting the style within the construction), to get these features skip to the next point

-   Fabricate the widget: _fabricating_ a widget means that you take a GTK widget and convert it into a Fabric widget, this will make you able to use all Fabric features like special methods and properties

# Fabricating a GTK Widget

To start off you first have to check the type of the widget you want to fabricate, there's two types in general, a normal widget, and a container

Normal widgets (AKA non-containers) are widgets that inherit properties and methods from the base widget (`Widget`) and can't hold any widgets inside of it (i.e, labels and images)

Containers are normal widgets that inherit properties and methods from the base container class (`Container`) which also inherit methods and properties from the base widget (`Widget`), these container widgets can hold one or multiple widgets as a children (i.e boxes and windows)

To fabricate a non-containing widget you first have to locate where your widget class lives, lets say your widget lives under the name `MyWidget` in GTK

```python
import gi # import the gi repository to get GTK from it later
gi.require_version("Gtk", "3.0") # graps the version 3 of GTK since this is what fabric uses
from gi.repository import Gtk # now we have GTK (version 3) imported

from fabric.widgets.widget import Widget # imports fabric's base widget


class MyFabricatedWidget(Gtk.MyWidget, Widget): # creates a new class named "MyFabricatedWidget", this class inherits the desired GTK widget and fabric's base widget
    def __init__(self, **kwargs): # the initializer function, kwargs (a dict) means whatever you pass as extra argument will be in that dict
        # you can set more arguments to this newly created class, this is useful if you want to make this widget able to do more stuff within the initialization phase
        # more logic to handle the new arguments (if any)
        super().__init__(**kwargs) # initializes the new mixed class
```

_fabricating a container widget will be same as fabricating a normal widget, you just use the `Container` widget from Fabric instead of `Widget`_

# Debugging

Now you got into issues, no panic (ok?), if your code does not work at all, _read the error_, most of the times it provides a got set of information (i.e the call stack)

There is some specific errors that might be hard to debug, for examples errors produced by GTK itself due to your function/method call, these errors mostly are useless but the can sometimes be helpful, it only provides the assertion error for the most cases which might be handy to get a traceback of what's causing this issue to happen, also sometimes you get absolutely nothing useful out from the error, this is how to debug these invisible [Heisenbugs](https://en.wikipedia.org/wiki/Heisenbug)

-   Check your environment variables:

E.g. i tried running an X11 window under X11 but the environment variable `GDK_BACKEND` was set to `wayland` due to me forcing the editor to to set it this way and i was forgotten that it was an issue from the environment variables

E.g: my window works and all but me begin under wayland the window should open as a layer not a normal window, later i checked on my environment variables and found the `GDK_BACKEDN` set to `x11`
another possibility that I was using GNOME and because GNOME begin GNOME they haven't implemented the layer-shell protocol on wayland, which makes me empty handed to do anything about this. I <3 GNOME!

-   Use a debugger and breakdowns to determinate which call causes the issue:

E.g: I decided to call a function that I know it exists in the source of the GI repository package I'm trying to use, my code segfaults everytime I run it, later while reading the docs I knew that this specific function is not exposed to the binding I'm using anyways the recommend me another way of doing the same _thing_ the function I'm trying to use does

-   Check your threads stack:

E.g: I made a new service, it works like a charm, but after unknown amount of time the entire thing crash, I later found out from a friend that I should update the properties of a object declared in the main thread should be done in the main thread, he pointed me to the part I use a thread so I checked on there to found that I indeed do call a function defined in the main thread and pass to it an object defined in my thread which led to my code begin [thread safe](https://en.wikipedia.org/wiki/Thread_safety), after looking for a solution I found out that I can use something like `GLib.idle_add` to call a function with my objects in a thread safe way, everything works now as expected

-   Variable overwrites

E.g. i made a class that inherits the service class, i made a new method in my new class called `connect`, i wrote the logic of it and everything is fine, but when i run the code i get an argument error, i do pass everything intended to to passed to this function, ITS WRITTEN TO HANDLE THIS, but i found out that the metaclass (which's the service class) already do have a method with the name `connect` and also the metaclass uses this function internally, so when the service class calls the method `connect` i receive the call in my inherited class because i've already overwrote the original method, at the end i was able to come across this by just yeeting the service class since i NEED my method name to be `connect`

These was all the possibilities i was able to think of for generally code issues and hidden bugs

---

Now, there's another kind of bugs, which's the visual bugs, means that actually the code works as expected but there's some unexpected drawing issues, at this point you can checkout the [GTK Inspector](https://wiki.gnome.org/Projects/GTK/Inspector), it's really useful for this kind of issues

To get the inspector window you can set the environment variable `GTK_DEBUG` to `interactive` before running your code

---

Still can't find what's causing your code not to act as it should to?, you can always hop into Fabric's discord server and ask on whatever you want and we would be more than happy helping you!
