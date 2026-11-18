# Passenger stops

The saved SLX includes an ordered mission on the existing competition route:

1. Approach pickup at map XY **(2.19, -0.26) m**.
2. Stop inside a **1 m radius** and remain stopped for **5 seconds**.
3. Resume the route and approach drop-off at **(0.92, -1.10) m**.
4. Stop inside a **1 m radius** for **5 seconds**, then resume driving.

Distance uses the XY plane, ignoring height. The stop command triggers at
0.9 m to leave some braking room inside the requested 1 m radius.
The dwell timer starts when the stop command is issued and releases exactly
five simulation seconds later. It does not wait for a noisy speed reading
to reach an exact threshold. There may be a short braking interval at the
beginning of each five-second stop command.

This is one mission per simulation run. Restarting the simulation resets it.
After drop-off the car continues the existing loop. The controller follows
the existing route rather than planning a new path directly to either point.

Run `Virtual_Setup_Competition_Map` and press Run in Normal mode as before.
Reload the model from disk first if an older copy is already open.
The model now restarts the virtual QCar2 workspace on every **Run** through
its `StartFcn` callback. It stops the two named QCar2 workspace variants,
starts `QCar2_Workspace_studio`, and waits for the HIL, Video3D camera,
and localization listeners. It first confirms that QCar2 actor 0 exists in
QLabs. The readiness check does not connect to the HIL proxy; a raw TCP
probe can interrupt that protocol. Keep QLabs open with the spawned QCar2.
If a service is unavailable, the callback names the missing service.

The top-level `Passenger Stops` block gates the speed reference going into
the existing speed controller. Its displays show target distance and stage:
**0** approach pickup, **1** pickup dwell, **2** approach drop-off,
**3** drop-off dwell, **4** completed.

Edit `passenger_stop_controller.m` and run `Apply_Passenger_Stops` while
the model is stopped to change coordinates or timing. The source is embedded
in a discrete MATLAB Function running at `Controller_Sample_Time`.
Existing obstacle and stop-sign speed handling remains downstream.

`validate_passenger_stops` checks ordering, fixed dwell timing despite
speed sensor noise, startup delay, radius handling, and completion without repeats.
Live QLabs braking distance and location behavior still require a drive check.

The model before adding passenger stops is backed up under
`backups/before_passenger_stops/`.
