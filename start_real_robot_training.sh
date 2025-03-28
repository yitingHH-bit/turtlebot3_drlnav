#!/bin/bash

# 设置你的工作空间路径chmod +x start_real_robot_training.sh  ./start_real_robot_training.sh


WORKSPACE_PATH="/home/jack/drl/turtlebot3_drlnav"

# 训练参数（可以修改）
ALGORITHM_NAME="ddpg"  # 可选: ddpg, td3, dqn
MODEL_NAME="ddpg_1_stage4"
MODEL_EPISODE="1000"

# 启动 tmux 会话
SESSION="turtlebot3_real_training"

# 创建新的 tmux 会话
tmux new-session -d -s $SESSION

# 启动真实环境节点（窗口 1）
tmux rename-window -t $SESSION "Real Environment"
tmux send-keys -t $SESSION "source /opt/ros/humble/setup.bash && source $WORKSPACE_PATH/install/setup.bash" C-m
tmux send-keys -t $SESSION "ros2 run turtlebot3_drl real_environment" C-m

# 启动真实机器人代理节点（窗口 2）
tmux new-window -t $SESSION -n "Real Agent"
tmux send-keys -t $SESSION:1 "source /opt/ros/humble/setup.bash && source $WORKSPACE_PATH/install/setup.bash" C-m
tmux send-keys -t $SESSION:1 "ros2 run turtlebot3_drl real_agent $ALGORITHM_NAME $MODEL_NAME $MODEL_EPISODE" C-m

# 让用户进入 tmux 会话
tmux attach -t $SESSION

