# What are Fabricators?
Fabricators are special classes that can grab you info from external shell commands or internal Python functions. Fabricators can also read streams of data like a shell command that stays running or a Python generator function.

Fabricators give you some important options during initalization, including:

- The initial value the fabricator should be initialized with
- Where to poll the data from, whether it is a Python function/generator or a shell command
- The poll frequency: how often you want the fabricator to poll the function or command in milliseconds
- Whether you want data as a stream (for polling data from generators and stream shell commands)

So, let's look at some examples of using fabricators!

## Media Player State
This example utilizes a fabricator to read a stream from an external command (`playerctl -f status`) and print the current media status when it changes.

```python
import fabric
from fabric.utils.fabricator import Fabricator

# create a fabricator to continuously monitor player state using the command
player_fabricator = Fabricator(poll_from="playerctl -F status", stream=True)

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

## Periodic Date Updates
in this example, we use a fabricator to poll data from the shell command `date` every 500ms and print the output of it.
```python
import fabric
from fabric.utils.fabricator import Fabricator

# create a fabricator to periodically retrieve the date and time
date_fabricator = Fabricator(poll_from="date", interval=500)  # 500 milliseconds

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

## Advanced Polling
In this example we fabricate a function instead of a shell command, and demonstrate how to use a stopping condition.
```python
import fabric
from fabric.utils.fabricator import Fabricator

# global variable to track the counter
number = 0

def generate_number(fabricator):
    global number
    number += 1
    return number

# create a fabricator to poll the number generation function
function_fabricator = Fabricator(poll_from=generate_number, interval=300)  # 300 milliseconds

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
