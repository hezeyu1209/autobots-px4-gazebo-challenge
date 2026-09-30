#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source /etc/os-release
if [[ "${ID:-}" != ubuntu || "${VERSION_ID:-}" != 22.04 ]]; then
  echo 'This bootstrap supports Ubuntu 22.04 only. See docs/manual-setup.md.' >&2
  exit 2
fi

as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then "$@"; else sudo "$@"; fi
}

as_root apt-get update
as_root apt-get install -y git curl ca-certificates locales software-properties-common python3-pip python3-venv cmake build-essential

if [[ ! -f /opt/ros/humble/setup.bash ]]; then
  echo 'Installing ROS 2 Humble from the official ROS apt repository...'
  as_root locale-gen en_US en_US.UTF-8
  as_root add-apt-repository -y universe
  as_root install -d -m 755 /usr/share/keyrings
  as_root curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
  arch="$(dpkg --print-architecture)"
  printf 'deb [arch=%s signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu %s main\n' "$arch" "$UBUNTU_CODENAME" | as_root tee /etc/apt/sources.list.d/ros2.list >/dev/null
  as_root apt-get update
  as_root apt-get install -y ros-humble-ros-base python3-colcon-common-extensions
else
  as_root apt-get install -y python3-colcon-common-extensions
fi

px4_dir="${PX4_DIR:-$HOME/PX4-Autopilot}"
px4_cloned=0
if [[ ! -d "$px4_dir/.git" ]]; then
  echo "Cloning PX4 v1.16.2 into $px4_dir ..."
  git clone --branch v1.16.2 --depth 1 --recurse-submodules --shallow-submodules https://github.com/PX4/PX4-Autopilot.git "$px4_dir"
  px4_cloned=1
fi
if [[ "$(git -C "$px4_dir" describe --tags --exact-match 2>/dev/null || true)" != v1.16.2 ]]; then
  echo "PX4 at $px4_dir is not exactly v1.16.2; choose a matching PX4_DIR." >&2
  exit 2
fi
if [[ "$px4_cloned" -eq 1 ]] || ! command -v gz >/dev/null 2>&1; then
  echo 'Installing PX4/Gazebo build dependencies...'
  bash "$px4_dir/Tools/setup/ubuntu.sh" --no-nuttx
fi

if ! command -v MicroXRCEAgent >/dev/null 2>&1; then
  agent_dir="$repo/deps/Micro-XRCE-DDS-Agent"
  mkdir -p "$repo/deps"
  if [[ ! -d "$agent_dir/.git" ]]; then
    git clone --branch v2.4.3 --depth 1 https://github.com/eProsima/Micro-XRCE-DDS-Agent.git "$agent_dir"
  fi
  cmake -S "$agent_dir" -B "$agent_dir/build"
  cmake --build "$agent_dir/build" -j 2
  as_root cmake --install "$agent_dir/build"
  as_root ldconfig
fi

if ! python3 -c 'import pymavlink' >/dev/null 2>&1; then
  python3 -m pip install --user pymavlink
fi

if [[ -z "${PX4_ROS_WS:-}" && ! -d "$repo/workspace/src/px4_msgs/.git" ]]; then
  git clone --branch release/1.16 --depth 1 https://github.com/PX4/px4_msgs.git "$repo/workspace/src/px4_msgs"
fi

bash "$repo/scripts/build_workspace.sh"
bash "$repo/scripts/check_environment.sh"
echo 'Environment installed. Restart Ubuntu/WSL if PX4/Gazebo was installed for the first time.'
