import pyaudio
import wave
import time
from roslibpy import Ros, Topic
from flask import Flask, send_file, jsonify, request
import threading
import os

app = Flask(__name__)
PID = os.getpid()


@app.route('/download', methods=['POST'])
def get_wav():
    # Replace 'path_to_wav_file' with the actual path to your WAV file
    wav_file_path = '/home/cfc/Music/audio_file.wav'
    return send_file(wav_file_path,mimetype="audio/wav", as_attachment=True)
    
 
@app.route('/health')
def health_check():
    return jsonify({'status': 'OK'}) 

def connect_ros():
    global auPub
    client = Ros(host='local.ip-adresse', port=9090)
    client.run()
    auPub = Topic(client, '/mic_stream/download', 'victor_msgs/Audio', queue_size=10)
    audioSubscriber = Topic(client, '/mic_record/value', 'victor_msgs/msg/String')
    auPub.advertise()
    return client, audioSubscriber
    
streaming = False;

def lis(somthing):
    global streaming
    print("Received message type:", somthing)
    if somthing['ros_text'] == 'start':
        streaming = True;
    if somthing['ros_text'] == 'stop':
        streaming = False;
    if somthing['ros_text'] == 'download':
        upload()

def upload():
    if server_thread.is_alive():
        print("still running")
    else:
        server_thread.start()

def run_server():
    app.run(host='0.0.0.0', port=5000)        
        
def record_and_save():
    global streaming
    while streaming == False:
        print("waiting")
        time.sleep(1)
    
    RESPEAKER_RATE = 16000
    RESPEAKER_CHANNELS = 1
    RESPEAKER_WIDTH = 2
    RESPEAKER_INDEX = 0
    CHUNK = 4096

    p = pyaudio.PyAudio()

    # Open a new wave file for writing
    wf = wave.open('/home/cfc/Music/audio_file.wav', 'wb')
    wf.setnchannels(RESPEAKER_CHANNELS)
    wf.setsampwidth(pyaudio.get_sample_size(pyaudio.paInt16))
    wf.setframerate(RESPEAKER_RATE)

    # Open an audio stream for recording
    stream = p.open(
    rate=RESPEAKER_RATE,
    format=pyaudio.paInt16,
    channels=RESPEAKER_CHANNELS,
    input=True,
    frames_per_buffer=CHUNK,
    input_device_index=RESPEAKER_INDEX
    )

    print("Recording...")

    # Record audio data and write it to the wave file
    while streaming:
        data = stream.read(CHUNK)
        wf.writeframes(data)

    # Close the audio stream and wave file when done recording
    stream.stop_stream()
    stream.close()
    wf.close()

    # Terminate the PyAudio instance
    p.terminate()
    print("done recording")
    while True:
        record_and_save()
        
server_thread = threading.Thread(target=run_server)

if __name__ == '__main__':
    client, auSub = connect_ros()
    auSub.subscribe(lis)
    record_and_save()

