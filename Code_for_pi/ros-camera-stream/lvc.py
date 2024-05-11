import cv2
import argparse
import sys
import select
import math
import base64
import time
import threading
import gzip
import datetime
from roslibpy import Ros, Topic

from zed_calibration import *  # Import your calibration module

def init_calibration(calibration_file, image_size):
    # Implement your calibration initialization here
    pass

def non_blocking_input(prompt):
    sys.stdout.write(prompt)
    sys.stdout.flush()
    ready, _, _ = select.select([sys.stdin], [], [], 0)
    if ready:
        return sys.stdin.readline().strip()
    return None
    
def add_timestamp(frame):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    cv2.putText(frame, timestamp, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 255), 2, cv2.LINE_AA)
    return frame

def connect_ros():
    client = Ros(host='local.ip-adresse', port=9090)
    client.run()
    rosSubscriber = Topic(client, '/ros_record/value', 'victor_msgs/msg/String')
    return client, rosSubscriber
    
streaming = True;

def lis(somthing):
    global waiting
    global keep_processing
    print("Received message type:", somthing)
    if somthing['ros_text'] == 'start':
        waiting = False;
    if somthing['ros_text'] == 'stop':
        keep_processing = False;

class Resolution:
    width = 1280
    height = 720
    
waiting = True;
keep_processing = True

# Define video capture object
import camera_stream
zed_cam = camera_stream.CameraVideoStream(use_tapi=True)
zed_cam.open()
width = Resolution.width  # Set the desired width
height = Resolution.height    # Set the desired height
zed_cam.set(cv2.CAP_PROP_FRAME_WIDTH, width)
zed_cam.set(cv2.CAP_PROP_FRAME_HEIGHT, height)

client, rosSubscriber = connect_ros()
rosSubscriber.subscribe(lis)

# Initialize video writers
width_CV = int(zed_cam.get(cv2.CAP_PROP_FRAME_WIDTH))
height_CV = int(zed_cam.get(cv2.CAP_PROP_FRAME_HEIGHT))

out = cv2.VideoWriter('/home/cfc/Videos/output_video.mp4', cv2.VideoWriter_fourcc(*'mp4v'), 30, (width_CV, height_CV), True)
left_video_writer = cv2.VideoWriter('/home/cfc/Videos/left_stream.mp4', cv2.VideoWriter_fourcc(*'mp4v'), 30, (width_CV // 2, height_CV))  # Adjust frame size for left stream
right_video_writer = cv2.VideoWriter('/home/cfc/Videos/right_stream.mp4', cv2.VideoWriter_fourcc(*'mp4v'), 30, (width_CV // 2, height_CV))
canny_writer = cv2.VideoWriter('/home/cfc/Videos/canny.mp4', cv2.VideoWriter_fourcc(*'mp4v'), 30, (width_CV, height_CV))

# Initialize frame counter and timestamp
frame_counter = 0
start_time = time.time()

# Main loop for capturing and processing frames
while waiting:
    time.sleep(1)

while keep_processing:
    if zed_cam.isOpened():
        ret, frame = zed_cam.read()
        frame = frame.get()
        out.write(frame)  # Write frame to video file
        
        gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)#grey the frame

        # performing smoothing on the image using a 5x5 smoothing mark (see
        # manual entry for GaussianBlur())

        smoothed = cv2.GaussianBlur(
            gray_frame, (1, 3), 0)

        # perform canny edge detection

        canny = cv2.Canny(
            smoothed,
            0,
            100)
        
         # Convert Canny output to 3-channel image for VideoWriter
        canny_color = cv2.cvtColor(canny, cv2.COLOR_GRAY2BGR)

        # Write Canny output to video file
        canny_writer.write(canny_color)
			
        left_frame = frame[:, :width_CV // 2, :]
        right_frame = frame[:, width_CV // 2:, :]
        
        left_frame = add_timestamp(left_frame)
        right_frame = add_timestamp(right_frame)
        
        # Write the left and right frames to the respective video files
        left_video_writer.write(left_frame)
        right_video_writer.write(right_frame)
        
         # Increment frame counter
        frame_counter += 1
        
        # Calculate time elapsed
        elapsed_time = time.time() - start_time
        
        # Wait for next second if frame rate exceeds 30 fps
        if elapsed_time < frame_counter / 30:
            wait_time = (frame_counter / 30) - elapsed_time
            time.sleep(wait_time)
        

# Release resources
zed_cam.release()
out.release()
left_video_writer.release()
right_video_writer.release()
