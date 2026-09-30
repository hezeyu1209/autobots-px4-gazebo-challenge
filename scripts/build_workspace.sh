#!/usr/bin/env bash
set -eo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source /opt/ros/humble/setup.bash
if [[ -n "${PX4_ROS_WS:-}" ]]; then
  source "$PX4_ROS_WS/install/setup.bash"
  packages=(autobots_challenge)
else
  if [[ ! -d "$repo/workspace/src/px4_msgs" ]]; then
    echo 'Missing px4_msgs. Run scripts/bootstrap_ubuntu.sh or set PX4_ROS_WS.' >&2
    exit 2
  fi
  packages=(px4_msgs autobots_challenge)
fi
cd "$repo/workspace"
colcon build --symlink-install --packages-select "${packages[@]}"
