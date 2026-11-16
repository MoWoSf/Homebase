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
