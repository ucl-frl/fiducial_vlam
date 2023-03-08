FROM osrf/ros:foxy-desktop

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y python3-pip

WORKDIR /work/ros2_ws/src

RUN git clone https://github.com/ucl-frl/fiducial_vlam.git
RUN git clone https://github.com/ucl-frl/tello_ros.git
RUN git clone https://github.com/ptrmu/ros2_shared.git

WORKDIR /work/ros2_ws

RUN rosdep install -y --from-paths . --ignore-src

RUN /bin/bash -c "source /opt/ros/foxy/setup.bash && colcon build && colcon test --packages-select fiducial_vlam"
