# Getting a Stub Package
to get code auto-completions and type-annotations in your code editor you can use one of the following tools/packages, each tool/package has it's own installation guide, follow the provided like to each method and install the one you like
# PyGObject-Stubs
PyGObject provides a [python package](https://github.com/pygobject/pygobject-stubs) that gives you simple auto-completions, it's not made to be perfect nor near that, not all gi repositories are type-annotated or docstringed, it works if you're going to stick with the documentations of GTK and Fabric
# FakeGir
[FakeGir](https://github.com/strycore/fakegir) is a python script that generates a overrides file, it's not considered as stubs since you will have to configure your editor to use the path to the generated files instead of the actual code in the PyGObject package files
# GenGir
[GenGir](https://github.com/santiagocezar/gengir) is my favorite, it generates an actual stubs package and installs it for you whether in a virtual environment (if any) or your global python packages
# Fabric Stubs
there's an in-going process of writing a stubs package made to be used with Fabric based on a refined version of the stubs produced by [GenGir](https://github.com/santiagocezar/gengir), the package is still not public, this might get changed...
