#!/usr/bin/env python3

import subprocess
from roslibpy import Ros, Topic
import time

# Dictionary to keep track of running scripts
running_scripts = {}

def connect_ros():
    client = Ros(host='local.ip-adresse', port=9090)
    client.run()
    an = Topic(client, '/avatar_controller', 'victor_msgs/msg/String')
    return client, an
    

def lis(somthing):
    print("Received message:", somthing)
    if somthing['ros_text'] == 'start_matrix':
        start_script('/home/cfc/Animations')
    if somthing['ros_text'] == 'stop_matrix':
        stop_script('/home/cfc/Animations')

    if somthing['ros_text'] == 'start_mic_record':
        start_script('/home/cfc/Audiorecord')
    if somthing['ros_text'] == 'stop_mic_record':
        stop_script('/home/cfc/Audiorecord')

    if somthing['ros_text'] == 'start_zed_record':
        start_script('/home/cfc/ros-camera-stream/lvc')
    if somthing['ros_text'] == 'stop_zed_record':
        stop_script('/home/cfc/ros-camera-stream/lvc')

    if somthing['ros_text'] == 'start_mic_stream':
        start_script('/home/cfc/Audiostream')
    if somthing['ros_text'] == 'stop_mic_stream':
        stop_script('/home/cfc/Audiostream')
    
    if somthing['ros_text'] == 'start_zed_stream':
        start_script('/home/cfc/ros-camera-stream/rcs')
    if somthing['ros_text'] == 'stop_zed_stream':
        stop_script('/home/cfc/ros-camera-stream/rcs')

def start_script(script_name):
    if script_name not in running_scripts:
        print(f"Starting {script_name}")
        # Start the script and store the process handle
        process = subprocess.Popen(['python', f'{script_name}.py'])
        running_scripts[script_name] = process
    else:
        print(f"{script_name} is already running.")

def stop_script(script_name):
    if script_name in running_scripts:
        print(f"Stopping {script_name}")
        # Terminate the process and remove it from the dictionary
        running_scripts[script_name].terminate()
        running_scripts.pop(script_name)
    else:
        print(f"No running script found with the name {script_name}.")

def main():
    client, an = connect_ros()
    an.subscribe(lis)
    while True:
        time.sleep(0.1)

if __name__ == "__main__":
    main()
