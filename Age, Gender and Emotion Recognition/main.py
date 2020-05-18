# Importing essential libraries 
import numpy as np
import cv2
import os
import random
from keras.preprocessing.image import img_to_array
from datetime import datetime
import csv

from files import model_files
from pyimagesearch.centroidtracker import CentroidTracker

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
confidence = 0.9

# Loading files
face_model = model_files.face_net()
emo_labels, emotion_model = model_files.emotion_net()
gen_labels, gender_model = model_files.gender_net()
age_labels, age_model = model_files.age_net()

ct = CentroidTracker(maxDisappeared=30, maxDistance=50)

# For database
data = []
key = ['Channel_id', 'House_id', 'User_id', 'Timestamp', 'Age', 'Gender', 'Emotion']

# Video input source 
cam = cv2.VideoCapture(0)
(H, W) = (None, None)

# Creating Video writer to save video // Keep the video writer frame dimensions same as the final frame dimensions// 
# fourcc = cv2.VideoWriter_fourcc(*'XVID')
# out = cv2.VideoWriter('recognition.avi', fourcc, 10, (400, 350))

# The While loop 
while True:
    ret, frame = cam.read()
    if ret is False:
        break

    frame = cv2.resize(frame, (400, 350))
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    if W is None or H is None:
        (H, W) = frame.shape[:2]
    
    blob = cv2.dnn.blobFromImage(frame, 1.0, (W, H), (104.0, 177.0, 123.0))
    face_model.setInput(blob)
    detections = face_model.forward()
    detected_faces = []

    for i in np.arange(0, detections.shape[2]):
        if detections[0, 0, i, 2] > confidence:
            box = detections[0, 0, i, 3:7] * np.array([W, H, W, H])
            (startx, starty, endx, endy) = box.astype("int")
            detected_faces.append(box.astype("int"))    

    faces = ct.update(detected_faces)       

    for face, (user_id, cent) in zip(detected_faces, faces.items()):
        startx, starty, endx, endy = face

        # Face region and preprocessing
        groi = gray[starty:endy, startx:endy].copy()
        roi = frame[starty:endy, startx:endy].copy()

        try:
            img = cv2.resize(groi, (48, 48))
            img = img.astype("float") / 255.0
            img = img_to_array(img)
            img = np.expand_dims(img, axis=0)   
            blob = cv2.dnn.blobFromImage(roi, 1, (227, 227), (78.4263377603, 87.7689143744, 114.895847746), swapRB=False)

            # Predict Emotion
            emo_preds = emotion_model.predict(img)[0]
            label = emo_labels[emo_preds.argmax()]

            # Predict Gender
            gender_model.setInput(blob)
            gender_preds = gender_model.forward()
            gender = gen_labels[gender_preds[0].argmax()]

            # Predict Age
            age_model.setInput(blob)
            age_preds = age_model.forward()
            age = age_labels[age_preds[0].argmax()]
                
            # Posting information
            content = [("Emotion", label), ("Gender", gender), ("Age", age)]
            for (i, (k, v)) in enumerate(content):
                text = "{}: {}".format(k, v) 
                cv2.putText(frame, text, (startx, starty - i*10 - 5),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.45, (255, 255, 0), 1)
            cv2.putText(frame, "Id {}".format(user_id), (cent[0] - 20, cent[1] - 20),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 0), 1)


            # Sending data to database
            entry = [1, 1, user_id, str(datetime.now()), age, gender, label]
            data.append(dict(zip(key, entry)))
            # print(dict(zip(key, entry)))
            # print("\n")

            r = random.randint(0,255); g = random.randint(0,255); b = random.randint(0,255)
        except:
            r = 0; g = 0; b = 0
            pass 

        cv2.rectangle(frame, (startx, starty), (endx, endy), (r, g, b), 2)

    # out.write(frame)
    cv2.imshow("People's Meter", frame)
    if cv2.waitKey(1) & 0xFF == 27:
        break
    
# out.release()
cam.release()
cv2.destroyAllWindows()

# Create a .csv file of the data 
csv_file = "People's meter data.csv"
try:
    with open(csv_file, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=key)
        writer.writeheader()
        for dict in data:
            writer.writerow(dict)
    print(".csv file is created")
except IOError:
    print("I/O error")
