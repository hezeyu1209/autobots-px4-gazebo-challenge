#!/usr/bin/env bash
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
px4_dir="${PX4_DIR:-$HOME/PX4-Autopilot}"
world_dir="$px4_dir/Tools/simulation/gz/worlds"
if [[ ! -d "$world_dir" ]]; then
  echo "PX4 source not found at $px4_dir; run bootstrap_ubuntu.sh or set PX4_DIR." >&2
  exit 2
fi
cp "$repo/worlds/autobots_roundtrip.sdf" "$world_dir/autobots_roundtrip.sdf"
cd "$px4_dir"
export PX4_GZ_WORLD=autobots_roundtrip
export HEADLESS="${HEADLESS:-1}"
exec make px4_sitl gz_x500_mono_cam
