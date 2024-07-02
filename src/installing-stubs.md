# Obtaining a Stubs Package
Code auto-completions and type annotations in your editor require **one** of the following packages to function. Each package has its own installation guide.

## PyGObject-Stubs
PyGObject provides a [Python package](https://github.com/pygobject/pygobject-stubs) that gives you simple auto-completions. It's not perfect - not all gi repositories are type-annotated or docstringed. This works if you're planning to stick to the documentation of GTK and Fabric.

## FakeGir
[FakeGir](https://github.com/strycore/fakegir) is a Python script that generates an overrides file for your editor to use; it's not considered a real stubs package because you will have to configure your editor to use the overrides file instead of the hints from the code.

## GenGir
[GenGir](https://github.com/santiagocezar/gengir) generates a stubs package and installs it for you, whether for global Python packages or a virtual environment. Also the maintainer's personal favorite tool out of these options.

## Fabric Stubs
There is an ongoing process to write a stubs package made to be used with Fabric based on a refined version of the stubs produced by GenGir. This package is not yet public, though that may change in the future...
