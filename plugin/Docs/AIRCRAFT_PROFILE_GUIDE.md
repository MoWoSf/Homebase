# Aircraft profile guide

**For:** an AI assistant (ChatGPT, Claude, Claude Code, Gemini, Kimi, Codex, ...) or a person
who wants the Homebase plugin (FBO, hangar and walkaround for X-Plane 12) to know an aircraft in detail: where its
passenger door and airstair are, its cabin seats, its luggage hold.

**Status:** profile format version 1, as the plugin's reader (`src/profile.c`) reads it. It is
written for the general edition of the plugin (one plugin for every aircraft). The Falcon 8X and
the GLF650 come with the plugin as packs in this format; their numbers are the examples below.

---

## 1. What is automatic and what a profile adds

Without a profile, the general edition measures the aircraft itself when it first loads it. It
reads the 3D models listed in the `.acf` and builds a collision grid of the outside (once per
version of the aircraft; when its models are encrypted or loaded by a plugin, a coarse one from the
`.acf`'s own bodies and wings).

| Feature | Without a profile | With a profile |
|---|---|---|
| Walking round the aircraft (outside) | yes, from the measured grid | the same, with objects to ignore |
| Size check for the hangar (span, length, height) | yes | the same |
| Ground vehicles keeping clear of wings, engines, tail | yes, from the grid | the same |
| Passenger car stop | rough: on the left, about 3 m behind the nose | next to the airstair |
| Airstair walkable | no (a rough find is written into `draft.profile`, section 5) | yes |
| Getting in | a click on the aircraft puts you in the cockpit | walk up the stairs, through the door |
| Getting out | beside the cockpit, on the left (crouching under a high wing) | down the airstair |
| Walking inside the cabin | no | yes |
| Cabin seats (click to sit) | no | yes |
| Luggage van, bags into the hold | no (the phone says so) | yes |
| Door mat at the stairs | no | yes |
| Tow tug | yes, unless it has a tailwheel, a nose tyre outside 0.15–0.38 m radius, more than 90 t or less than 0.57 m under its nose (the remote says which) | the same |

A profile can be partial. Each section in it is optional: a profile with only the door and the
airstair is fine.

---

## 2. Rules for the AI

1. **Read only.** Never change, move or delete any file of the aircraft (`.acf`, `.obj`,
   textures, plugins). Only write the profile file.
2. **Do not guess silently.** Every number in the profile must come from a file you read, from a
   measurement the user made, or be marked in a comment as an estimate:
   `# estimate: no seat OBJ found`.
3. **Show your sources.** In a comment above each section, name the file and what you found
   there, e.g. `# fuselage.obj: ANIM_rotate on sim/flightmodel2/misc/custom_slider_ratio[10]`.
4. **Ask the user** when a choice is not clear, e.g. which of two door datarefs opens the main
   door. The user can check in X-Plane (DataRefTool, or the aircraft's own menu).
5. **Leave out what you cannot find.** A missing section is better than a wrong one.

---

## 3. Where the profile goes

A profile is part of a **data pack**: one folder per aircraft.

```
X-Plane 12/Resources/plugins/Homebase/
    aircraft/                  your own packs: the plugin's updater never touches this folder
        <pack name>/
            <acf file name>.profile    the profile (this guide)
            pack.txt                   about the pack (see below)
            stop_mark.png              planned: the aircraft's own stop mark on the hangar floor
    packs/                     the packs that come with the plugin (Falcon 8X, GLF650); the
                               updater replaces them, so do not edit them there
```

Example: `Falcon8X.acf` → `aircraft/Falcon 8X/Falcon8X.profile`.

To change a pack that came with the plugin, copy its folder from `packs/` to `aircraft/` and edit
the copy. Your copy wins.

**Which pack is used.** When an aircraft is loaded, the plugin looks at the `.profile` files in
the pack folders: first everything in `aircraft/`, then everything in `packs/`. It takes the first
profile that

- names the aircraft's `.acf` file in an `acf` line (capitals do not matter), and
- fits its ICAO type (see 6.1), and
- has no errors.

So a user's own pack wins over a bundled one. Within `aircraft/` (or `packs/`) the pack folders go
in alphabetical order, and a second pack there for the same aircraft is reported and not used. A
profile that is skipped is named in the X-Plane log with the reason; so is the pack that is used.

`pack.txt` holds `key value` lines. All of them are optional; without `name` the pack is called
after its folder.

```
name Falcon 8X (Aerobask)
version 1.0
author <your name>
license CC BY 4.0
aircraft_version Aerobask Falcon 8X 12.0b7   # the aircraft release it was measured on
url https://...                              # where the pack can be found
```

### The file format

- The file is plain text (UTF-8). Write one value per line as `key value(s)`.
- The first line (comments and blank lines aside) is `profile 1`. The other keys can be in any
  order.
- A `#` at the start of a line or after a blank starts a comment.
- Keys marked *repeat* below (`acf`, `seat`, `bag_spot`, `floor_obj`, ...) add one entry each.
  Any other key given twice: the later one counts, with a warning.
- Numbers use a decimal point: `-0.85`, not `-0,85`.
- Names, labels and OBJ paths are the rest of the line and may contain blanks
  (`exterior_obj landing gear.obj`). OBJ paths are relative to the aircraft's `objects/` folder,
  with `/` between folders, exactly as the `.acf` writes them.
- Dataref names and the ICAO type are one word.

What the plugin does with mistakes (each message in the log has the file and the line number):

- **Unknown key:** a warning; the line is ignored.
- **Bad line** (a word where a number belongs, too few or too many numbers): an error.
- **Half a section** (some of its required keys missing, or a section without the one it needs):
  an error that names the missing keys.
- **Any error:** the profile is not used. The plugin tries the next pack for the aircraft (a
  bundled one, if there is one) or runs without a pack.

---

## 4. The frame and the units (read this first)

Every position in the profile is in the **Plane Maker reference frame (REF)**, in **metres**:

- **x** is to the right (seen from the pilot seat). Left is negative, so the usual passenger
  door on the left has a **negative x**.
- **y** is up.
- **z** is towards the tail. Nose is more negative, tail more positive.
- The **origin** is the aircraft's reference point, wherever its author put it. It is **not**
  the nose and not the CG. On the Falcon 8X the nose is near z = -1 m. On the GLF650 the cockpit
  is at z = -11 m. Never assume where 0 is: measure.

### Unit traps

- **`.acf` lengths are in feet.** Multiply by 0.3048. Example: `P acf/_pe_xyz/2 10.1` (ft) is
  3.078 m.
- **OBJ vertex coordinates (`VT x y z ...`) are in metres**, relative to where the `.acf`
  attaches that OBJ.
- **The attachment offset of each OBJ is in the `.acf`, in feet:**
  ```
  P _obja/<n>/_v10_att_file_stl   <path of the OBJ, relative to the aircraft folder's objects/>
  P _obja/<n>/_v10_att_x_acf_prt_ref   <x offset, ft>
  P _obja/<n>/_v10_att_y_acf_prt_ref   <y offset, ft>
  P _obja/<n>/_v10_att_z_acf_prt_ref   <z offset, ft>
  P _obja/<n>/_obj_flags                bits: 1 lit as interior, 16 casts shadows outside, 512 crash model
  ```
  An OBJ with bit 1 and without bit 16 is the cockpit or the cabin; the rest is the outside.
  `_v10_is_internal` is no help: X-Plane 12 `.acf` files hold leftover numbers there.
  The REF position of a vertex is `VT xyz + offset × 0.3048`. The offset is usually 0, but not
  always: the GLF650's OBJs all sit 0.40 ft (0.122 m) lower.
- **Angles:** `yaw` is the direction a person faces. 0 means towards the nose, 180 towards the
  tail, 90 towards the right (+x) and -90 towards the left.

### Values worth reading from the `.acf` (all in feet)

| `.acf` line | Meaning |
|---|---|
| `P acf/_ICAO` | ICAO type as the author wrote it, e.g. `FA8X` (AKD writes `GLF650`) |
| `P acf/_pe_xyz/0..2` | pilot eye point x y z |
| `P acf/_cgY`, `P acf/_cgZ` | centre of gravity height and position |
| `P acf/_h_eqlbm` | height of the CG over the ground, at rest: ground y = `_cgY - _h_eqlbm` |
| `P _gear/<n>/_gear_x/_y/_z` | gear positions (the most forward one is the nose gear) |
| `P _obja/<n>/...` | the attached OBJs (see above) |

---

## 5. Tools

**Start with `draft.profile`.** The first time the plugin loads an aircraft it measures it and
writes what it found into

```
X-Plane 12/Output/Homebase/aircraft/<acf file name without .acf>/draft.profile
```

It is a profile in this format with every finding as a comment or a suggestion (`#> key value`):

- the size (span, length, height), the most forward point, the ground (as used, from the `.acf`,
  from the lowest tyre, from the lowest geometry);
- the nose gear with its wheel and tyre, and the room in front of it;
- every attached OBJ with its flags, how the grid used it, its box **as X-Plane draws it** (with
  the OBJ's own static `ANIM_trans`/`ANIM_rotate` applied) and the datarefs it animates;
- the door-like animations, each opened once, with the new walkable surface on the left, and a
  rough airstair (`door_dref`, `door_index`, `stair_search`, `stair_x`, `stair_scan`) when one
  looks like it.

Ask the user for this file and the `.acf`. Check each suggestion before you take it over.

Coding agents (Claude Code, Codex, Gemini CLI, Kimi CLI, ...) can read the aircraft folder
directly. A chat AI without file access needs the user to upload these files:

- `draft.profile` and the `.acf` file;
- the list of OBJ files: `objects/` and its subfolders;
- the OBJs that matter: fuselage, cabin, seats, doors. Big OBJs are often too large to upload.
  Then ask the user to run the extractor below and paste its output instead.

**Extractor (Python 3), the way without X-Plane.** It prints each attached OBJ with its REF box as
drawn and the animation datarefs it uses: each triangle with the `ANIM_trans`/`ANIM_rotate` it is
under, at the rest pose (gear down, everything else 0). Raw `VT` coordinates are no help: many
OBJs model a part at the origin and move it into place with a static `ANIM_trans` (the Falcon's
wing vertices reach 4.9 m from the centre line, the drawn wing 13 m). Run it from the aircraft
folder: `python extract.py Falcon8X.acf`. A big aircraft takes a minute or more.

```python
import sys, os, re, math
acf = sys.argv[1]
base = os.path.dirname(os.path.abspath(acf))
props = {}
for line in open(acf, encoding="latin-1"):
    if line.startswith("P "):
        parts = line.split(None, 2)
        if len(parts) == 3:
            props[parts[1]] = parts[2].strip()
FT = 0.3048
for k in ("acf/_ICAO", "acf/_cgY", "acf/_cgZ", "acf/_h_eqlbm", "acf/_pe_xyz/0", "acf/_pe_xyz/1", "acf/_pe_xyz/2"):
    print(k, props.get(k))

def rest(dref):   # the value an animation is shown at: the gear down, everything else 0
    return 1.0 if "gear" in dref and "deploy" in dref else 0.0

def lerp(keys, v):   # keys: [(value, x), ...] -> x at v (held at the ends)
    if v <= keys[0][0]: return keys[0][1]
    for (a, x), (b, y) in zip(keys, keys[1:]):
        if v <= b: return x if b == a else x + (y - x) * (v - a) / (b - a)
    return keys[-1][1]

def mul(m, n): return [[sum(m[i][k] * n[k][j] for k in range(4)) for j in range(4)] for i in range(4)]
def trans(x, y, z): return [[1, 0, 0, x], [0, 1, 0, y], [0, 0, 1, z], [0, 0, 0, 1]]
def rot(ax, ay, az, deg):
    l = math.sqrt(ax * ax + ay * ay + az * az) or 1.0
    x, y, z = ax / l, ay / l, az / l
    c, s, t = math.cos(math.radians(deg)), math.sin(math.radians(deg)), 1 - math.cos(math.radians(deg))
    return [[t*x*x + c, t*x*y - s*z, t*x*z + s*y, 0], [t*x*y + s*z, t*y*y + c, t*y*z - s*x, 0],
            [t*x*z - s*y, t*y*z + s*x, t*z*z + c, 0], [0, 0, 0, 1]]

n = 0
while f"_obja/{n}/_v10_att_file_stl" in props:
    rel = props[f"_obja/{n}/_v10_att_file_stl"]
    off = [float(props.get(f"_obja/{n}/_v10_att_{a}_acf_prt_ref", 0)) * FT for a in "xyz"]
    flags = int(props.get(f"_obja/{n}/_obj_flags", "0"))   # (_v10_is_internal is stale in X-Plane 12 .acf files)
    where = "interior" if flags & 1 and not flags & 16 else "exterior"
    path = os.path.join(base, "objects", rel)
    lo, hi, drefs = [1e9] * 3, [-1e9] * 3, set()
    if os.path.exists(path):
        vt, idx = [], []
        m, stack, kf = trans(*off), [], None
        for line in open(path, encoding="latin-1"):
            w = line.split()
            if not w: continue
            c = w[0]
            if c == "VT": vt.append([float(w[1]), float(w[2]), float(w[3])])
            elif c in ("IDX", "IDX10"): idx.extend(int(i) for i in w[1:])
            elif c == "ANIM_begin": stack.append(m)
            elif c == "ANIM_end": m = stack.pop() if stack else trans(*off)
            elif c == "ANIM_trans" and len(w) >= 7:   # x1 y1 z1 x2 y2 z2 [v1 v2 dref]; without them it stands still
                d = w[9] if len(w) > 9 else "none"
                v = [float(t) for t in w[1:7]] + ([float(w[7]), float(w[8])] if len(w) > 8 else [0.0, 0.0])
                t = 0.0 if v[7] == v[6] else max(0.0, min(1.0, (rest(d) - v[6]) / (v[7] - v[6])))
                m = mul(m, trans(*[v[i] + (v[3 + i] - v[i]) * t for i in range(3)]))
                if d != "none": drefs.add(d)
            elif c == "ANIM_rotate" and len(w) >= 6:  # x y z r1 r2 [v1 v2 dref]
                d = w[8] if len(w) > 8 else "none"
                v = [float(t) for t in w[1:6]] + ([float(w[6]), float(w[7])] if len(w) > 7 else [0.0, 0.0])
                t = 0.0 if v[6] == v[5] else max(0.0, min(1.0, (rest(d) - v[5]) / (v[6] - v[5])))
                m = mul(m, rot(v[0], v[1], v[2], v[3] + (v[4] - v[3]) * t))
                if d != "none": drefs.add(d)
            elif c in ("ANIM_trans_begin", "ANIM_rotate_begin"):
                kf = (c, w[1:4], w[-1], [])
                drefs.add(w[-1])
            elif c in ("ANIM_trans_key", "ANIM_rotate_key") and kf:
                kf[3].append([float(t) for t in w[1:]])
            elif c in ("ANIM_trans_end", "ANIM_rotate_end") and kf and kf[3]:
                keys, v = sorted(kf[3]), rest(kf[2])
                if kf[0] == "ANIM_trans_begin":
                    m = mul(m, trans(*[lerp([(k[0], k[1 + i]) for k in keys], v) for i in range(3)]))
                else:
                    m = mul(m, rot(*[float(t) for t in kf[1]], lerp([(k[0], k[1]) for k in keys], v)))
                kf = None
            elif c in ("ANIM_show", "ANIM_hide", "ATTR_manip_command", "ATTR_manip_axis_knob", "ATTR_manip_drag_axis") and len(w) > 1:
                drefs.update(re.findall(r"[A-Za-z0-9_]+/[A-Za-z0-9_/\[\]]+", line))
            elif c == "TRIS":
                a, k = int(w[1]), int(w[2])
                for i in idx[a:a + k]:
                    p = vt[i]
                    for j in range(3):
                        q = m[j][0] * p[0] + m[j][1] * p[1] + m[j][2] * p[2] + m[j][3]
                        lo[j] = min(lo[j], q); hi[j] = max(hi[j], q)
        box = " ".join(f"{a:.2f}..{b:.2f}" for a, b in zip(lo, hi)) if lo[0] < 1e8 else "(draws nothing)"
    else:
        box = "(missing: encrypted, or loaded by a plugin)"
    print(f"\n[{n}] {rel}  {where} (flags {flags})  offset_m={off}\n    REF box x,y,z as drawn: {box}")
    for d in sorted(drefs):
        print("    dref", d)
    n += 1
```

It gives the same boxes as `draft.profile` (checked on the Falcon 8X and the GLF650). What it does
not do: the gear at its real strut compression, kill datarefs, `ANIM_hide`/`ANIM_show`, more than
one LOD. For those `draft.profile` is right, the extractor only close.

**Measuring in X-Plane:** this is planned for the general edition, not there yet. A "Profile"
page on the tablet will show where the walker stands, as REF x y z and heading. Then you can stand
on a seat, at the door sill or at the foot of the stairs and read the numbers off.

---

## 6. The profile, section by section

Each section lists its keys. **Required** keys must all be there once the section is used at all;
**optional** ones have the default named.

### 6.1 Header (required)

```
profile 1                 # always the first line
acf Falcon8X.acf          # the .acf file this profile is for (repeat)
name Falcon 8X            # how the phone and the tablet call the type
icao FA8X                 # the ICAO type designator
legacy_cmd_prefix FA8X/walkaround   # optional: the prefix of a plugin the aircraft had before (Homebase stands down while it runs)
```

- **Required:** `profile`, `acf`, `name`.
- **`acf`** (*repeat*): one line per `.acf` file that shares these 3D models, e.g. the GLF650 and
  the GLF650ER. Name the file `<first acf name>.profile`.
- **`icao`:** the real ICAO type designator (`FA8X`, `GLF6`). VATSIM flight plans and the hangar's
  stop mark go by it. Without it, the ICAO check below is skipped (a warning).
- **`acf_icao`** (optional, *repeat*): what the `.acf` says in `P acf/_ICAO`, when that is not
  `icao`. AKD's GLF650 writes `GLF650` and `GLF650ER`, its designator is `GLF6`:
  ```
  icao GLF6
  acf_icao GLF650
  acf_icao GLF650ER
  ```
  The plugin compares the loaded `.acf`'s `acf/_ICAO` with `icao` and the `acf_icao` lines. If none
  fits, the profile is for some other aircraft with the same file name and is not used.
- **`board_name`** (optional): how the FBO's departure board writes the type. Default: `name` in
  capitals. Example: `board_name GULFSTREAM G650`.
- **`legacy_cmd_prefix`** (optional) is for aircraft that had a plugin of their own before (FA8X,
  GLF650). It tells that plugin by its signature: while it runs, Homebase stands down for the
  aircraft. The commands are always `homebase/...` only; old names are not kept. A new profile
  leaves it out.
- **`door_mat`** (optional): one of the plugin's own door mats in `Homebase/mat/` to lie at the foot
  of the airstair. Default: the plain mat. Only the Falcon 8X has one of its own
  (`fa8x_doormat.obj`, with its logos). A livery's `*doormat*` picture is woven into the mat either
  way. Without an airstair (6.3) there is no door mat.

### 6.2 The collision grid (optional)

The general edition builds the outside grid from **all** attached OBJs. Add lines here only to
fix what it gets wrong.

```
ignore_obj devices/Falcon8X_cockpit.obj   # invisible click planes: would be walls (repeat)
exterior_obj fuselage.obj                 # if given: ONLY these OBJs make the outside grid (repeat)
obj_offset 0 -0.12192 0                   # where the .acf attaches the OBJs: x y z in metres
grid_box -14.0 -4.0 14.0 26.0             # the grid's corners: x z from, x z to
ground_y -1.537                           # the ground under the wheels at rest (y)
```

- **`ignore_obj`:** look for OBJs that are invisible but solid. Typical cases are click or
  manipulator panels (many `ATTR_manip` lines, `ATTR_draw_disable`), ground equipment that is
  hidden by default (chocks, cones, GPU, covers, ladders with `ANIM_hide`), pilots and glass.
- **`exterior_obj`:** list the OBJs that make up the real outside: fuselage, wings, engines,
  tail, gear. With this list the grid is built at the rest pose (gear down, every other animation
  at 0), as the pack's numbers were measured, so it comes out the same each time. Without it the
  plugin takes every attached OBJ and the animations as they stand in X-Plane when the aircraft
  loads (doors and stairs shut).
- **`obj_offset`:** the `_v10_att_*_acf_prt_ref` offset of the OBJs in this profile's lists, × 0.3048.
  Default `0 0 0`. Give it when the `.acf` attaches them elsewhere: the GLF650's hang 0.40 ft
  lower, `0 -0.12192 0`.
- **`grid_box`:** the area the grid covers, in cells of 0.05 m: x from, z from, x to, z to. Make the
  sizes whole cells (a warning otherwise) and keep it under 200 m a side. Default: sized to the
  measured aircraft. The box must hold the wings, the tail and the opened airstair, with a few
  metres to spare.
- **`ground_y`:** default `(_cgY - _h_eqlbm) × 0.3048` from the `.acf`. Give it when the wheels
  really stand elsewhere: on the Falcon 8X the `.acf` gives -1.477, the measured ground is -1.537.
- **`grid_preview`** (developer only, leave it out): the area of the grid builder's text preview,
  `x_from x_to z_from z_to door_row_z blockers_z_from blockers_z_to`.

### 6.3 Passenger door and airstair

```
door_dref sim/flightmodel2/misc/custom_slider_ratio   # the dataref that animates the main door
door_index 10                                          # its array index (leave out if not an array)
door_closed 0                                          # its value when shut
door_open 1                                            # its value when fully open
door_obj fuselage.obj                                  # the OBJ(s) holding the door/airstair animation (repeat)
stair_search -2.0 0.5      # y range (REF) in which the opened stair's treads lie
stair_x -1.4               # stair cells further out (more negative x) than this count as its length
stair_scan -1.6            # the door sill is searched from the centre line out to this x
stair_foot -1.9 2.2        # x z of the foot of the stairs (fallback if the grid finds none)
```

- **The door:** required `door_dref`. Optional `door_index` (none: not an array), `door_closed`
  (default 0), `door_open` (default 1), `door_obj`.
- **The airstair:** required `stair_search`, `stair_x`, `stair_scan`, `stair_foot`, and at least
  one `door_obj`. It needs the door.

How to find these:

- **`door_dref`:** `draft.profile` lists the door-like animations it tried, the one that looks like
  an airstair marked `*`. Else, in the extractor output, look for datarefs used by `ANIM_rotate`/`ANIM_trans`
  in the fuselage or door OBJ. Look for names with `door`, `stair` or `slider`. Aerobask uses
  `sim/flightmodel2/misc/custom_slider_ratio[n]`, AKD uses `AKD/anim/door/main_door_ratio`, and
  X-Plane's default aircraft use `sim/flightmodel2/misc/door_open_ratio[n]`. If several fit, ask
  the user to toggle the door in X-Plane and watch them in DataRefTool. Write the name without the
  `[n]`; the index goes into `door_index`.
- **`door_closed` / `door_open`:** the two key values of that animation, from the
  `ANIM_*_key` lines.
- **`stair_foot`:** where the lowest step meets the ground with the door open. Take it from the
  door OBJ's geometry at the open key frame, or measure it in X-Plane.
- **No airstair** (an airliner at a gate or with external stairs): leave out the `stair_*`
  lines. The car then stops near the door, and boarding is a click.

### 6.4 Cabin walking (optional, needs the airstair of 6.3)

```
floor_obj cabin/carpet.obj       # OBJs whose upward faces are the cabin floor (repeat)
interior_obj seats.obj           # OBJs that are obstacles inside: walls, galley, seats (repeat)
seat_obj 1 seats.obj             # seat furniture: kind (1 pilot, 2 cabin, 3 divan) and OBJ (repeat)
floor_range -0.35 0.62           # floor surfaces are searched between these heights (y)
floor_default 0.30               # the floor height where no surface is found
cabin_box 1.15 1.6 16.8          # half width (|x|), z from, z to: where a cabin floor can be
seat_eye_height 1.12             # eye over the floor when sitting in a cabin seat
cabin_voice 0 1.0 10.5           # x y z where arrival chatter plays in the cabin
```

- **Required:** `floor_obj`, `floor_range`, `floor_default`, `cabin_box`.
- **Optional:** `interior_obj`, `seat_obj`, `seat_eye_height` (default 1.10), `cabin_voice`
  (default: x 0, y `floor_default` + 0.70, z the middle of `cabin_box`).

How to find these:

- **`floor_range`:** cockpit and cabin floor height, ±0.4 m. Find large, nearly flat surfaces in
  the cabin OBJ (`VT` lines with the same y over a long z range).
- **`cabin_box`:** the cabin's inner half width and its z from the cockpit's back wall to the aft
  bulkhead.
- **`seat_obj`:** OBJs that hold the seats (list them as `interior_obj` too). Inside the grid
  they get a smaller body radius than walls, so the aisle between them stays walkable, and the
  grid builder can find seat places in them. Where the seats are merged into a big cabin OBJ,
  leave them out and write the `seat` lines by hand (6.5).

### 6.5 Seats (optional, needs 6.4)

One line per seat (*repeat*, at most 64):

```
seat <kind> <xmin> <xmax> <zmin> <zmax> <ytop> <eye_x> <eye_y> <eye_z> <yaw>
```

| Field | Meaning |
|---|---|
| `kind` | 1 pilot seat, 2 cabin seat, 3 divan (sofa) place |
| `xmin xmax zmin zmax` | the seat's footprint seen from above (the area that can be clicked) |
| `ytop` | the seat's highest point (head rest) |
| `eye_x eye_y eye_z` | where the eyes are when sitting: above the middle of the cushion, `eye_y` = cushion top + 0.70 |
| `yaw` | the direction the sitter faces (0 nose, 180 tail, 90 right, -90 left) |

Notes:

- **Pilot seats (kind 1):** the plugin uses X-Plane's own eye point (`acf/_pe_xyz`). Only the
  footprint and `ytop` matter for them.
- **Finding the seats:**
  - Often they are in an OBJ of their own (`seats.obj`, `cabin_seats.obj`, `Cockpit_Seats.obj`).
    Cluster its vertices in a top view (x, z). Each cluster is a seat, and its bounding box is the
    footprint.
  - The cushion top is the most common y among the cluster's upward faces, at about 0.45 m above
    the floor.
  - Seats facing each other in club layouts are common, so check the yaw. The back rest is on the
    side the sitter does not face.
- **Divans along the wall:** add one place per 0.8 m of length. Their yaw faces the aisle: 90 for
  a divan on the left wall, -90 for one on the right wall.

### 6.6 Luggage hold (optional)

This section is needed only for the luggage van and the bags. It describes the hold's door and
its inside, which is a box. All values are in metres, REF.

```
luggage_label Luggage door left aft                   # how the phone names it
luggage_dref aerobask/sliders/luggage_door            # the hold door's animation, 0 shut .. 1 open
luggage_switch aerobask/sliders/luggage_door_switch   # what the aircraft's own click spot sets (0/1); leave out if none
luggage_door -0.85 18.0      # x z of the door's middle, on the skin
hold_wall_x -0.06            # inner wall across from the door: where the lying suitcases' wheels are
hold_mid_x -0.42             # the middle of the hold across
hold_ceil 1.07               # the hold's ceiling (y)
hold_z 17.555 18.495         # forward and aft wall of the hold (z)
hold_floor 0.01 17.6 0.21    # floor y at z0, z0, rise per metre aft (0 if level)
hold_skin -0.75 17.45 -0.114 # the skin round the door: x at z0, z0, change of x per metre aft
hold_box -1.05 -0.05 17.40 -0.02 1.12 18.58   # the door opening for clicks: x y z low, x y z high
door_slide 0.65              # a bag moves this far along x between its place and outside the door
hold_door_top 99             # top of the door opening (y): bags stacked higher go in below it (99 = no limit)
door_push 0                  # 1 = a bag goes straight through the middle of the opening, then to its place
van_stop -4.30 17.30         # where the van's rear axle line stops: x, and z of its rear bumper
bag_spot -2.10 17.42         # x z on the ground next to the door for unloaded bags (repeat, 6..12 spots)
```

- **Required:** `luggage_dref`, `luggage_door`, `hold_wall_x`, `hold_mid_x`, `hold_ceil`,
  `hold_z`, `hold_floor`, `hold_skin`, `hold_box`, `door_slide`, `van_stop`, at least one `bag_spot`.
- **Optional:** `luggage_label` (default "Luggage door"), `luggage_switch` (none),
  `hold_door_top` (99), `door_push` (0). More than 12 bag spots: the rest are ignored (a warning).

How to find these:

- **Hold door:** find it the same way as the passenger door: its own dataref, usually a separate
  animated part of the fuselage OBJ. Its opening gives `luggage_door` and `hold_box`.
- **Inside of the hold:** read it from the hold OBJ (`Baggage Compartment.obj` and similar) or
  from the inside faces of the fuselage near the door.
- **`van_stop`:** about 3–4 m out from the skin (x), with the rear bumper level with the front of
  the door.
- **`bag_spot`:** a grid of spots 1.2–2.5 m out from the door, 0.6 m apart, clear of the gear and
  the flaps.

### 6.7 Places (optional, worked out automatically if left out)

```
center_z 10.0        # the middle of the aircraft: vehicles slow down near it
fbo_z 12.0           # the FBO lounge is set up above this z
hangar_stop_z 3.4    # z of the nose gear on the hangar's stop mark (default: so the aircraft is centred)
```

### 6.8 Refuelling (optional: without it there is no fuel truck)

```
fuel_door_dref aerobask/sliders/fuel_door          # the refuelling panel's door, 0 shut .. 1 open
fuel_door_switch aerobask/sliders/fuel_door_switch # what opens and shuts it (written 0/1)
fuel_port 1.120 -0.143 16.678 0.898 -0.349 0.269   # the adaptor (x y z) and the way it faces (unit vector)
tanker_stop 4.5 23.0 90                            # the fuel truck's rear axle (x z) and heading (degrees)
tanker_keepout 0.5 14.5 7.0 20.5                   # x0 x1 z0 z1: too low for the truck (wing, engine), mirrored
hose_avoid 3.60 17.83 1.30                         # x z r: something on the ground the hose goes round
```

- **`fuel_port`:** the nozzle's face goes onto this point; the last three numbers point out of the
  aircraft, the way the nozzle comes in from.
- **`tanker_stop`:** the truck is 3.45 m high, 2.9 m wide and reverses in: put it where nothing
  low (wing, engine, tail) is above it, with its left side (the hose reel) towards the port.
- **`hose_avoid`:** optional, one circle: equipment the aircraft puts on the ground by itself, such
  as its own GPU cart. A sound attachment in the aircraft's `.snd` file often gives its place
  (`VEH_XYZ` is from the CG: add `_cgZ` in metres to z).

---

## 7. Plausibility checks before you hand the profile over

- **Door side:** a door on the left has a negative x. The usual size is |x| ≈ half the fuselage
  width, 0.8–2.0 m.
- **Order along z:** the door and the pilot seats lie between the nose and the wing. The luggage
  door on a bizjet is usually aft of the wing. Check against `_gear` (nose gear forward) and the
  OBJ boxes.
- **Seats:**
  - Every cabin seat lies inside `cabin_box`.
  - `eye_y` is 1.0–1.3 m above the floor.
  - No two footprints overlap.
- **Stairs:** the foot of the stairs is 1.5–3.5 m out from the door, and its y is near the
  ground (`_cgY - _h_eqlbm`, in metres).
- **Units:** if numbers are about 3.3 times too large, they are feet. Convert them.
- **Sources:** every section has a comment naming its source file.
- **In X-Plane:** the log (`Log.txt`) names the pack in use and every warning and error with its
  line number. A profile with an error is not used.

---

## 8. Example: Falcon 8X (Aerobask)

The complete Falcon 8X profile, as it comes with the plugin
(`packs/Falcon_8X/Falcon8X.profile`). These are the values the Falcon 8X edition had built in.

```
# Aerobask Falcon 8X. The values FA8X Walkaround and FA8X Hangar have built in:
# src/acft.c, tools/mkgrid.c (its FA8X config) and the FA8X_Walkaround.seats mkgrid wrote.

profile 1
acf Falcon8X.acf
name Falcon 8X              # the departure board says FALCON 8X (board_name left out: name in capitals)
icao FA8X                   # Falcon8X.acf: P acf/_ICAO FA8X
legacy_cmd_prefix FA8X/walkaround
door_mat fa8x_doormat.obj   # the door mat with the Falcon's and Aerobask's logos (Homebase/mat/)

# ---- 6.2 collision grid
# devices/Falcon8X_cockpit.obj holds the invisible click planes of the controls: they would be walls
ignore_obj devices/Falcon8X_cockpit.obj
# the outside: fuselage, wings, engines, tail, gear
exterior_obj fuselage.obj
exterior_obj wings.obj
exterior_obj engines.obj
exterior_obj hstab.obj
exterior_obj gear.obj
obj_offset 0 0 0                     # Falcon8X.acf attaches every OBJ at 0 0 0
grid_box -14.0 -4.0 14.0 26.0        # 560 x 600 cells
ground_y -1.537                      # measured; the .acf's _cgY - _h_eqlbm gives -1.477, 6 cm too high
grid_preview -2.4 1.4 1.5 17.0 4.3 12.3 16.75

# ---- 6.3 passenger door and airstair
# fuselage.obj: door and airstair on custom_slider_ratio[10] (Custom_Slider_Lights_information.txt)
door_dref sim/flightmodel2/misc/custom_slider_ratio
door_index 10
door_closed 0
door_open 1
door_obj fuselage.obj
stair_search -2.0 0.5
stair_x -1.4
stair_scan -1.6
stair_foot -1.9 2.2

# ---- 6.4 cabin walking
floor_obj cabin/carpet.obj
floor_obj int8.obj
floor_obj int5.obj
floor_obj int4.obj
floor_obj cabin/cabin1.obj
floor_obj fuselage.obj
interior_obj overhead.obj
interior_obj int8.obj
interior_obj int5.obj
interior_obj int4.obj
interior_obj pedestalAP.obj
interior_obj gp_cas.obj
interior_obj seats.obj
interior_obj cabin/cabin1.obj
interior_obj cabin/cabin2.obj
interior_obj cabin/wood1.obj
interior_obj cabin/wood2.obj
interior_obj cabin/cabin_seats.obj
interior_obj cabin/divans.obj
interior_obj cabin/cabin_misc.obj
interior_obj fuselage.obj
seat_obj 1 seats.obj                 # pilot seats
seat_obj 2 cabin/cabin_seats.obj     # club seats
seat_obj 3 cabin/divans.obj
floor_range -0.35 0.62
floor_default 0.30
cabin_box 1.15 1.6 16.8
seat_eye_height 1.12
cabin_voice 0 1.0 10.5

# ---- 6.5 seats: found by mkgrid in seats.obj, cabin/cabin_seats.obj and cabin/divans.obj
#    kind xmin   xmax   zmin   zmax   ytop   eye_x  eye_y  eye_z  yaw
seat 1 -0.700 -0.100  2.500  3.450 1.686  -0.400 1.589  2.933    0
seat 1  0.100  0.750  2.500  3.800 1.686   0.425 1.599  3.193    0
seat 2 -1.050 -0.300  7.100  8.050 1.372  -0.675 1.512  7.592  180
seat 2  0.300  1.050  7.100  8.050 1.372   0.675 1.512  7.592  180
seat 2 -1.050 -0.300  8.700  9.650 1.372  -0.675 1.507  9.166    0
seat 2  0.300  1.050  8.700  9.650 1.372   0.675 1.507  9.166    0
seat 2 -1.050 -0.425  9.700 10.750 1.372  -0.737 1.503 10.240  180
seat 2 -0.425  0.200  9.700 10.750 1.372  -0.112 1.503 10.240  180
seat 2 -1.050 -0.425 11.300 12.300 1.372  -0.737 1.506 11.798    0
seat 2 -0.425  0.200 11.300 12.300 1.372  -0.112 1.506 11.798    0
seat 3 -1.200 -0.350 12.700 13.500 1.136  -0.820 1.472 13.100   90
seat 3 -1.200 -0.350 13.500 14.300 1.136  -0.820 1.472 13.900   90
seat 3 -1.200 -0.350 14.300 15.100 1.136  -0.820 1.472 14.700   90
seat 3  0.350  1.200 12.700 13.500 1.136   0.820 1.472 13.100  -90
seat 3  0.350  1.200 13.500 14.300 1.136   0.820 1.472 13.900  -90
seat 3  0.350  1.200 14.300 15.100 1.136   0.820 1.472 14.700  -90

# ---- 6.6 luggage hold
# fuselage.obj, measured with rays: the door on the left at x -0.85, the floor rising aft, the
# ceiling level. The inner wall is at about 0 in the middle but curves in to -0.11 near floor
# and ceiling; the forward wall is at 17.40 by the door, 17.55 at the inner wall, the aft
# wall at 18.50. Door animation aerobask/sliders/luggage_door, its click spot sets
# aerobask/sliders/luggage_door_switch.
luggage_label Luggage door left aft
luggage_dref aerobask/sliders/luggage_door
luggage_switch aerobask/sliders/luggage_door_switch
luggage_door -0.85 18.0
hold_wall_x -0.06
hold_mid_x -0.42
hold_ceil 1.07
hold_z 17.555 18.495
hold_floor 0.01 17.6 0.21
hold_skin -0.75 17.45 -0.114
hold_box -1.05 -0.05 17.40 -0.02 1.12 18.58
door_slide 0.65
hold_door_top 99
door_push 0
van_stop -4.30 17.30
bag_spot -2.10 17.42
bag_spot -2.10 18.62
bag_spot -2.10 16.82
bag_spot -2.75 17.15
bag_spot -2.10 19.22
bag_spot -2.75 17.80
bag_spot -2.75 18.45
bag_spot -2.10 16.22
bag_spot -2.75 16.50
bag_spot -2.75 19.10
bag_spot -3.40 16.80
bag_spot -3.40 16.15

# ---- 6.7 places
center_z 10.0
fbo_z 12.0

# ---- 6.8 refuelling
# misc/refueling.obj: the single point panel on the right rear fuselage, aft of the wing fairing; its
# adaptor cap 0.13 m inside the skin (x 1.30), about 1.40 m above the ground, facing out, down and aft.
# Its door aerobask/sliders/fuel_door (2 s), opened and shut by aerobask/sliders/fuel_door_switch.
# The fuel truck (3.45 m high) cannot go under the wing or the engine (2.47 m): it stands across
# behind the right engine, nose out, its hose reels (left side) towards the aircraft.
fuel_door_dref aerobask/sliders/fuel_door
fuel_door_switch aerobask/sliders/fuel_door_switch
fuel_port 1.120 -0.143 16.678 0.898 -0.349 0.269
tanker_stop 4.5 23.0 90
tanker_keepout 0.5 14.5 7.0 20.5
# Aerobask's GPU (shown from the EFB): its running sound sits at x 3.60, z 17.83 (fmod/Falcon8X.snd, CG
# 13.01 m aft), the cart 1.3 x 1.95 m. The hose is laid round it.
hose_avoid 3.60 17.83 1.30
```

Its `pack.txt`:

```
name Falcon 8X (Aerobask)
version 1.0
author MoWoSf
aircraft_version Aerobask Falcon 8X 12.0b7   # measured on it; the values of FA8X Walkaround 1.5
```

The GLF650 pack (`packs/GLF650/GLF650_AKD.profile`) shows the other cases: two `.acf` files with
`acf_icao`, an `obj_offset`, a door dataref that is not an array, hand-measured seats, and a hold
that bags go into through the middle of the door (`door_push 1`).

---

## 9. A prompt to start with

The easiest way: load the aircraft in X-Plane and choose **Plugins > Homebase > AI profile kit for this
aircraft ...**. It writes a folder (`Output/Homebase/aircraft/<acf>/ai_kit`) with `AI_PROMPT.txt` (this
prompt, filled in with the aircraft), this guide, the `draft.profile` Homebase measured and the bundled
packs as examples, and opens it. Or write the prompt yourself:

Paste this into the AI of your choice, together with this guide and the files from section 5:

> You are writing an aircraft profile for the X-Plane 12 plugin Homebase. Follow the attached
> AIRCRAFT_PROFILE_GUIDE.md exactly. The aircraft is `<name>`; its .acf is `<file>`. Read only,
> change no file of the aircraft. Work out sections 6.1–6.8 as far as the files allow. Put the
> source of every section in a comment, mark estimates as such, and ask me when a choice is not
> clear (for example which dataref opens the main door). Finish with the checks of section 7 and
> give me the complete `.profile` file and a `pack.txt`.
