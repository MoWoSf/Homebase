# Homebase – Installation

## Requirements
- X-Plane 12 (12.1 or newer)
- Windows 64-bit (this beta has no macOS or Linux build yet)

## Download
Get `Homebase_beta_2026-10-29.zip` from the [Releases](https://github.com/MoWoSf/Homebase/releases) page of this repository (about 680 MB).

## Install
1. Close X-Plane.
2. Unpack `Homebase_beta_2026-10-29.zip` straight into your **X-Plane 12 folder**, and let it merge with what is already there. You then have:
   - `X-Plane 12/Resources/plugins/Homebase/`: the plugin
   - `X-Plane 12/Custom Scenery/Private Hangar Homebases/`: the hangar models
3. New install only: in `Resources/plugins/Homebase/`, rename `Homebase.ini.default` to `Homebase.ini`. Without it the built-in defaults are used.
4. Start X-Plane once, then quit. X-Plane adds the new scenery pack to `Custom Scenery/scenery_packs.ini`.
5. Open `scenery_packs.ini` and move the line `SCENERY_PACK Custom Scenery/Private Hangar Homebases/` **above** your airport sceneries and above `*GLOBAL_AIRPORTS*`. Otherwise buildings under your hangars are not removed. The tablet warns you when the order is wrong.
6. Remove the old per-aircraft plugins if you have them:
   - `Aircraft/<Falcon 8X>/plugins/FA8X_Walkaround`
   - `<GLF650>/plugins/GLF650_Walkaround`

   Homebase does all of it now and stands down while an old one is loaded.

## First flight
- Load any aircraft. Homebase shows its tablet so you can create an airframe, or you can continue without one.
- An aircraft without a data pack is measured from its 3D models on first load. This takes a few seconds up to a minute.
- Key bindings: all commands are under `homebase/...` in *Settings › Keyboard / Joystick*. Walking uses W A S D by default.

## Updating
Unpack the new ZIP over the old one, the same way as installing. Your own data is never overwritten:

| What | Where |
|---|---|
| Airframes, hours, fuel, parking spots | `Output/Homebase/` |
| Your hangars | `Custom Scenery/Private Hangar Homebases/hangars/` and `bases/` (the scenery tiles are rebuilt from them at every start) |
| Your settings | `Resources/plugins/Homebase/Homebase.ini` (the ZIP only brings `Homebase.ini.default`) |
| Your own aircraft packs | `Resources/plugins/Homebase/aircraft/` |
| Your lounge pictures and music | `Resources/plugins/Homebase/fbo_custom/` |

The ZIP contains none of these. Do not delete the folders above when updating.

## Uninstall
Delete these two folders:
- `Resources/plugins/Homebase`
- `Custom Scenery/Private Hangar Homebases`

Delete `Output/Homebase` too if you also want to remove your airframes.

## Problems
Send `X-Plane 12/Log.txt` (straight after the problem, before restarting), with the lines starting `Homebase:`, and the steps that led to it.
