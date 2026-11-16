# Homebase for X-Plane 12: features

Homebase is one global plugin (`Resources/plugins/Homebase`) for every aircraft you fly. It gives you
an FBO lounge to start in and a private hangar at your home airports. Ground services come to the
aircraft, and you can walk round it.

It sets itself up for each aircraft as that aircraft loads. A **data pack** adds the details: the
airstair, the cabin, the seats, the luggage hold and the refuelling point. Without a pack, Homebase
measures the aircraft from its 3D models and guesses the rest.

Windows 64-bit. Beta: please report what you see on the Discord, with your `Log.txt`.

---

## Aircraft with a data pack (bundled)

| Aircraft | Pack | What the pack adds |
|---|---|---|
| **Dassault Falcon 8X** (Aerobask, 12.0b7) | `packs/Falcon_8X` | Airstair and door, cabin walking, all cabin seats, luggage hold with its door, refuelling point with its panel, GPU cart the hose goes round, door mat |
| **Gulfstream G650 / G650ER** (AKD Studio GLF650 v1.07) | `packs/GLF650` | Airstair and door, cabin walking, cabin seats, luggage hold with its door, door mat (refuelling point guessed) |

Every other aircraft works **without a pack** (see below). Your own packs go into
`Resources/plugins/Homebase/aircraft/<pack>/` and win over the bundled ones. The updater never
touches that folder.

### Making a pack for another aircraft (with an AI)

**Plugins > Homebase > AI profile kit for this aircraft ...** writes a folder for the aircraft
loaded (`Output/Homebase/aircraft/<acf>/ai_kit`) and opens it. The folder holds:

- `AI_PROMPT.txt`: the prompt, filled in with this aircraft's name, `.acf`, folder and measured size;
- `AIRCRAFT_PROFILE_GUIDE.md`: the format specification, written for AI assistants;
- `draft.profile`: what Homebase measured by itself (dimensions, a rough door and airstair, OBJ boxes);
- `example_*.profile`: the bundled Falcon 8X and GLF650 packs as worked examples.

Paste the prompt into Claude, ChatGPT, Gemini or similar and attach the files. An assistant that can
read your disk (Claude Code, Codex) reads the aircraft folder itself. Put the result into
`Resources/plugins/Homebase/aircraft/<pack>/` and reload the aircraft.

---

## Which aircraft Homebase is for

