#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWinDelay 0
SetTitleMatchMode 2

; Projection Controller — reliable window projection for Windows.
; Hotkeys: Ctrl+Alt+P Send | Ctrl+Alt+R Return | Ctrl+Alt+F Maximise | Ctrl+Alt+S Stop

class ProjectionController {
    static AppTitle := "Projection Controller"
    static originals := Map() ; HWND => {x, y, w, h, state, title}
    static projectedHwnd := 0
    static lastActiveHwnd := 0
    static gui := 0
    static statusText := 0
    static activeText := 0
    static listBox := 0

    static Start() {
        this.BuildDock()
        SetTimer ObjBindMethod(this, "Refresh"), 600
        this.Refresh()
    }

    static BuildDock() {
        g := Gui("+AlwaysOnTop +ToolWindow", this.AppTitle)
        g.SetFont("s10", "Segoe UI")
        g.AddText("w290 Center", "PROJECTION CONTROLLER")
        this.statusText := g.AddText("xm w290 Center", "Checking displays…")
        this.activeText := g.AddText("xm w290 Center", "Active: —")
        g.AddText("xm y+12", "Controls")
        sendBtn := g.AddButton("xm w140 h34 Default", "SEND  →")
        returnBtn := g.AddButton("x+10 w140 h34", "RETURN  ←")
        maxBtn := g.AddButton("xm w140 h34", "MAXIMISE")
        stopBtn := g.AddButton("x+10 w140 h34", "STOP PROJECTION")
        g.AddText("xm y+12", "Projected windows")
        this.listBox := g.AddListBox("xm w290 r4", [])
        g.AddText("xm y+10 w290 Center c666666", "Ctrl+Alt+P Send  ·  R Return  ·  F Maximise  ·  S Stop")
        sendBtn.OnEvent("Click", (*) => this.SendActive())
        returnBtn.OnEvent("Click", (*) => this.ReturnSelected())
        maxBtn.OnEvent("Click", (*) => this.MaximiseProjected())
        stopBtn.OnEvent("Click", (*) => this.StopProjection())
        g.OnEvent("Close", (*) => ExitApp())
        g.Show("AutoSize x20 y20")
        this.gui := g
    }

    static GetTargetMonitor() {
        count := MonitorGetCount()
        if (count < 2)
            return 0
        primary := MonitorGetPrimary()
        Loop count {
            if (A_Index != primary) {
                MonitorGetWorkArea A_Index, &left, &top, &right, &bottom
                return {number: A_Index, left: left, top: top, right: right, bottom: bottom}
            }
        }
        return 0
    }

    static GetSafeActiveWindow() {
        hwnd := WinExist("A")
        if !hwnd
            return 0
        if (hwnd = this.gui.Hwnd || WinGetTitle("ahk_id " hwnd) = this.AppTitle)
            return 0
        try {
            style := WinGetStyle("ahk_id " hwnd)
            if !(style & 0x10000000) ; WS_VISIBLE
                return 0
        } catch {
            return 0
        }
        return hwnd
    }

    static SendActive() {
        target := this.GetTargetMonitor()
        if !target {
            this.Notify("Secondary display not detected. Connect or extend a second display first.")
            return
        }
        hwnd := this.GetSafeActiveWindow()
        ; A dock button activates this controller first, so use the last non-dock
        ; window seen by the refresh timer in that case.
        if !hwnd && this.lastActiveHwnd && WinExist("ahk_id " this.lastActiveHwnd)
            hwnd := this.lastActiveHwnd
        if !hwnd {
            this.Notify("Select the application you want to project, then use Ctrl+Alt+P.")
            return
        }
        ; Single-active mode: return the previously projected window first.
        if (this.projectedHwnd && this.projectedHwnd != hwnd)
            this.ReturnWindow(this.projectedHwnd, false)
        this.ProjectWindow(hwnd, target)
    }

    static ProjectWindow(hwnd, target) {
        try {
            WinGetPos &x, &y, &w, &h, "ahk_id " hwnd
            state := WinGetMinMax("ahk_id " hwnd)
            if !this.originals.Has(hwnd)
                this.originals[hwnd] := {x: x, y: y, w: w, h: h, state: state, title: WinGetTitle("ahk_id " hwnd)}
            WinRestore "ahk_id " hwnd
            WinMove target.left, target.top, target.right - target.left, target.bottom - target.top, "ahk_id " hwnd
            WinMaximize "ahk_id " hwnd
            WinActivate "ahk_id " hwnd
            this.projectedHwnd := hwnd
            this.Refresh()
        } catch as err {
            this.Notify("Windows could not move that application: " err.Message)
        }
    }

    static ReturnSelected() {
        hwnd := this.projectedHwnd
        if (this.listBox.Value > 0) {
            names := []
            for id, details in this.originals
                names.Push(id)
            if (this.listBox.Value <= names.Length)
                hwnd := names[this.listBox.Value]
        }
        if hwnd
            this.ReturnWindow(hwnd)
        else
            this.Notify("There is no projected application to return.")
    }

    static ReturnWindow(hwnd, activate := true) {
        if !this.originals.Has(hwnd)
            return
        saved := this.originals[hwnd]
        try {
            WinRestore "ahk_id " hwnd
            WinMove saved.x, saved.y, saved.w, saved.h, "ahk_id " hwnd
            if (saved.state = 1)
                WinMaximize "ahk_id " hwnd
            else if (saved.state = -1)
                WinMinimize "ahk_id " hwnd
            if activate
                WinActivate "ahk_id " hwnd
        }
        this.originals.Delete(hwnd)
        if (this.projectedHwnd = hwnd)
            this.projectedHwnd := 0
        this.Refresh()
    }

    static MaximiseProjected() {
        if !this.projectedHwnd || !this.originals.Has(this.projectedHwnd) {
            this.Notify("No projected application is selected.")
            return
        }
        try WinMaximize "ahk_id " this.projectedHwnd
    }

    static StopProjection() {
        if this.projectedHwnd
            this.ReturnWindow(this.projectedHwnd)
        else
            this.Notify("Projection is already stopped.")
    }

    static Refresh(*) {
        target := this.GetTargetMonitor()
        this.statusText.Text := target ? "Screen " target.number ": connected ✓" : "No secondary display detected"
        hwnd := this.GetSafeActiveWindow()
        if hwnd
            this.lastActiveHwnd := hwnd
        activeName := hwnd ? WinGetTitle("ahk_id " hwnd) : "Controller"
        this.activeText.Text := "Active: " this.ShortName(activeName)
        labels := []
        stale := []
        for id, details in this.originals {
            if WinExist("ahk_id " id)
                labels.Push(this.ShortName(details.title))
            else
                stale.Push(id)
        }
        for id in stale
            this.originals.Delete(id)
        this.listBox.Delete()
        if labels.Length
            this.listBox.Add(labels)
        else
            this.listBox.Add(["No projected windows"])
    }

    static ShortName(name) => StrLen(name) > 42 ? SubStr(name, 1, 39) "..." : name
    static Notify(message) => MsgBox(message, this.AppTitle, "Icon!")
}

^!p::ProjectionController.SendActive()
^!r::ProjectionController.ReturnSelected()
^!f::ProjectionController.MaximiseProjected()
^!s::ProjectionController.StopProjection()

ProjectionController.Start()
