# Development Environment
This page will walk you through setting up your development environment for Fabric.

## Fabric Source
To start developing, you should grab the latest commit of Fabric so that you're up-to-date.

To do this, run this command:
```bash
git clone https://github.com/Fabric-Development/fabric
```

> [!NOTE]
> Cloning the source repository this way will create a new folder in your current working directory.

You can then change your directory into this newly created clone.
```bash
cd fabric
```

## Virtual Environment
> [!NOTE]
> You can continue inside an integrated terminal now if you prefer. For this example, we use VSCode:
> ```bash
> code .
> ```

Create a Python virtual environment:
```bash
python -m venv <your-virtual-environment-name>
```

Source your new virtual environment:
```bash
source venv/bin/activate
```

We now have a separate environment for packages.

Finally, install the current Fabric source in place as a package:
```bash
pip install -r requirements.txt
pip install -e .
```

And you're ready! Continue on [this page](hacking-guide.md) to start hacking.
