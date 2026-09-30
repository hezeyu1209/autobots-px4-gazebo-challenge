#!/usr/bin/env bash
set -eo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source /opt/ros/humble/setup.bash
if [[ -n "${PX4_ROS_WS:-}" ]]; then source "$PX4_ROS_WS/install/setup.bash"; fi
source "$repo/workspace/install/setup.bash"
if ! ros2 topic list | grep -Fxq '/fmu/out/vehicle_local_position'; then
  echo 'No PX4 local-position topic. Start PX4 and MicroXRCEAgent, then retry.' >&2
  exit 1
fi
echo 'PX4 local-position topic found. Waiting up to 10 seconds for one message...'
timeout 10 ros2 topic echo /fmu/out/vehicle_local_position --once
echo 'Environment is ready for student code. No flight task has been run.'
