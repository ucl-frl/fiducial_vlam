FROM osrf/ros:foxy-desktop

RUN apt-get update
RUN apt-get upgrade -y

# Some non rosdep dependencies for tello-ros
RUN apt-get install -y libasio-dev
RUN apt-get install -y python3-pip
RUN yes | pip3 install 'transformations==2018.9.5'

WORKDIR /work/ros2_ws/src

RUN git clone https://github.com/ucl-frl/fiducial_vlam.git
RUN git clone https://github.com/ucl-frl/tello_ros.git
RUN git clone https://github.com/ptrmu/ros2_shared.git

WORKDIR /work/ros2_ws

RUN rosdep install -y --from-paths . --ignore-src

RUN /bin/bash -c "source /opt/ros/foxy/setup.bash && colcon build"
RUN /bin/bash -c "source /opt/ros/foxy/setup.bash && colcon test --packages-select fiducial_vlam"
RUN /bin/bash -c "source /opt/ros/foxy/setup.bash && colcon test-result"