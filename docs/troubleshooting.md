# 常见问题

- `ekf2 missing data`：确认使用本仓库场景。自定义世界显式列出了 Physics、Sensors、IMU、AirPressure、Magnetometer、NavSat 等系统，缺失会使 PX4 预检失败。
- `No connection to the ground control station`：运行 `scripts/sim_gcs_heartbeat.py`，或者打开 QGroundControl；不要通过关闭预检掩盖问题。
- 看不到 `/fmu/out/vehicle_local_position`：检查 `MicroXRCEAgent udp4 -p 8888` 是否正在运行、PX4 客户端是否连接、ROS 2 环境是否加载。
- `px4_msgs` 编译/导入失败：核对 `release/1.16`，重新运行 `scripts/build_workspace.sh`，并在新终端重新 `source workspace/install/setup.bash`。
- 俯视镜头看不到顶棚：这是为便于观察路线设计的剖视效果；顶棚碰撞体仍存在，不能直接越过隔墙。
- 无人机没落在 A 桌面：确认从本仓库 `scripts/start_sim.sh` 启动，默认模型出生位姿为 `0,0,0.77`；不要沿用旧场景的 PX4 仿真进程。
- Gazebo 不显示窗口：默认是 `HEADLESS=1`；图形环境正常时使用 `HEADLESS=0 bash scripts/start_sim.sh`。WSL 图形问题先按系统图形配置排查。
- 飞机不解锁或不能进入 Offboard：检查地面站心跳、传感器状态、Agent 同步以及自己编写的控制逻辑。环境检查通过不代表控制代码正确。

错误输出、系统版本和启动顺序比单张截图更利于定位问题。不要修改飞控安全检查来掩盖控制错误。
