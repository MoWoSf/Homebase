# AKD Studio GLF650 and GLF650ER (the same OBJs). The values GLF650 Walkaround and GLF650 Hangar
# have built in: src/acft.c (-DACFT_GLF650), tools/mkgrid.c (its GLF650 config) and
# aircraft/glf650/GLF650_Walkaround.seats.

profile 1
acf GLF650_AKD.acf
acf GLF650ER_AKD.acf
acf_icao GLF650             # what the two .acf say in P acf/_ICAO ...
acf_icao GLF650ER
icao GLF6                   # ... the real type designator: VATSIM flight plans, the hangar's stop mark
name GLF650
board_name GULFSTREAM G650
legacy_cmd_prefix GLF650/walkaround

# ---- 6.2 collision grid
# the outside. Left out: the ground services (hidden by default), the pilots and the glass
exterior_obj Fuselage_main.obj
exterior_obj Fuselage_main_2.obj
exterior_obj Fuselage_main_3.obj
exterior_obj Fuselage_details.obj
exterior_obj wings.obj
exterior_obj engines.obj
exterior_obj landing gear.obj
exterior_obj Gear_Bay.obj
# for the automatic grid only (exterior_obj above decides): hidden ground equipment and glass
ignore_obj Ground Services/chocks.obj
ignore_obj Ground Services/Static.obj
ignore_obj Ground Services/DC_GPU.obj
ignore_obj Ground Services/Fuel Track.obj
ignore_obj Ground Services/GPU.obj
ignore_obj Ground Services/Sprintair_ext.obj
ignore_obj Ground Services/Sprintair_int.obj
ignore_obj Glass.obj
ignore_obj Cockpit glass.obj
ignore_obj HUD_Glass.obj
obj_offset 0 -0.12192 0              # GLF650_AKD.acf: _v10_att_y_acf_prt_ref -0.40 (feet) on every OBJ
grid_box -16.5 -19.0 16.5 19.0       # 660 x 760 cells
ground_y -2.831                      # .acf: (_cgY -1.0 - _h_eqlbm 8.2878) x 0.3048 = -2.8309
grid_preview -2.6 1.6 -14.0 6.5 -9.0 -6.0 4.5

# ---- 6.3 passenger door and airstair: the airstair is the door itself
# Fuselage_main.obj, Fuselage_main_3.obj: AKD/anim/door/main_door_ratio, 0 shut .. 1 open
# (keys written from 1 to 0). Not an array: no door_index.
door_dref AKD/anim/door/main_door_ratio
door_closed 0
door_open 1
door_obj Fuselage_main.obj
door_obj Fuselage_main_3.obj
stair_search -3.3 -0.32
stair_x -1.4
stair_scan -1.6
stair_foot -2.6 -9.05

# ---- 6.4 cabin walking
# cabin floor about -0.72 (-0.62 in the baggage compartment), cockpit platform -0.44 with a
# footwell at about -1.17 in front of the seats
floor_obj Cabin.obj
floor_obj Cabin_2.obj
floor_obj Cabin_3.obj
floor_obj Cockpit.obj
floor_obj Cockpit_1.obj
floor_obj Cockpit_walls.obj
floor_obj Fuselage_main.obj
floor_obj Fuselage_main_2.obj
floor_obj Fuselage_main_3.obj
floor_obj Baggage Compartment.obj
interior_obj Cockpit.obj
interior_obj Cockpit_1.obj
interior_obj OverHead Panel.obj
interior_obj Pedestal Panel.obj
interior_obj Cockpit_Seats.obj
interior_obj cockpit details.obj
interior_obj Cockpit_CB's_panel.obj
interior_obj Cockpit_walls.obj
interior_obj Cockpit_walls_2.obj
interior_obj Cockpit_controls.obj
interior_obj Cabin.obj
interior_obj Cabin_2.obj
interior_obj Cabin_3.obj
interior_obj Baggage Compartment.obj
interior_obj Fuselage_main.obj
interior_obj Fuselage_main_2.obj
interior_obj Fuselage_main_3.obj
seat_obj 1 Cockpit_Seats.obj         # the cabin seats are merged into Cabin*.obj: measured by hand below
floor_range -1.32 -0.27
floor_default -0.67
cabin_box 1.30 -13.5 6.2
seat_eye_height 1.05                 # as low as crouching
cabin_voice 0 -0.02 -3.0

