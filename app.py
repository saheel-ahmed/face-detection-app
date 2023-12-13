from flask import Flask, jsonify, request
import dlib
from skimage import io
import requests
from io import BytesIO

app = Flask(__name__)

@app.route('/detect_face', methods=['POST'])
def detect_face():
    try:
        # Get the image URL from the JSON request
        data = request.get_json()
        image_url = data.get('image_url')

        # Perform face detection
        result = check_face_presence(image_url)

        # Respond with the result
        response = {'result': result, 'message': 'Success'}
        return jsonify(response), 200
    except Exception as e:
        # Handle exceptions
        response = {'result': None, 'message': str(e)}
        return jsonify(response), 500

def check_face_presence(image_url):
    detector = dlib.get_frontal_face_detector()

    # Use requests to download the image with SSL verification disabled
    response = requests.get(image_url, verify=False)

    # Check if the request was successful
    if response.status_code == 200:
        # Convert the raw image content to a BytesIO object
        img_bytesio = BytesIO(response.content)

        # Load the image from BytesIO
        img = io.imread(img_bytesio)

        # Perform face detection
        dets = detector(img, 1)

        # Check if a face is detected
        if len(dets) > 0:
            print('Valid face detected.')
            return True
        else:
            print('No valid face detected.')
            return False
    else:
        print(f'Failed to fetch image: {response.status_code}')
        return False

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3223, debug=False)
