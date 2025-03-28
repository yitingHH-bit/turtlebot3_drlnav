#!/bin/bash

# 设置你的工作空间路径 chmod +x start_training.sh  ./start_training.sh

 
WORKSPACE_PATH="/home/jack/drl/turtlebot3_drlnav"

# 启动 tmux 会话
SESSION="turtlebot3_training"

# 创建新的 tmux 会话
tmux new-session -d -s $SESSION

# 启动 Gazebo 仿真环境（窗口 1）
tmux rename-window -t $SESSION "Gazebo"
tmux send-keys -t $SESSION "source /opt/ros/humble/setup.bash && source $WORKSPACE_PATH/install/setup.bash" C-m
tmux send-keys -t $SESSION "ros2 launch turtlebot3_gazebo turtlebot3_drl_stage4.launch.py" C-m

# 启动目标生成节点（窗口 2）
tmux new-window -t $SESSION -n "Goals"
tmux send-keys -t $SESSION:1 "source /opt/ros/humble/setup.bash && source $WORKSPACE_PATH/install/setup.bash" C-m
tmux send-keys -t $SESSION:1 "ros2 run turtlebot3_drl gazebo_goals" C-m

# 启动环境节点（窗口 3）
tmux new-window -t $SESSION -n "Environment"
tmux send-keys -t $SESSION:2 "source /opt/ros/humble/setup.bash && source $WORKSPACE_PATH/install/setup.bash" C-m
tmux send-keys -t $SESSION:2 "ros2 run turtlebot3_drl environment" C-m

# 启动训练代理（窗口 4，默认 TD3）
tmux new-window -t $SESSION -n "Training"
tmux send-keys -t $SESSION:3 "source /opt/ros/humble/setup.bash && source $WORKSPACE_PATH/install/setup.bash" C-m
tmux send-keys -t $SESSION:3 "ros2 run turtlebot3_drl train_agent td3" C-m

# 让用户进入 tmux 会话
tmux attach -t $SESSION