# ---- 6.5 seats: measured by hand in a top view of the cabin OBJs (cushion 0.48 m above the floor)
#    kind xmin   xmax   zmin    zmax    ytop   eye_x  eye_y  eye_z   yaw
seat 1 -0.650 -0.150 -11.100 -10.450 0.598  -0.400 0.638 -10.740    0
seat 1  0.300  0.800 -11.100 -10.450 0.598   0.550 0.638 -10.740    0
seat 2 -0.920 -0.320  -5.180  -4.550 0.340  -0.620 0.470  -4.950  180
seat 2  0.560  1.160  -5.180  -4.550 0.340   0.860 0.470  -4.950  180
seat 2 -0.920 -0.320  -3.600  -3.050 0.354  -0.620 0.484  -3.220    0
seat 2  0.560  1.160  -3.600  -3.050 0.354   0.860 0.484  -3.220    0
seat 2 -0.980 -0.500  -2.550  -2.100 0.361  -0.740 0.491  -2.410  180
seat 2 -0.500 -0.020  -2.550  -2.100 0.361  -0.260 0.491  -2.410  180
seat 2 -0.980 -0.500  -0.950  -0.300 0.377  -0.740 0.507  -0.540    0
seat 2 -0.500 -0.020  -0.950  -0.300 0.377  -0.260 0.507  -0.540    0
seat 2 -0.980 -0.320   0.200   0.800 0.384  -0.650 0.514   0.420  180
seat 2 -1.050 -0.350   1.750   2.450 0.399  -0.680 0.529   2.180    0
seat 3  0.350  1.050   0.400   1.030 0.387   0.820 0.517   0.720  -90
seat 3  0.350  1.050   1.030   1.670 0.392   0.820 0.522   1.350  -90
seat 3  0.350  1.050   1.670   2.300 0.397   0.820 0.527   1.980  -90

# ---- 6.6 luggage hold
# measured in the mkgrid dump of its door animation and in the grid: the baggage door is on
# the left at z 4.78..5.58, sill 2.2 m above the ground, level with the cabin floor (y -0.62);
# the lining beside it is at x -0.86, the partition across the compartment at +0.45. The bags
# lie against the partition, well away from the door, which swings up inside the opening:
# they go in through the middle of the opening (door_push 1) and below its top.
luggage_label Baggage door left aft
luggage_dref AKD/anim/cargo_door_ratio
luggage_switch AKD/doors/toggle_cargo_door_switch
luggage_door -1.10 5.18
hold_wall_x 0.30
hold_mid_x -0.10
hold_ceil 0.48
hold_z 4.55 5.55
hold_floor -0.618 5.0 0.0
hold_skin -0.85 5.0 0.0
hold_box -1.30 -0.67 4.50 0.45 0.58 5.65
door_slide 1.50
hold_door_top 0.0
door_push 1
van_stop -4.55 6.63                  # 2 m further aft than level with the door: its tailgate hit the wing
# the wing's trailing edge keeps everything at z > 4.2
bag_spot -2.35 4.50
bag_spot -2.35 5.85
bag_spot -3.00 4.40
bag_spot -3.00 5.10
bag_spot -2.35 6.45
bag_spot -3.00 5.75
bag_spot -3.00 6.40
bag_spot -2.35 7.05
bag_spot -3.00 7.05

# ---- 6.7 places
center_z 0.0
fbo_z 1.0
