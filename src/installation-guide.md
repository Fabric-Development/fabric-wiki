# Installing Guide

it's really simple to get Fabric working, you just...

## 1. Install Python

Fabric requires python version 3.11 or higher

For arch linux you do `pacman -S python` to get the latest version of python

## 2. Get The Dependencies

This step does depend on your system, this command will work for arch linux to install the dependency's using `pacman`

`sudo pacman -S gtk3 cairo gtk-layer-shell libgirepository gobject-introspection gobject-introspection-runtime python python-pip python-gobject python-cairo python-loguru pkgconf`

_if you're not on Arch, you will have to figure out yourself what is the package names for your distribution_

## 3. Install Fabric

> [!TIP]
> Fabric is available under the arch user repository with the name `python-fabric-git`

You can install Fabric globally using `pip install git+https://github.com/Fabric-Development/fabric.git` although we **don't** prefer this way because it might cause dependency issues, it's better to use a [virtual environment](https://docs.python.org/3/library/venv), to get Fabric in a virtual environment you'll have to do the following

Make a new folder for your new project

```bash
mkdir <your-folder-name>
```

Change the current directory to this new folder

```bash
cd <your-folder-name>
```

Create a new virtual environment, this command will create a virtual environment with the name `venv`

```bash
python -m venv venv
```

Activate the newly created virtual environment

```bash
source venv/bin/activate
```

Now you after installed packages, we can install Fabric now...

```bash
pip install git+https://github.com/Fabric-Development/fabric.git
```

Fabric is now installed, you can run it and use it as long as you want, yet you will be missing auto-completions and type annotations in your code editor, to get it working head over to the [stubs installing guide](installing-stubs.md)
