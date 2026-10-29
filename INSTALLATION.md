# Homebase – Installation

## Requirements
- X-Plane 12 (12.1 or newer)
- Windows 64-bit (this beta has no macOS or Linux build yet)

## Download
Get `Homebase_beta_2026-10-29.zip` from the [Releases](https://github.com/MoWoSf/Homebase/releases) page of this repository (about 680 MB).

## Install
With X-Plane closed, unpack the ZIP straight into your **X-Plane 12 folder** and let it merge with what is already there. That's all.

It adds two folders:
- `Resources/plugins/Homebase/`: the plugin
- `Custom Scenery/Private Hangar Homebases/`: the hangar models

On its first start, Homebase sets itself up:
- It creates `Homebase.ini` from `Homebase.ini.default`.
- It moves its scenery pack above your airports in `scenery_packs.ini`, so buildings under your hangars are removed. Only its own line moves, and the old file is kept as `scenery_packs.ini.homebase_backup`.
- The new scenery order counts from the next X-Plane start.

## First flight
- Load any aircraft. Homebase shows its tablet so you can create an airframe, or you can continue without one.
- An aircraft without a data pack is measured from its 3D models on first load. This takes a few seconds up to a minute.
- Key bindings: all commands are under `homebase/...` in *Settings › Keyboard / Joystick*. Walking uses W A S D by default.
- If you still have the old `FA8X_Walkaround` or `GLF650_Walkaround` plugin in an aircraft folder, delete it. Homebase does everything it did, and stands down for that aircraft while it is there.

## Updating
Unpack the new ZIP over the old one, the same way as installing. Your own data is never overwritten:

| What | Where |
|---|---|
| Airframes, hours, fuel, parking spots | `Output/Homebase/` |
| Your hangars | `Custom Scenery/Private Hangar Homebases/hangars/` and `bases/` (the scenery tiles are rebuilt from them at every start) |
| Your settings | `Resources/plugins/Homebase/Homebase.ini` (the ZIP only brings `Homebase.ini.default`) |
| Your own aircraft packs | `Resources/plugins/Homebase/aircraft/` |
| Your lounge pictures and music | `Resources/plugins/Homebase/fbo_custom/` |

## Uninstall
Delete these two folders:
- `Resources/plugins/Homebase`
- `Custom Scenery/Private Hangar Homebases`

Delete `Output/Homebase` too if you also want to remove your airframes.

## Problems
Send `X-Plane 12/Log.txt` (straight after the problem, before restarting), with the lines starting `Homebase:`, and the steps that led to it.
