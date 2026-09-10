# Projection Controller

> Send any desktop app to your second screen with a keyboard shortcut or a compact control dock.

Projection Controller is a lightweight Windows utility for presenters, teachers, streamers, and anyone who needs to move an application between their laptop and an external display quickly. It remembers where the window started, so returning it puts it back exactly where it was.

## Features

- Detects whether a secondary display is connected.
- Sends the selected application to the external display and maximises it.
- Returns the application to its original position, size, and window state.
- Keeps one active projected app at a time for a clean presentation screen.
- Provides an always-on-top control dock as well as global keyboard shortcuts.
- Works with normal Windows desktop apps, including browsers, VLC, PowerPoint, Spotify, and VS Code.

## Requirements

- Windows 10 or Windows 11
- A second display, projector, or TV connected to the computer
- Displays set to **Extend** mode

> [!IMPORTANT]
> This app needs an *extended* desktop. In Windows, press `Windows + P` and choose **Extend**. It cannot project independently while displays are set to **Duplicate**.

## Install and run

### Option 1 — Use the executable (recommended)

1. Download `ProjectionController.exe` from this repository’s **Releases** page.
2. Double-click the file to start it.
3. The Projection Controller dock appears at the top-left of your primary screen.

Windows may show a SmartScreen warning for a new unsigned application. Choose **More info → Run anyway** only if you downloaded the file from this repository and trust it.

### Option 2 — Run the AutoHotkey source

1. Install [AutoHotkey v2](https://www.autohotkey.com/). AutoHotkey v1 is not compatible.
2. Download or clone this repository.
3. Double-click `ProjectionController.ahk`.

## How to use it

1. Connect your projector or second monitor.
2. Press `Windows + P`, then select **Extend**.
3. Open the app you want to show—for example Chrome, VLC, or PowerPoint—and click it so it is the active window.
4. Press `Ctrl + Alt + P`, or click **SEND →** in the dock.
5. The app moves to the external display and fills it.
6. When finished, press `Ctrl + Alt + R`, or click **RETURN ←**, to restore the app to its original location.

## Keyboard shortcuts

| Shortcut | Action |
| --- | --- |
| `Ctrl + Alt + P` | Send the active application to the second display |
| `Ctrl + Alt + R` | Return the projected application |
| `Ctrl + Alt + F` | Maximise the projected application |
| `Ctrl + Alt + S` | Stop projection and return the application |

## How projection works

Projection Controller moves the actual application window to your second screen; it does not create a separate copy of the app. This makes it dependable across most regular Windows apps and lets you operate the application normally on the presentation display.

When you project another app, the previously projected app is automatically returned to its original position. This keeps the external screen focused on one application at a time.

## Troubleshooting

### “No secondary display detected”

- Check that the display cable or wireless display connection is active.
- Open **Settings → System → Display** and confirm Windows sees two displays.
- Press `Windows + P` and select **Extend**.

### The app will not move

- Click the target application first, then use `Ctrl + Alt + P`.
- If the target app is running as Administrator, start Projection Controller as Administrator too. Windows prevents a normal app from controlling elevated windows.
- Some protected, system, or full-screen applications do not allow external programs to reposition their windows.

### The shortcut does not work

- Ensure Projection Controller is running; its dock should be visible.
- Check that another app has not assigned the same shortcut.
- Use the buttons in the dock as an alternative.

## Limitations

- The first non-primary display is used as the projection target.
- Universal presenter-copy mode is not possible for every Windows app. If you need a separate presenter view while viewers see the content, use the app’s built-in feature where available—for example, PowerPoint Presenter View or Chrome Cast.
- This tool manages application windows; it does not duplicate audio, capture screens, or control a projector’s hardware settings.

## Start automatically with Windows (optional)

1. Press `Windows + R`, type `shell:startup`, and press Enter.
2. Create a shortcut to `ProjectionController.exe` in the folder that opens.
3. Projection Controller will start when you sign in.

## Source

The source version is written for AutoHotkey v2 and is provided in `ProjectionController.ahk`.
