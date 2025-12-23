from flask import Flask, send_file
import os

app = Flask(__name__)

# SET VIDEO FILES PATH
# EXAMPLE: '<Local Video Address>/1.mp4' => 'D:/test/1.mp4'
VIDEO_PATH1 = '/1.mp4'
VIDEO_PATH2 = '/2.mp4'
VIDEO_PATH3 = '/3.mp4'
VIDEO_PATH4 = '/4.mp4'
VIDEO_PATH5 = '/5.mp4'
VIDEO_PATH6 = '/6.mp4'

# THE URL PATH OF VIDEO PATH
@app.route('/video1')
def video1():
    return send_file(VIDEO_PATH1)

@app.route('/video2')
def video2():
    return send_file(VIDEO_PATH2)

@app.route('/video3')
def video3():
    return send_file(VIDEO_PATH3)

@app.route('/video4')
def video4():
    return send_file(VIDEO_PATH4)

@app.route('/video5')
def video5():
    return send_file(VIDEO_PATH5)

@app.route('/video6')
def video6():
    return send_file(VIDEO_PATH6)

if __name__ == '__main__':
    # RUN IN 0.0.0.0，this allows other devices within the LAN to access it as well.
    app.run(host='0.0.0.0', port=5000)