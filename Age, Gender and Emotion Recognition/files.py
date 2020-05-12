## Importing all model files
import os
import cv2
from keras.models import load_model

# Directory path 
dir_path = "C:/Viren/Work/BE Project/Sem 8/Age, Gender and Emotion Recognition/"

class model_files():

    # Face detection cascade files 
    def face_net():
        caffe_model = os.path.join(dir_path, "models/res10_300x300_ssd_iter_140000.caffemodel")
        prototxt = os.path.join(dir_path, "models/deploy.prototxt")
        return cv2.dnn.readNetFromCaffe(prototxt, caffe_model)
        
    # Emotion recognition model
    def emotion_net():
        emotion_model_path = os.path.join(dir_path, "models/Fer2013.h5")
        EMOTIONS = ["Angry" ,"Disgust","Scared", "Happy", "Sad", "Surprised", "Neutral"]
        return EMOTIONS, load_model(emotion_model_path, compile=False)

    # Age recognition model
    def age_net():
        caffe_model = os.path.join(dir_path, "models/age_net.caffemodel")
        prototxt = os.path.join(dir_path, "models/age_deploy.prototxt")
        age_list = ['(0, 3)', '(4, 7)', '(8, 14)', '(15, 24)', '(25, 32)', '(33, 47)', '(48, 59)', '(60, 100)']
        return age_list, cv2.dnn.readNetFromCaffe(prototxt, caffe_model)

    # Gender recognition model
    def gender_net():
        caffe_model = os.path.join(dir_path, "models/gender_net.caffemodel")
        prototxt = os.path.join(dir_path, "models/gender_deploy.prototxt")
        gender_list = ['Male', 'Female']
        return gender_list, cv2.dnn.readNetFromCaffe(prototxt, caffe_model)