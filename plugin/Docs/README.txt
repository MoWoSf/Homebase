Homebase for X-Plane 12 - read me
=================================

INSTALLING
Unpack Homebase.zip straight into your X-Plane 12 folder (the one with X-Plane.exe). It brings two
folders:
  Resources/plugins/Homebase                      the plugin
  Custom Scenery/Private Hangar Homebases         the hangars' models (and the LFMQ showcase)
Start X-Plane. At its first start Homebase makes its Homebase.ini from Homebase.ini.default and
puts the hangar pack's line into scenery_packs.ini.

Updating from an earlier version: unpack over it and let it replace the files. Your Homebase.ini, your
own hangars (hangars/, bases/, Earth nav data/) and everything in Output/Homebase stay.

UPDATES
With the SkunkCrafts Updater (free) installed, Homebase keeps itself up to date: the updater lists
"Homebase" (the plugin) and "Homebase hangars" (the scenery pack). Update both.

WHERE THINGS ARE
  Plugins > Homebase                    tablet, phone, tow tug, AI profile kit, Active for this aircraft
  Resources/plugins/Homebase/Homebase.ini     the settings (take effect after reloading the aircraft)
  Resources/plugins/Homebase/packs            the bundled data packs (Falcon 8X, GLF650): the updater's
  Resources/plugins/Homebase/aircraft         YOUR data packs: win over the bundled ones, never touched
  Resources/plugins/Homebase/fbo_custom       your pictures and music for the lounge (see its README)
  Resources/plugins/Homebase/Docs             FEATURES.md (what it does), AIRCRAFT_PROFILE_GUIDE.md
  Output/Homebase                             your airframes, measured aircraft, AI profile kits

A DATA PACK FOR YOUR AIRCRAFT
Load the aircraft, then Plugins > Homebase > AI profile kit for this aircraft ... The folder that
opens has AI_PROMPT.txt: paste it into an AI assistant and attach the other files of the folder.
The full specification is Docs/AIRCRAFT_PROFILE_GUIDE.md.

PROBLEMS
Report them on the Discord with your Log.txt (X-Plane 12 folder): Homebase's lines start with
"Homebase:".
