# ActiveSpace.spoon
HammerSpoon menu bar item to show active Mission Control space.

Built-in and external display names are shown. Spaces are listed in order per display. Active space is square bracketed.

<img width="716" alt="ActiveSpace Menu" src="https://github.com/mogenson/ActiveSpace.Spoon/assets/900731/2ea56416-47bc-4fdd-8e16-950f23f57edd">


Example config:
```lua

ActiveSpace = hs.loadSpoon("ActiveSpace")
ActiveSpace:start()
```

## Compact mode

Click the menubar to switch to a compact view without display names.

Or, set `ActiveSpace.compact = true` in the HammerSpoon config. The default is false.
