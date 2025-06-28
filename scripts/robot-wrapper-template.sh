#!/bin/bash
# This is a command stub used by robot-start, robot-shell, etc.

CMD_NAME=$(basename "$0")
ROBOT_NAME=${CMD_NAME%%-*}
COMMAND=${CMD_NAME#*-}

PROJECT_DIR="/path/to/your/ros-docker-dev"  # will be replaced during setup

cd "$PROJECT_DIR" || exit 1
source "$PROJECT_DIR/config.env"
bash "$PROJECT_DIR/scripts/$COMMAND.sh" "$@"
