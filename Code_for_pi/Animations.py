import sys
import select
import os
import time
import threading
import shutil
import wave
import simpleaudio as sa
import numpy as np
from optparse import OptionParser
from rgbmatrix import RGBMatrix, RGBMatrixOptions
from matrixdemos.scripts.get_file import get_file
from subprocess import Popen, DEVNULL
from matrixdemos import DATA_PATH
from PIL import Image
from scipy.io import wavfile
from PIL import ImageEnhance
from roslibpy import Ros, Topic


BOLD = '\033[1m'
ENDC = '\033[0m'

PATH = "/home/cfc/Documents/bonnet/rpi-rgb-led-matrix/MatrixDemos/matrixdemos/animations/"

DEMOS = sorted(os.listdir(PATH))
vDEMOS = DEMOS[:]
for e, d in enumerate(vDEMOS):
    vDEMOS[e] = BOLD + d + ENDC

usage = "usage: %prog [options] PATH"
epilog = f"""PATH should be any directory containing frames, or a demo animation.
The demo animation can be of the following: {', '.join(vDEMOS)}.
"""
parser = OptionParser(usage=usage, epilog=epilog)

parser.set_description("""Display an animation made of individual images
as frames.""")

parser.add_option("-f", dest="fps", type=int,
        help="sets the speed of animation (fps) [default 25]", default=None)

parser.add_option("-g", "--gif", dest="gif",
        help="the path to a gif animation or video to play", default=None)

parser.add_option("-l", "--loop", dest="loop", action="store_true",
        help="loop the animation", default=False)

parser.add_option("-n", "--loop-count", type=int, dest="loop_count",
        help="sets the number of times the animation loops", default=-1)

parser.add_option("-c", "--clear", action="store_true", dest="clear",
        help="clear the cache of a decoded animation", default=False)

(options, args) = parser.parse_args()

data = {"TMP_PATH" : None}

def connect_ros():
    client = Ros(host='local.ip-adresse', port=9090)
    client.run()
    an = Topic(client, '/avatar_matrix', 'victor_msgs/msg/String')
    return client, an
    

def lis(somthing):
    global key
    print("Received message type:", somthing)
    if somthing['ros_text'] == 'stop':
        key = "n"
    if somthing['ros_text'] == 'hi':
        key = "g"
    if somthing['ros_text'] == 'sleep':
        key = "d"

def load_audio(file_path):
    try:
        # Use scipy.io.wavfile to read the audio file
        samplerate, data = wavfile.read(file_path)
        return data, samplerate
    except Exception as e:
        print(f"Failed to load audio from {file_path}: {str(e)}")
        return None, None  # Handle the case where loading fails

def play_audio(audio_data, framerate):
    # Check if data type conversion is needed
    if audio_data.dtype != np.int16:
        # Normalize and convert (assuming the range is -1.0 to 1.0 for floats)
        audio_data = np.int16(audio_data/np.max(np.abs(audio_data)) * 32767)
    
    num_channels = 2 if audio_data.ndim > 1 and audio_data.shape[1] == 2 else 1
    play_obj = sa.play_buffer(audio_data, num_channels=num_channels, bytes_per_sample=audio_data.itemsize, sample_rate=framerate)
    play_obj.wait_done()

def decode_anim(anim):
    TMP_PATH = DATA_PATH + f"/cache-{anim.split('/')[-1]}/"
    if os.path.exists(TMP_PATH) and options.clear:
        print("Clearing frames cache...  ", end="")
        for x in os.listdir(TMP_PATH):
            os.remove(TMP_PATH + x)
        os.rmdir(TMP_PATH)
        print("done")
    new = False
    if not os.path.exists(TMP_PATH):
        os.mkdir(TMP_PATH)
        new = True
    if not new:
        new = not os.listdir(TMP_PATH)
    if not os.path.exists(anim):
        sys.stderr.write("Animation file not found\n")
        sys.exit(1)
    if os.path.isdir(anim):
        sys.stderr.write("ERR: Animation must not be a directory\n")
        sys.exit(1)
    if new:
        print("Decoding animation...  ", end="", flush=True)
        proc = Popen(["ffmpeg", "-i", anim, "-y", "-f", "image2", f"{TMP_PATH}img-%05d.png"], stdout=DEVNULL, stderr=DEVNULL)
        code = proc.wait()
        if code:
            sys.stderr.write("FFMPEG failed to decode the animation\n")
            sys.exit(1)
            print("done")
    else:
        print("Using cached frames.")
    shutil.chown(TMP_PATH, os.getlogin())
    data["TMP_PATH"] = TMP_PATH

