# Installation Guide
I's really simple to get Fabric working, you just...

> [!TIP]
> If you use Arch Linux, Fabric is available in the AUR under the name `python-fabric-git`. If you use a different repository or would prefer to install on your own, continue to step 1.

## 1. Install Python
Fabric requires Python version 3.11 or later. Check your distribution's instructions or package manager to get the required version.

* Arch Linux: `pacman -S python` for the most recent version

## 2. Install  Dependencies

Fabric requires the following dependencies to run:
* `gtk3`
* `cairo`
* `gtk-layer-shell`
* `libgirepository`
* `gobject-introspection`
* `gobject-introspection-runtime`
* `python`
* `python-pip`
* `python-gobject`
* `python-cairo`
* `python-loguru`
* `pkgconf`

> [!NOTE]
> Names of packages and installation instructions vary across  distributions and systems. You may have to do some searching for your system.

To install all dependencies:
* Arch Linux: `sudo pacman -S gtk3 cairo gtk-layer-shell libgirepository gobject-introspection gobject-introspection-runtime python python-pip python-gobject python-cairo python-loguru pkgconf`


## 3. Install Fabric

You can either install Fabric globally (not recommended) or in a virtual environment.

### Virtual Environment
The recommended way to install Fabric is through a [virtual environment](https://docs.python.org/3/library/venv).

1. To install this way, first make a folder for your new project:
```bash
mkdir <your-folder-name>
```

2. Next, change directories to this new folder:
```bash
mkdir <your-folder-name>
```

3. Create a new virtual environment:
```bash
python -m venv <your-virtual-environment-name>
```

4. Source the newly created virtual environment:
```bash
source venv/bin/activate
```

5. You can now install Fabric in your newly-created virtual environment.
```bash
pip install git+https://github.com/Fabric-Development/fabric.git
```

### Global Install
Alternatively, you can install Fabric globally using the following command:
```bash
pip install git+https://github.com/Fabric-Development/fabric.git
```
This method is more prone to dependency issues.

---

Congrats! Fabric is now installed, and you can run and use it as long as you would like. To get auto-completion and type annotation functionality in your text editor, head over to the [stubs installation guide](installing-stubs.md).
