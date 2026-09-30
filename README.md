# AutoBots PX4 × Gazebo 学员起步仓库

这个仓库只负责提供仿真环境：PX4 x500 四旋翼、封闭室内房间、分置在两张桌子上的 A/B 起降圈、中间实体隔墙、ROS 2 工作区空包，以及环境检查和启动脚本。**没有航点控制程序、飞行任务入口、参考轨迹或完成任务的视频。**克隆并启动后，飞机只会停在 A 桌面；起飞、绕墙、导航、返回、降落、异常处理均需学员自己编写。

适用环境：Ubuntu 22.04（原生或 WSL2）、ROS 2 Humble、Gazebo Harmonic、PX4 v1.16.2、`px4_msgs` release/1.16、Micro XRCE-DDS Agent v2.4.3。建议至少预留 20 GB 可用空间；Windows 用户请把 WSL 虚拟磁盘放在空间充足的盘符。首次安装依赖需要联网；室内场景由仓库内 SDF 几何构成，不依赖 Gazebo Fuel 下载素材。

## 从零安装

在 Ubuntu 终端执行：

```bash
git clone https://github.com/hezeyu1209/autobots-px4-gazebo-challenge.git
cd autobots-px4-gazebo-challenge
bash scripts/bootstrap_ubuntu.sh
```

脚本会检查系统版本，按需安装 ROS 2、PX4/Gazebo 工具链、Agent 和 `px4_msgs`，并编译空 ROS 2 包。需要 `sudo` 权限；首次运行耗时较长，安装结束后建议重启 Ubuntu/WSL。它不会运行飞行任务。已有环境可设置 `PX4_DIR` 和 `PX4_ROS_WS` 复用现有 PX4 源码和 `px4_msgs` 工作区，然后执行 `bash scripts/build_workspace.sh`。如果不愿运行自动安装脚本，参照 [手动安装](docs/manual-setup.md)。

验证依赖：

```bash
bash scripts/check_environment.sh
```

## 启动环境

在仓库根目录打开三个 Ubuntu 终端，依次运行：

```bash
# 终端 1：把本仓库场景载入 PX4，并生成 x500 无人机
bash scripts/start_sim.sh
```

```bash
# 终端 2：让 PX4 与 ROS 2 通信
bash scripts/start_agent.sh
```

```bash
# 终端 3：仅当没有连接 QGroundControl 时，给 PX4 提供地面站心跳
python3 scripts/sim_gcs_heartbeat.py
```

另开终端检查：

```bash
bash scripts/check_ready.sh
```

看到 `/fmu/out/vehicle_local_position` 等话题且 PX4 位置数据持续更新，表示环境可供开发；**这不代表飞机已完成任何任务**。图形界面可用时设置 `HEADLESS=0 bash scripts/start_sim.sh` 显示 Gazebo；默认 `HEADLESS=1`，便于 WSL/无显示设备使用。

## 学员从哪里写代码

`workspace/src/autobots_challenge/` 是一个**没有可执行控制节点的空 ROS 2 Python 包**。在 `autobots_challenge/` 下创建自己的 Python 节点，并在 `setup.py` 中注册 `console_scripts`；或自行添加其他 ROS 2 包。修改后运行 `bash scripts/build_workspace.sh`，再 `source workspace/install/setup.bash`。具体任务、交付要求和可用接口见 [学员任务](docs/student-task.md)。

黄色 A 圈位于 Gazebo ENU `(0, 0)` 的桌面上，蓝色 B 圈位于 `(7, 0)` 的另一张桌面上，桌面高度约 `0.77 m`。房间边界约为 `x=-2.25..9.25 m`、`y=-4.2..4.2 m`，顶棚底面约 `z=4.2 m`。隔墙位于 `x=3.5 m`、横跨 `y=-1.8..1.8 m`，从地面接至顶棚；A→B 直线会撞墙，必须从隔墙的一侧绕行。外墙、顶棚、隔墙和桌面都有碰撞体。顶棚的视觉面专为俯视摄像机隐藏，**顶棚碰撞仍然存在**。

启动脚本默认把 x500 放在 A 桌面高度（`PX4_GZ_MODEL_POSE=0,0,0.77`）。PX4 本地 NED 坐标与 Gazebo ENU 不同，而且 PX4 本地原点接近 A 桌面，不能把 Gazebo 世界高度直接当作 PX4 的 z。学员应核对实际位置反馈与安全间距。室内仍使用 PX4 SITL 的模拟定位传感器，这不代表真实室内环境有 GPS 可用；真机室内导航需要另行设计感知、定位与安全系统。

## 仓库内容

```text
worlds/autobots_roundtrip.sdf       室内房间、实体隔墙、桌面 A/B 圈、摄像机、PX4 传感器系统
workspace/src/autobots_challenge/   空 ROS 2 Python 包，无控制实现
scripts/bootstrap_ubuntu.sh         按需准备依赖与编译工作区
scripts/start_sim.sh                启动 PX4 x500 + Gazebo 场景
scripts/start_agent.sh              启动 DDS 通信 Agent
scripts/check_ready.sh              检查 ROS 2 话题和位置反馈
docs/                                安装、任务与排错说明
```

故障排查见 [troubleshooting.md](docs/troubleshooting.md)。依赖安装以 [PX4 v1.16 Ubuntu 指南](https://docs.px4.io/v1.16/en/dev_setup/dev_env_linux_ubuntu)、[PX4 ROS 2 指南](https://docs.px4.io/v1.16/en/ros2/user_guide) 为准。本项目仅限软件在环（SITL）；不得直接用于真机。