- **On** for business jets, turboprops and general aviation.
- **Off** for airliners, cargo and military aircraft (Plane Maker's category) and above 60 t max
  take-off weight. The settings are `skip_categories` and `skip_above_t` in `Homebase.ini`.
- **Always on** for an aircraft with a data pack.
- **Plugins > Homebase > Active for this aircraft** turns it on or off for the aircraft loaded,
  whatever the filter says. The choice is kept per aircraft.
- If the aircraft's own walkaround plugin is loaded (FA8X / GLF650 Walkaround), Homebase steps aside.

| | Without a data pack | With a data pack |
|---|---|---|
| Walking round the aircraft | yes (measured collision grid) | yes |
| Hangar size check | yes (span, length, height) | yes |
| Vehicles keep clear of wings, engines, tail | yes | yes |
| Getting in | click the aircraft: into the cockpit | up the airstair, through the door |
| Cabin walking, cabin seats | no | yes |
| Luggage van | stops at the rear left, the bags disappear into the aircraft | bags go into the real hold |
| Fuel truck | rear right, the refuelling point guessed from the shape | the real refuelling point and panel |
| Tow tug | yes, unless tailwheel, > 90 t, nose tyre outside 0.15–0.38 m, < 0.57 m under the nose | the same |

---

## Start: FBO, hangar or as X-Plane put you

Each airframe has its own start. You choose it on the tablet:

- **Hangar + FBO**: in your own hangar, upstairs at the bar, when the aircraft stands there.
- **FBO only**: in the lounge, the aircraft on the apron. This is the default for an aircraft that
  fits none of the hangars.
- **None**: as X-Plane loaded it.

---

## FBO lounge

- Reception with the business jet mural, a VIP lounge with bar, buffet and chandeliers, the crew room
  (briefing table, computers, clocks for UTC and local time), washrooms, security, and the airside
  waiting room with the door to the aircraft.
- **Departure board**: with VATSIM connected, the business jets filed out of your airport.
- **Screens**: weather map, ATIS and your SimBrief OFP. They look for new data every 3 s.
- The briefing room computer opens SimBrief in your browser.
- **Your own touch**:
  - a brass sign over the reception, written on the phone;
  - your pictures on the runner and the TV, and your own music, from `fbo_custom`;
  - your livery's `*doormat*` picture woven into the door mat.
- Real lights at night.
- Click the **Airside** door. Your car drives you to the aircraft and you
  get out at the airstair.

---

## Ground services (phone > Services)

- **Luggage van**: brings your bags and loads them into the hold. Its load space
  lights up at night.
- **Passenger car**: takes you to the aircraft. "Pick me up" brings it back to the stairs and drives
  you to the lounge.
- **Turnaround**: after collecting, van and car bring new bags and passengers once your next
  SimBrief plan from this airport is in.
- **Fuel truck** (X-Plane's Jet A truck):
  - Order how much fuel you want aboard: in steps, your SimBrief ramp fuel, or full. Order on the
    phone or with the clipboard on the FBO's reception counter.
  - The truck comes when the aircraft is parked with its engines off, outside the hangar.
  - Its attendant walks the hose out, couples the nozzle on by hand, waits, and rolls the hose back up.
  - **Fuelling time** (phone > Settings): Realistic (600 kg a minute), Fast (10 times as fast), or
    Instant (no truck: the fuel is aboard at once).
  - **Fuel units**: kg, lb, litres or US gallons.
- Vehicles use the airport's service roads and keep to their lane (on the left where traffic
  drives on the left). They keep clear of your aircraft and of parked AI and multiplayer aircraft.

---

## Private hangars (homebases)

- **Four sizes**, each with its own design:

  | Size | Door | Built for |
  |---|---|---|
  | **L** | 36 × 9 m | Falcon 8X, G650 |
  | **M** | 26 × 7.5 m | Challenger class |
  | **S** | 20.8 × 6.2 m | Phenom 300 class |
  | **XS** | about 14 × 3.4 m | SR22, C172 |

- Place one **anywhere** with the tablet's homebase map:
  - Buildings, fences and walls of the airport's scenery under it are removed.
  - It can stand **levelled** on its own foundation.
  - Homebase writes the scenery tiles itself. Restart X-Plane after placing or moving a hangar.
- **Fit check**: Homebase measures span, length and height and tells you which hangars the
  aircraft fits.
- Each hangar has its own **door and lights**: phone > Hangar app, or the commands
  `homebase/hangar_door`, `hangar_lights_*`.
- **Walk inside**: the hall, the stairs and the lounge upstairs. You start at the bar.
- **Tow tug** with a remote:
  - Push the aircraft out and back in.
  - HOME drives it back onto its spot in the hangar (up to 300 m).
  - It checks the aircraft's whole outline against walls.
- **Showcase**: all four sizes side by side at LFMQ (Le Castellet), to look at.

---

## Tablet (Night EFB, Plugins > Homebase > Tablet)

- **Airframes**: each aircraft you own, with its registration, livery, homebase and start.
- Each airframe keeps its fuel, its parking spot and its flight hours between flights.
- **World map**: where your airframes and homebases are.
- **Homebase map**: place, move or remove hangars, and choose the size.

---

## Phone (Plugins > Homebase > Phone)

- **Dock**: Now, Services, Sandra, FBO, Hangar.
  - **Now** shows where you are, with suggestions.
  - **Sandra** is the FBO's chat. She takes your orders in words.
- **Control centre**: tap the status bar for Pilot seat, Go outside, Lounge, By car, and the
  switches.
- **Banners** when a service moves on.
- **Quick orders**: the buttons act at once.
- Put away, its top peeks out of the bottom of the screen.
- **Settings**:
  - network: your VATSIM CID and SimBrief ID;
  - preferences: Walkaround, X-Camera in the cockpit, Go outside at the stairs, Quick orders;
  - the FBO sign;
  - fuel units and fuelling time.

---

## Walkaround

- Stand up from the pilot seat and walk the cabin, the airstair, the apron, the lounge and the hangar.
- Keys and mouse look; run and crouch.
- Commands `homebase/...` for your own keys and joystick buttons.
- Footsteps on every surface.
- Works with X-Camera: the cockpit seats hand the view back to it.

---

## Updates

Homebase updates itself through the **SkunkCrafts Updater** (free). It finds two entries:

- **Homebase**: the plugin.
- **Homebase hangars**: the hangar scenery pack's models.

Neither update touches:

- your `Homebase.ini`;
- your own data packs (`aircraft/`);
- your hangars (`hangars/`, `bases/`, `Earth nav data/`);
- anything in `Output/Homebase`.

---

## Credits

See `CREDITS.txt`: the textures (Poly Haven, CC0), the fuel attendant (MakeHuman / MPFB and
Quaternius, CC0), the sounds (Freesound, CC0 / CC-BY) and X-Plane's own library objects.
