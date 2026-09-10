# Projection Controller for Windows

This is a working AutoHotkey v2 application for reliable **window projection**: it moves an ordinary app window to a second display, remembers the exact starting position, and restores it on command.

## What it does

- Detects connected displays and safely refuses projection if there is no second display.
- Projects the currently selected app to the first non-primary monitor.
- Restores the app exactly to its original size, position, and maximised/minimised state.
- Uses single-active projection: sending a new app returns the old projected app first.
- Includes an always-on-top controller dock and global hotkeys.

| Action | Hotkey |
| --- | --- |
| Project selected app | `Ctrl + Alt + P` |
| Return projected app | `Ctrl + Alt + R` |
| Maximise it on the projector | `Ctrl + Alt + F` |
| Stop / return it | `Ctrl + Alt + S` |

## What you need to do

1. In Windows, connect the external display and choose **Settings → System → Display → Extend these displays**. Do not use “Duplicate”; projection needs an independent display area.
2. Install **AutoHotkey v2** from [autohotkey.com](https://www.autohotkey.com/). Version 1 is not compatible.
3. Double-click `ProjectionController.ahk`. You should see the dock in the top-left of your primary screen.
4. Select Chrome, VLC, PowerPoint, VS Code, or another normal desktop application and press `Ctrl + Alt + P`.
5. If an app is running as administrator, start this controller as administrator too—Windows blocks lower-privilege apps from moving elevated windows.

## Important limits

This is not a universal “presenter copy” engine. Windows cannot safely generate a separate, clean interactive copy of every app’s content while the original remains on the laptop. For that behaviour, use an app’s own presenter / cast mode where available (PowerPoint Presenter View, Chrome Cast, VLC renderer, etc.). This controller provides the dependable alternative: move and maximise the actual window on the external screen while the dock stays on the laptop.

## Optional next upgrades

- Compile the script to an `.exe` using AutoHotkey’s `Ahk2Exe` tool.
- Put a shortcut in `shell:startup` to launch it at sign-in.
- Add named profiles and dedicated hotkeys once you have confirmed your display arrangement.
- The drag-to-project drop zone can be added next; it requires deeper window-event handling and should be tested against the specific apps you use.
