import pyaudio
import time
from roslibpy import Ros, Topic
import sys
import select

def connect_ros():
    client = Ros(host='local.ip-adresse', port=9090)
    client.run()
    audioPublisher = Topic(client, '/mic_stream', 'victor_msgs/Audio', queue_size=10)
    audioSubscriber = Topic(client, '/mic_stream/stop', 'victor_msgs/msg/String')
    audioPublisher.advertise()
    return client, audioPublisher, audioSubscriber
    
streaming = True;

def lis(somthing):
    global streaming
    print("Received message type:", somthing)
    if somthing['ros_text'] == 'stop':
        streaming = False;
     
def audio_callback(in_data, frame_count, time_info, status, publisher):
    message = {
        'id': 'python-script',
        'timestamp': time.strftime('%Y-%m-%d %H:%M:%S', time.localtime()),
        "data": list(in_data)
    }
    publisher.publish(message)
    return None, pyaudio.paContinue

def record_and_publish():
    RESPEAKER_RATE = 16000
    RESPEAKER_CHANNELS = 1
    RESPEAKER_WIDTH = 2
    RESPEAKER_INDEX = 0
    CHUNK = 4096

    p = pyaudio.PyAudio()
    client, audioPublisher, audioSubscriber = connect_ros()

    stream = p.open(
        rate=RESPEAKER_RATE,
        format=pyaudio.paInt16,
        channels=RESPEAKER_CHANNELS,
        input=True,
        frames_per_buffer=CHUNK,
        input_device_index=RESPEAKER_INDEX,
        stream_callback=lambda *args: audio_callback(*args, publisher=audioPublisher)
    )
   
    audioSubscriber.subscribe(lis)
    while streaming :
        time.sleep(0.1)
        
    print("* done recording")
    stream.stop_stream()
    stream.close()
    p.terminate()
    client.terminate()

if __name__ == '__main__':
    record_and_publish()
