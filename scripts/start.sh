#!/bin/bash

echo "🚀 Starting ROS container 'ros1'..."

docker run -itd --name ros1 \
  -e DISPLAY=host.docker.internal:0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$(pwd)/workspace":/home/ros/ws \
  ros1-container

echo "✅ Container started. Use 'make shell' to access it."
