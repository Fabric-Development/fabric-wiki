# Development Environment

This page will walk you through setting up your hacking environment

# Setup The Source

To start developing it's better to grab the latest commit for Fabric so you're up-to-date
for that you use

```bash
git clone https://github.com/Fabric-Development/fabric
```

> [!NOTE]
> not that when you clone the source it will be located at the same current working directory

You can now change the current directory into the newly cloned source

```bash
cd fabric
```

# Start Hacking

Now you can continue inside using your code editor, this step is optional but using a IDE will make your life easier

_for this example we use VSCode as the code editor_

```
code .
```

**now we can start initializing the python environment**

first we will create a new python venv and source it

```bash
python -m venv venv
```

```bash
source venv/bin/activate
```

_now we have a separated environment from system wide_

next we install the current Fabric source in place as a package

```bash
pip install -r requirements.txt
pip install -e .
```

everything is now ready, you can continue the hacking from [this page](hacking-guide.md)
