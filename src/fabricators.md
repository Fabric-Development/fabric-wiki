# Fabricator? What is That?
fabricators are a special classes that gets grabs you info from _somewhere_ , fabricators can poll data from external shell commands or internal python functions, it can also read streams of data, like a shell command that stays running by printing out data over the time to the standard output or _generator_ functions that yield data

fabricators gives you a set of options, here's some of the options it gives you...
- the initial value this fabricator should be initialized with
- where to poll the data, it can be a python function/generator or a shell command
- the interval time of calling the passed command/function and poll data from it (in milliseconds)
- whether you want data as a stream (for polling data from generators and stream shell commands) 

without any further ado, lets get some examples of using fabricators

**1. monitor player state:**
this example utilizes a fabricator to read a stream from a external command (`playerctl -f status`) which will print the current media player state when it changes
```python
import fabric
from fabric.utils.fabricator import Fabricate

# create a fabricator to continuously monitor player state
player_fabricator = Fabricate(poll_from="playerctl -F status", stream=True)

# define a function to handle state changes
def print_state_change(fabricator, value): # notice that the first argument is the fabricator itself
    print(f"player state changed: {value}")

# connect the fabricator to the "changed" signal and register the handler
player_fabricator.connect("changed", print_state_change)

# start the main loop
fabric.start()

# output (may vary)
# player state changed: playing
# player state changed: paused
# player state changed: playing
# ...
```

**2. display periodic updates:**
in this example we use a fabricator to poll data from the shell command `date` every 500ms and print the output of it
```python
import fabric
from fabric.utils.fabricator import Fabricate

# create a fabricator to periodically retrieve the date and time
date_fabricator = Fabricate(poll_from="date", interval=500)  # 500 milliseconds

# define a function to handle date updates
def print_date(fabricator, value):
    print(f"current date and time: {value.strip()}")

# connect the fabricator to the "changed" signal and register the handler
date_fabricator.connect("changed", print_date)

# start the main loop
fabric.start()

# output (may vary)
# current date and time: Mon Mar  4 02:50:10 AM EET 2024
# current date and time: Mon Mar  4 02:50:10 AM EET 2024
# current date and time: Mon Mar  4 02:50:11 AM EET 2024
# current date and time: Mon Mar  4 02:50:11 AM EET 2024
# current date and time: Mon Mar  4 02:50:12 AM EET 2024
# ...
```

**3. advanced polling with stopping condition:**
in this example we fabricate a function instead of a shell command
```python
import fabric
from fabric.utils.fabricator import Fabricate

# global variable to track the counter
number = 0

def generate_number(fabricator):
    global number
    number += 1
    return number

# create a fabricator to poll the number generation function
function_fabricator = Fabricate(poll_from=generate_number, interval=300)  # 300 milliseconds

def handle_number(fabricator, value):
    if value == 43:
        fabricator.stop_polling()
        print("fabricator stopped")
    else:
        print(f"generated number: {value}")

# connect the fabricator to the "changed" signal and register the handler
function_fabricator.connect("changed", handle_number)

# start the main loop
fabric.start()

# output
# generated number: 1
# generated number: 2
# generated number: 3
# ...
# generated number: 42
# fabricator stopped
```
