#!/usr/bin/env bash
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0
check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    printf 'OK      %-18s %s\n' "$1" "$(command -v "$1")"
  else
    printf 'MISSING %-18s\n' "$1"
    failed=1
  fi
}
for cmd in git python3 gz colcon MicroXRCEAgent; do check_cmd "$cmd"; done
for path in /opt/ros/humble/setup.bash "${PX4_DIR:-$HOME/PX4-Autopilot}/Makefile"; do
  if [[ -f "$path" ]]; then echo "OK      $path"; else echo "MISSING $path"; failed=1; fi
done
if [[ -n "${PX4_ROS_WS:-}" ]]; then
  msgs="$PX4_ROS_WS/install/setup.bash"
else
  msgs="$repo/workspace/src/px4_msgs/package.xml"
fi
if [[ -f "$msgs" ]]; then echo "OK      $msgs"; else echo "MISSING $msgs"; failed=1; fi
if [[ -f "$repo/workspace/install/setup.bash" ]]; then
  echo 'OK      challenge workspace built'
else
  echo 'MISSING challenge workspace build (run scripts/build_workspace.sh)'
  failed=1
fi
if python3 -c 'import pymavlink' >/dev/null 2>&1; then
  echo 'OK      Python pymavlink'
else
  echo 'MISSING Python pymavlink'
  failed=1
fi
exit "$failed"