GIF = options.gif
if GIF:
    if args:
        sys.stderr.write("Cannot play both an animation file and a directory\n")
        sys.exit(1)
    if not os.path.exists("/usr/bin/ffmpeg"):
        sys.stderr.write(f"This feature requires {BOLD}ffmpeg{ENDC}. You can install it with:\n\nsudo apt-get install ffmpeg\n")
        sys.exit(1)
    decode_anim(GIF)

FPS = options.fps
if FPS == None:
    FPS = 25
LOOP = options.loop
LOOP_COUNT = options.loop_count

_options = RGBMatrixOptions()
_options.rows = 64
_options.chain_length = 2
_options.parallel = 1
_options.hardware_mapping = 'adafruit-hat'
_options.drop_privileges = False

matrix = RGBMatrix(options=_options)

# Global dictionary to store animations
animations = {"smile": [], "sleep": [], "angry": [], "suprised": [], "hi": []}
sounds = {"smile": [], "sleep": [], "angry": [], "suprised": [], "hi": []}
def is_wav_file(filename):
    # Extract the file extension and check if it is '.wav'
    _, file_extension = os.path.splitext(filename)
    return file_extension.lower() == '.wav'


# Function to load animations
def load_anim(path, key):
    if not path.endswith("/"):
        path += "/"
    files = sorted(os.listdir(path))
    n_files = len(files)
    for e, f in enumerate(files):
        file_path = os.path.join(path, f)
        if is_wav_file(f):  # Check if it's a WAV file before attempting to load as audio
            print("Loading wave file: " + file_path)
            audio_data, framerate = load_audio(file_path)
            sounds[key].append((audio_data, framerate))  # Store as a tuple for easy access
            continue
        
        try:
            image1 = Image.open(file_path)
        except (IsADirectoryError, OSError):
            print(f"{f}: --Invalid Image--")
            continue
            
        image1.thumbnail((matrix.width, matrix.height), Image.ANTIALIAS)
        if image1.width < matrix.width or image1.height < matrix.height:
            image = Image.new("RGB", (matrix.width, matrix.height), (0, 0, 0))  # Black background
            adjusted_image = adjust_brightness(image1, 0.5)  # Reduce brightness to 50%
            image.paste(adjusted_image, (matrix.width // 2 - adjusted_image.width // 2, matrix.height // 2 - adjusted_image.height // 2))
            animations[key].append(image)
        else:
            dimed_image = adjust_brightness(image1, 1)
            animations[key].append(dimed_image)
        print(f"\rLoading images [{round((e+1)/n_files*100)}%]...   ", flush=True, end="")
    print("done")

def adjust_brightness(image, factor):
    if image.mode != 'RGB':
        image = image.convert('RGB') 
    enhancer = ImageEnhance.Brightness(image)
    return enhancer.enhance(factor) 

# Function to preload animations
def preload_animations():
    for demo, images in animations.items():
        demo_path = PATH + demo
        load_anim(demo_path, demo)
        if not images:
            sys.stderr.write(f"No suitable images were found in the {demo} demo folder\n")
            sys.exit(1)
            
def non_blocking_input(prompt):
    sys.stdout.write(prompt)
    sys.stdout.flush()
    ready, _, _ = select.select([sys.stdin], [], [], 0)
    if ready:
        return sys.stdin.readline().strip()
    return None

key = "waiting"

# Function to run the animations
def run():
    client, animationMatrix = connect_ros()
    animationMatrix.subscribe(lis)
    preload_animations()
    running = True
    playing = False
    global key
    while(running):
        if key == "waiting":
            continue
        else:
            if key == 'a':
                demo_images = animations.get("smile")
            if key == 's': 
                demo_images = animations.get("angry")  
            if key == 'd': 
                demo_images = animations.get("sleep")
            if key == 'f': 
                demo_images = animations.get("suprised")
            if key == 'g': 
                demo_images = animations.get("hi")
                audio_data, framerate = sounds["hi"][0]
                audio_thread = threading.Thread(target=play_audio, args=(audio_data, framerate))
                playing = True
            if key == 'n':
                client.terminate()
                sys.stderr.write("Programm closed")
                sys.exit(1)
                
            
            if playing:
                audio_thread.start()
                print("Audio is playing..")
                playing = False   
            if not key == "waiting":
                catch = key
                for img in demo_images:
                    matrix.SetImage(img)
                    time.sleep(1 / FPS)
                if key == catch:
                    key = "waiting"


# Main function
def main():
    try:
        run()
    except KeyboardInterrupt:
        print()

if __name__ == "__main__":
    main()
