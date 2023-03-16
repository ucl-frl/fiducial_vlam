import os
import sys

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node

vloc_args = [{
    'use_sim_time': False,  # Use /clock if available
    'publish_tfs': 1,  # Publish drone and camera /tf
    'stamp_msgs_with_current_time': 0,  # Use incoming message time, not now()
    'map_init_pose_z': -1,
    'base_odometry_pub_topic': 'filtered_odom',
    'sub_camera_info_best_effort_not_reliable': 1,
    'publish_image_marked': 1,
}]

vmap_args = [{
    'use_sim_time': False,  # Use /clock if available
    'publish_tfs': 1,  # Publish marker /tf
    'marker_length': 0.1627,  # Marker length
    'marker_map_save_full_filename': "test.yaml",  # Map saved path
    'make_not_use_map': 1,  # Create a new map
    'map_init_style':1, # initiate map from a known marker
    'map_init_id':1, # initiate map from the location of marker 1
}]

def generate_launch_description():
    return LaunchDescription([
        # launch nodes required for ros driver and joystick operation
        Node(package='joy', executable='joy_node', output='screen'),
        Node(package='tello_driver', executable='tello_joy_main', output='screen'),
        Node(package='tello_driver', executable='tello_driver_main', output='screen'),
        
        # launch nodes required for drone localization and mapping
        Node(package='fiducial_vlam', executable='vloc_main', output='screen', parameters=vloc_args),
        Node(package='fiducial_vlam', node_executable='vmap_main', output='screen', parameters=vmap_args),
    ])