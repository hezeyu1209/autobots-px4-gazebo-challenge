# 手动安装与版本约束

仓库按 Ubuntu 22.04、ROS 2 Humble、Gazebo Harmonic、PX4 v1.16.2、`px4_msgs` release/1.16、Micro XRCE-DDS Agent v2.4.3 设计。先阅读 [ROS 2 Humble 官方安装](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html)、[PX4 v1.16 Ubuntu 环境](https://docs.px4.io/v1.16/en/dev_setup/dev_env_linux_ubuntu) 和 [PX4 ROS 2 通信](https://docs.px4.io/v1.16/en/ros2/user_guide)。不要混用 PX4 与 `px4_msgs` 的不同发布分支，也不要安装不兼容的 Agent v3。

1. 安装 ROS 2 Humble（`ros-humble-ros-base` 或 desktop）和 `python3-colcon-common-extensions`。
2. 克隆 PX4 v1.16.2（含 submodules），运行其 `Tools/setup/ubuntu.sh --no-nuttx`，完成 Gazebo Harmonic 工具链安装。默认位置是 `~/PX4-Autopilot`；放别处时设置 `PX4_DIR`。
3. 安装 Micro XRCE-DDS Agent v2.4.3，按 PX4 官方指南从源码构建；确认 `MicroXRCEAgent` 在 `PATH` 中。
4. 安装 Python `pymavlink`，用于没有 QGroundControl 的纯仿真地面站心跳。
5. 把 `px4_msgs` 的 `release/1.16` 分支放到 `workspace/src/px4_msgs`，或者设置 `PX4_ROS_WS` 指向已构建且版本匹配的外部工作区。
6. 在本仓库根目录运行 `bash scripts/build_workspace.sh` 和 `bash scripts/check_environment.sh`。

Windows 用户在 WSL2 的 Ubuntu 终端中完成这些步骤，不要在 PowerShell 中执行 `.sh`。WSL 图形界面因系统设置而异；无图形界面先用默认 `HEADLESS=1` 验证通信。首次加载 Gazebo Fuel 的树木/草地需要网络，缓存后可离线。
