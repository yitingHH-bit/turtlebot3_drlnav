#!/bin/bash

# 设置 ROS 2 环境
source /opt/ros/humble/setup.bash
source /home/jack/drl/turtlebot3_drlnav/install/setup.bash

# 选择环境 (可以修改 STAGE_NUM)
STAGE_NUM=9

# 选择算法 (ddpg 或 td3)
ALGO="ddpg"
MODEL_PATH="examples/${ALGO}_0"
EPISODE=8000
#chmod +x /home/jack/drl/turtlebot3_drlnav/start_example_model.sh
#./home/jack/drl/turtlebot3_drlnav/start_example_model.sh

# 启动 tmux 会话
tmux new-session -d -s turtlebot3_session

# 启动 Gazebo
tmux send-keys "source /opt/ros/humble/setup.bash && source /home/jack/drl/turtlebot3_drlnav/install/setup.bash && ros2 launch turtlebot3_gazebo turtlebot3_drl_stage${STAGE_NUM}.launch.py" C-m
tmux split-window -h
sleep 5  # 等待 Gazebo 加载完成

# 启动目标生成
tmux send-keys "source /opt/ros/humble/setup.bash && source /home/jack/drl/turtlebot3_drlnav/install/setup.bash && ros2 run turtlebot3_drl gazebo_goals" C-m
tmux split-window -v
sleep 3  # 确保目标已加载

# 启动环境
tmux send-keys "source /opt/ros/humble/setup.bash && source /home/jack/drl/turtlebot3_drlnav/install/setup.bash && ros2 run turtlebot3_drl environment" C-m
tmux split-window -h
sleep 3  # 确保环境已准备好

# 启动 DDPG/TD3 训练
tmux send-keys "source /opt/ros/humble/setup.bash && source /home/jack/drl/turtlebot3_drlnav/install/setup.bash && ros2 run turtlebot3_drl test_agent ${ALGO} '${MODEL_PATH}' ${EPISODE}" C-m

# 让 tmux 保持打开
tmux attach-session -t turtlebot3_session

