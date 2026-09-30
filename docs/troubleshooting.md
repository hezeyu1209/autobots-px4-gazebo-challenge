# 常见问题

- `ekf2 missing data`：确认使用本仓库场景。自定义世界显式列出了 Physics、Sensors、IMU、AirPressure、Magnetometer、NavSat 等系统，缺失会使 PX4 预检失败。
- `No connection to the ground control station`：运行 `scripts/sim_gcs_heartbeat.py`，或者打开 QGroundControl；不要通过关闭预检掩盖问题。
- 看不到 `/fmu/out/vehicle_local_position`：检查 `MicroXRCEAgent udp4 -p 8888` 是否正在运行、PX4 客户端是否连接、ROS 2 环境是否加载。
- `px4_msgs` 编译/导入失败：核对 `release/1.16`，重新运行 `scripts/build_workspace.sh`，并在新终端重新 `source workspace/install/setup.bash`。
- 启动时 Gazebo 没有树木/草地：Fuel 模型首次下载需要联网；飞控与场景地面不依赖这些装饰模型。
- Gazebo 不显示窗口：默认是 `HEADLESS=1`；图形环境正常时使用 `HEADLESS=0 bash scripts/start_sim.sh`。WSL 图形问题先按系统图形配置排查。
- 飞机不解锁或不能进入 Offboard：检查地面站心跳、传感器状态、Agent 同步以及自己编写的控制逻辑。环境检查通过不代表控制代码正确。

错误输出、系统版本和启动顺序比单张截图更利于定位问题。不要修改飞控安全检查来掩盖控制错误。
