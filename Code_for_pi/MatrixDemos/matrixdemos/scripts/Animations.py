import sys
import select
import os
import time
import shutil
from optparse import OptionParser
from rgbmatrix import RGBMatrix, RGBMatrixOptions
from matrixdemos.scripts.get_file import get_file
from subprocess import Popen, DEVNULL
from matrixdemos import DATA_PATH
from PIL import Image

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
animations = {"smile": [], "sleep": [], "angry": [], "suprised": [], "hi": [], "face": []}

# Function to load animations
def load_anim(path, key):
    if not path.endswith("/"):
        path += "/"
    files = sorted(os.listdir(path))
    n_files = len(files)
    for e, f in enumerate(files):
        try:
            image1 = Image.open(path + f)
        except (IsADirectoryError, OSError):
            print(f"{f}: --Invalid Image--")
            continue
            
        image1.thumbnail((matrix.width, matrix.height), Image.ANTIALIAS)
        if image1.width < matrix.width or image1.height < matrix.height:
            image = Image.new("RGB", (matrix.width, matrix.height), 0)
            image.paste(image1, (matrix.width // 2 - image1.width // 2, matrix.height // 2 - image1.height // 2))
            animations[key].append(image.convert("RGB"))
        else:
            animations[key].append(image1.convert("RGB"))
        print(f"\rLoading images [{round((e+1)/n_files*100)}%]...   ", flush=True, end="")
    print("done")

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

# Function to run the animations
def run():
    preload_animations()
    key = input("Press 'a' = smile, 's' = angry, 'd' = sleep, 'f' = suprised, 'g' = hi, 'f' = face, 'n' = cancel \n")
    running = True
    user_input = None
    while(running):
        if user_input is not None:
            if user_input != key:
                key = user_input
                
        if not key:
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
            if key == 'f': 
                demo_images = animations.get("face")
            if key == 'n':
                sys.stderr.write("Programm closed")
                sys.exit(1)
            for img in demo_images:
                matrix.SetImage(img)
                time.sleep(1 / FPS)
        user_input = non_blocking_input("")

# Main function
def main():
    try:
        run()
    except KeyboardInterrupt:
        print()

if __name__ == "__main__":
    main()
