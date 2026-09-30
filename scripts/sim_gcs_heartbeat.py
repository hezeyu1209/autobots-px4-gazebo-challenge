"""GCS heartbeat for PX4 SITL without QGroundControl; sends no flight commands."""

import time
from pymavlink import mavutil


def main():
    link = mavutil.mavlink_connection('udpin:127.0.0.1:14550', source_system=255)
    print('Waiting for PX4 MAVLink on UDP 14550', flush=True)
    link.wait_heartbeat(timeout=30)
    print('PX4 MAVLink connected; sending GCS heartbeat', flush=True)
    while True:
        link.mav.heartbeat_send(
            mavutil.mavlink.MAV_TYPE_GCS,
            mavutil.mavlink.MAV_AUTOPILOT_INVALID,
            0, 0, 0,
        )
        time.sleep(1)


if __name__ == '__main__':
    main()
