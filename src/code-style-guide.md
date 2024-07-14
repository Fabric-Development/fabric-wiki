# Style Guide
> First of all, we really appreciate your intention to contribute into our project!

This is the style guide of our project; here, we'll walk you through how can you write silk-looking code that will integrate nicely into our codebase.

## Code Formatting
All code should be formatted using [the ruff python formatter](https://github.com/astral-sh/ruff).

Indentation must be 4 **spaces**. Please do not use tabs or any number other than 4 spaces.

## Definitions and Naming
We employ different naming conventions based on use cases:
- `snake_case`: Functions or variables
- `SCREAMING_SNAKE_CASE`: Constants
- `PascalCase`: Classes
- `kebab-case`: GObject signals/properties

## Comments
Follow the [PEP 8](https://peps.python.org/pep-0008/) guidelines when adding comments. In a nutshell, comments should look:
```python
# Like this.

##not like this..##
#nor like this..
#--/ nor whatever else. /--#
```

## Logging
Logging functionality should use [loguru](https://github.com/Delgan/loguru). Adhere to these rules:
- Be concise; avoid verbosity.
- Refrain from committing files with `debug`-level log statements.
- Reserve the log level `error` for critical cases, such as severe component failures or dependencies crucial to the entire program.
- Avoid unnecessary `info` statements in low-level classes/modules, unless it's a service subclass.

If uncertain about where to log, feel free to inquire in the pull request!

## Conditionals
We use inline if-statements in our codebase if the condition will change the value of only one object:

```python
x = "the x object" if unexpected_feature is not True else "the x man"
```

And we use regular if statements if a block of code will be executed instead of one object being changed:
```python
if unexpected_feature is True:
    x = "the unknown guy"
    y = "idk"
    z = 4002
    ...

# This is much more concise and clear than
x = "the unknown guy" if unexcpected_feature is True else None
y = "idk" if unexcpected_feature is True else None
z = 4002 if unexcpected_feature is True else None
```

## Commit Messages
Commits in Fabric should follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification. In a nutshell, structure commits like this:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```
For example:
```
feat: Add `balloons` argument to `Universe.celebrating_koalas`
```
```
fix: Check for fradulent koalas before allocating balloons
```

Types can be `feat`, `fix`, or others. For more examples and information on things like breaking changes, visit the specification. 

## Logging The Changes

When you're finally done working on your commits and everything is ready, just add information about the commit(s) you made to the `CHANGELOG.md` file describing the changes made in a simple language and a small amount of characters. For example:

```
-- Format --

<Change-Number>. <#Pull-Request-Number> <Commit-Message>

-- Examples --

1. <#Pull-Request-Number> feat: something awesome!

2. <#Pull-Request-Number> feat: new method to do magic!

3. <#Pull-Request-Number> fix: fabricated, this fixes/closes <issue number if exists>!

4. refactor: i dunno how to fabricate XD
```
