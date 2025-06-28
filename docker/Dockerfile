FROM ros:noetic-ros-core

# Install bridge + catkin tools + build tools
RUN apt-get update && \
    apt-get install -y \
        ros-noetic-foxglove-bridge \
        python3-catkin-tools \
        build-essential \
        cmake \
        && apt-get clean

# Set up the workspace directory
WORKDIR /home/ros/ws
RUN mkdir -p src

# Initialize workspace (but don't build here)
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && cd src && catkin_init_workspace"

# Autoload ROS in every shell
RUN echo 'source /opt/ros/noetic/setup.bash' >> /home/ros/.bashrc && \
    echo 'source /home/ros/ws/devel/setup.bash' >> /home/ros/.bashrc
