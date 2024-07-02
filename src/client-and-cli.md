# The CLI utility and client
When you start fabric (using the `start` function), Fabric will start executing the GTK main thread and start a DBus client, which allows you to execute code on-the-fly and get information about your configuration file. Fabric grabs your global and local environment so when you execute code using the client you get all of your variables, objects, and/or modules.

The CLI utility is just a command line tool to use the client instead of dealing with DBus communications yourself.

## Usage
```
$ python -m fabric --help
Usage: python -m fabric [OPTIONS] COMMAND [ARGS]...

Options:
  --help  Show this message and exit.

Commands:
  execute  executes a python code within the running fabric instance
  info     gets info about the currently running fabric instance
```
## Examples

```
$ python -m fabric info -j
{'file': '/home/<user>/.config/fabric/bar.py'} # this is just an example, your output might differ, outupt is in json format because of the -j flag
```

```
$ python -m fabric execute "bar.hide()" -j # executing python code
{'source': 'bar.hide()', 'exception': ''} # no errors
```

```
$ python -m fabric execute "bar.this_method_does_not_exist()" -j # error should return
{'source': 'bar.this_method_does_not_exist()', 'exception': 'AttributeError("\'StatusBar\' object has no attribute \'this_method_does_not_exist\'")'} # there's an error, the exception got returned by Fabric
```
