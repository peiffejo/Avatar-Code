import cv2
import argparse
import sys
import select
import math

import base64
import time

import requests
import configparser

import threading
import gzip

import datetime

from zed_calibration import *
from roslibpy import Ros, Topic
from utils import *


def init_calibration(calibration_file, image_size) :

    cameraMarix_left = cameraMatrix_right = map_left_y = map_left_x = map_right_y = map_right_x = np.array([])

    config = configparser.ConfigParser()
    config.read(calibration_file)
    
    print("Calibration: \n")
    print({section: dict(config[section]) for section in config})
    print("Calibration Ende \n")

    check_data = True
    resolution_str = ''
    if image_size.width == 2208 :
        resolution_str = '2K'
    elif image_size.width == 1920 :
        resolution_str = 'FHD'
    elif image_size.width == 1280 :
        resolution_str = 'HD'
    elif image_size.width == 672 :
        resolution_str = 'VGA'
    else:
        resolution_str = 'HD'
        check_data = False

    T_ = np.array([-float(config['STEREO']['Baseline'] if 'Baseline' in config['STEREO'] else 0),
                   float(config['STEREO']['TY_'+resolution_str] if 'TY_'+resolution_str in config['STEREO'] else 0),
                   float(config['STEREO']['TZ_'+resolution_str] if 'TZ_'+resolution_str in config['STEREO'] else 0)])


    left_cam_cx = float(config['LEFT_CAM_'+resolution_str]['cx'] if 'cx' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_cy = float(config['LEFT_CAM_'+resolution_str]['cy'] if 'cy' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_fx = float(config['LEFT_CAM_'+resolution_str]['fx'] if 'fx' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_fy = float(config['LEFT_CAM_'+resolution_str]['fy'] if 'fy' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_k1 = float(config['LEFT_CAM_'+resolution_str]['k1'] if 'k1' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_k2 = float(config['LEFT_CAM_'+resolution_str]['k2'] if 'k2' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_p1 = float(config['LEFT_CAM_'+resolution_str]['p1'] if 'p1' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_p2 = float(config['LEFT_CAM_'+resolution_str]['p2'] if 'p2' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_p3 = float(config['LEFT_CAM_'+resolution_str]['p3'] if 'p3' in config['LEFT_CAM_'+resolution_str] else 0)
    left_cam_k3 = float(config['LEFT_CAM_'+resolution_str]['k3'] if 'k3' in config['LEFT_CAM_'+resolution_str] else 0)


    right_cam_cx = float(config['RIGHT_CAM_'+resolution_str]['cx'] if 'cx' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_cy = float(config['RIGHT_CAM_'+resolution_str]['cy'] if 'cy' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_fx = float(config['RIGHT_CAM_'+resolution_str]['fx'] if 'fx' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_fy = float(config['RIGHT_CAM_'+resolution_str]['fy'] if 'fy' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_k1 = float(config['RIGHT_CAM_'+resolution_str]['k1'] if 'k1' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_k2 = float(config['RIGHT_CAM_'+resolution_str]['k2'] if 'k2' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_p1 = float(config['RIGHT_CAM_'+resolution_str]['p1'] if 'p1' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_p2 = float(config['RIGHT_CAM_'+resolution_str]['p2'] if 'p2' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_p3 = float(config['RIGHT_CAM_'+resolution_str]['p3'] if 'p3' in config['RIGHT_CAM_'+resolution_str] else 0)
    right_cam_k3 = float(config['RIGHT_CAM_'+resolution_str]['k3'] if 'k3' in config['RIGHT_CAM_'+resolution_str] else 0)

    R_zed = np.array([float(config['STEREO']['RX_'+resolution_str] if 'RX_' + resolution_str in config['STEREO'] else 0),
                      float(config['STEREO']['CV_'+resolution_str] if 'CV_' + resolution_str in config['STEREO'] else 0),
                      float(config['STEREO']['RZ_'+resolution_str] if 'RZ_' + resolution_str in config['STEREO'] else 0)])

    R, _ = cv2.Rodrigues(R_zed)
    cameraMatrix_left = np.array([[left_cam_fx, 0, left_cam_cx],
                         [0, left_cam_fy, left_cam_cy],
                         [0, 0, 1]])

    cameraMatrix_right = np.array([[right_cam_fx, 0, right_cam_cx],
                          [0, right_cam_fy, right_cam_cy],
                          [0, 0, 1]])

    distCoeffs_left = np.array([[left_cam_k1], [left_cam_k2], [left_cam_p1], [left_cam_p2], [left_cam_k3]])

    distCoeffs_right = np.array([[right_cam_k1], [right_cam_k2], [right_cam_p1], [right_cam_p2], [right_cam_k3]])

    T = np.array([[T_[0]], [T_[1]], [T_[2]]])
    R1 = R2 = P1 = P2 = np.array([])

    R1, R2, P1, P2 = cv2.stereoRectify(cameraMatrix1=cameraMatrix_left,
                                       cameraMatrix2=cameraMatrix_right,
                                       distCoeffs1=distCoeffs_left,
                                       distCoeffs2=distCoeffs_right,
                                       R=R, T=T,
                                       flags=cv2.CALIB_ZERO_DISPARITY,
                                       alpha=0,
                                       imageSize=(image_size.width, image_size.height),
                                       newImageSize=(image_size.width, image_size.height))[0:4]

    map_left_x, map_left_y = cv2.initUndistortRectifyMap(cameraMatrix_left, distCoeffs_left, R1, P1, (image_size.width, image_size.height), cv2.CV_32FC1)
    map_right_x, map_right_y = cv2.initUndistortRectifyMap(cameraMatrix_right, distCoeffs_right, R2, P2, (image_size.width, image_size.height), cv2.CV_32FC1)

    cameraMatrix_left = P1
    cameraMatrix_right = P2

    return cameraMatrix_left, cameraMatrix_right, map_left_x, map_left_y, map_right_x, map_right_y


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

# process agruments to get camera calibration
camera_calibration_available = False
manual_camera_calibration_available = False

class Resolution :
    width = 1280
    height = 720



# define video capture object as a threaded video stream

try:
    # to use a non-buffered camera stream (via a separate thread)
	import camera_stream
	zed_cam = camera_stream.CameraVideoStream(use_tapi=True)
	print("Done Use OpenCV default")
except BaseException:
    # if not then just use OpenCV default
    print("INFO: camera_stream class not found - camera input may be buffered")
    zed_cam = cv2.VideoCapture()
zed_cam.open()
width = 2048  # Set the desired width
height = 0  # Set the desired height
zed_cam.set(cv2.CAP_PROP_FRAME_WIDTH, width)
zed_cam.set(cv2.CAP_PROP_FRAME_HEIGHT, height)
################################################################################

# process config to get camera calibration from calibration file
# by parsing camera configuration as an INI format file
    
image_size = Resolution()
	
# Initialize frame counter and timestamp
frame_counter = 0
start_time = time.time()

    
if (zed_cam.isOpened()) :
	#Ros setup
	#192.168.2.108
	client = Ros(host='local.ip-adresse', port=9090)
	client.run()
	
    
	calibration_file = "/home/cfc/ros-camera-stream/SN30371250.conf"
	print("Calibration file found. Loading...")

	camera_matrix_left, camera_matrix_right, map_left_x, map_left_y, map_right_x, map_right_y = init_calibration(calibration_file, image_size)
	
	publisher = Topic(client, '/zed_stream', 'victor_msgs/Video')
	publisher.advertise()
    
	keep_processing = True
	
	# Get the default video dimensions
	width_CV = int(zed_cam.get(cv2.CAP_PROP_FRAME_WIDTH))
	height_CV = int(zed_cam.get(cv2.CAP_PROP_FRAME_HEIGHT))
	print(width_CV)
	print(height_CV)


	while (keep_processing):
		start_t = cv2.getTickCount()
		if zed_cam.isOpened():
			ret, frame = zed_cam.read()
			frame = frame.get()
			_, jpeg_frame = cv2.imencode('.jpg', frame)
			# Compress using GZip
			with gzip.open("/home/cfc/compressed_frame.gz", "wb") as f:
				f.write(jpeg_frame.tobytes())
        
			# Read the compressed data from the file
			with open("/home/cfc/compressed_frame.gz", "rb") as f:
				compressed_frame_data = f.read()
        
			# Encode as base64
			frame_data = base64.b64encode(compressed_frame_data).decode('utf-8')
			message = {
                'id': 'python-script',
                'timestamp': time.strftime('%Y-%m-%d %H:%M:%S', time.localtime()),
                'data': frame_data
            }
			publisher.publish(message)
			
			 # Increment frame counter
			frame_counter += 1
        
			# Calculate time elapsed
			elapsed_time = time.time() - start_time
        
			# Wait for next second if frame rate exceeds 30 fps
			if elapsed_time < frame_counter / 30:
			    wait_time = (frame_counter / 30) - elapsed_time
			    time.sleep(wait_time)
			
		#To display image on pi -> #cv2.imshow("CFC PI", frame)
		#somehow the key detector staplelize the frame latency throw the rosbridge ???
		stop_t = ((cv2.getTickCount() - start_t) / cv2.getTickFrequency()) * 1000
		wait_time = max(0, int((1000 / 30) - stop_t))
		kk = cv2.waitKey(wait_time)
		
		user_input = non_blocking_input("")
		if user_input is not None:
		    keep_processing = False
			
	zed_cam.release()
	client.terminate()
	print("stream and video closed")
else:
    print("Error - no camera connected.")
    

