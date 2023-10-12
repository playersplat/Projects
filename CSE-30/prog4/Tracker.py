# -*- coding: utf-8 -*-
"""
Created on Thu May 25 02:07:14 2020
CSE 30 Spring 2020 Program 4 starter code
@author: Fahim
"""

import cv2
import numpy as np
import math
class BoundBox:
    def __init__(self):
        self.fullList = []
        self.upperList = []
        self.lowerList = []
        self.peopleList = []
        self.particleList = []
        self.counter = 0
    def clearBox(self):
        self.fullList.clear()
        self.upperList.clear()
        self.lowerList.clear()
        self.peopleList.clear()
    def checkBound(self):
        for i in self.peopleList:
            for j in self.peopleList:
                if i != j:
                    x1 = i[0] + int(i[2]/2)
                    y1 = i[1] + int(i[3]/2)
                    x2 = j[0] + int(i[2]/2)
                    y2 = j[1] + int(i[3]/2)
                    dist = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
                    if (i[0] + i[2]) > j[0] and i[0] < (j[0] + j[2]) and (i[1] + i[3]) > j[1] and i[1] < (j[1] + j[3]):
                        i[4] = 1
                        j[4] = 1
                    elif dist < 100:
                        i[4] = 2
                        j[4] = 2
    def drawBody(self, image):
        COLOR = (0, 0, 0)
        for i in self.peopleList:
            if i[4] == 0:
                COLOR = (255, 0, 0)
            elif i[4] == 1:
                COLOR = (0, 0, 255)
            elif i[4] == 2:
                COLOR = (0, 255, 255)
            cv2.rectangle(image, (i[0], i[1]), (i[0] + i[2], i[1] + i[3]), COLOR, 2)
            self.particleList.append([i[0] + int(i[2]/2), i[1] + int(i[3]/2), i[4], 5, 0])
    def drawSD(self, image):
        x = 0
        y = 0
        z = 0
        for i in self.peopleList:
            if i[4] == 0:
                x += 1
            elif i[4] == 1:
                y += 1
            elif i[4] == 2:
                z += 1
        cv2.putText(image, "People Following SD: {}".format(str(x)), (10, 20), cv2.FONT_HERSHEY_SIMPLEX,
                        .5, (255, 0, 0), 2)
        cv2.putText(image, "SD Violations: {}".format(str(y)), (10, 60), cv2.FONT_HERSHEY_SIMPLEX,
                        .5, (0, 0, 255), 2)
        cv2.putText(image, "Possible SD Violations: {}".format(str(z)), (10, 100), cv2.FONT_HERSHEY_SIMPLEX,
                    .5, (0, 255, 255), 2)
    def drawParticle(self, image):
        COLOR = (255, 0, 0)
        for x in self.particleList:
            if x[2] == 1:
                COLOR = (0, 0, 255)
            elif x[2] == 2:
                COLOR = (0, 255, 255)
            else:
                COLOR = (255, 0, 0)
            cv2.circle(image, (x[0], x[1]), x[3], COLOR, -1)
            if x[3] > 0 and x[4] > 25: #x[4] is a counter that every 25 calls the size of the circle gets smaller (x[3]) by 1
                x[3] -= 1
                x[4] = 0
            x[4] += 1

    def addFull(self, x):
        self.fullList.append(x)
    def addUpper(self, x):
        self.upperList.append(x)
    def addLower(self, x):
        self.lowerList.append(x)


    def removeMask(self, x, image):
        if x == self.fullList:
            for i in x:
                cv2.rectangle(image, (i[0] + int(i[2]/3.3), i[1]), (i[0] - int(i[2]/3.3) + i[2] , i[1] + i[3]), (0,0,0), -1)
        if x == self.upperList:
            for i in x:
                cv2.rectangle(image, (i[0] + int(i[2]/3.3), i[1]), (i[0] - int(i[2]/3.3) + i[2], i[1] + int(i[3] * 2.5)), (0,0,0), -1)
    def combineList(self):
        for i in self.fullList:
            self.peopleList.append(i)
        for i in self.upperList:
            i[3] = int(i[3] * 2)
            self.peopleList.append(i)
        for i in self.lowerList:
            i[1] = int(i[1] - i[3]/2)
            i[3] = int(i[3] + i[3]/2)
            self.peopleList.append(i)
        maxLength = len(self.peopleList)
        i = 0
        while i < maxLength:
            j = 0
            while j < maxLength:
                if i != j:
                    box1 = self.peopleList[i]
                    box2 = self.peopleList[j]
                    if box1[0] < box2[0] < box1[0] + box1[2] and box1[1] < box2[1] and box2[1] < box1[1] + box1[3]:
                        self.peopleList.remove(self.peopleList[i])
                        maxLength -= 1
                        i = 0
                        break
                j += 1
            i += 1


dist = 50 #the amount of pixels that would be later used
cap = cv2.VideoCapture('Sample1.webm') #the video I'm using
#cap = cv2.VideoCapture(0)
frame_width = int( cap.get(cv2.CAP_PROP_FRAME_WIDTH)) #part of sample code

frame_height =int( cap.get( cv2.CAP_PROP_FRAME_HEIGHT)) #part of sample code

fourcc = cv2.VideoWriter_fourcc(*'XVID') #part of sample code
out = cv2.VideoWriter('output.avi',fourcc, 20.0, (640,480)) #part of sample code

ret, frame1 = cap.read() #read a frame
ret, frame2 = cap.read() #read next frame
test = BoundBox() #class function

cascade1 = cv2.CascadeClassifier('haarcascade_fullbody.xml')
cascade2 = cv2.CascadeClassifier('haarcascade_upperbody.xml')
cascade3 = cv2.CascadeClassifier('haarcascade_lowerbody.xml')

while cap.isOpened(): #as long as cap is open
    diff = cv2.absdiff(frame1, frame2) #takes the absolute difference of frame1 and frame2 |(frame2 pixels - frame1 pixels)| only moving parts would remain
    gray = cv2.cvtColor(diff, cv2.COLOR_BGR2GRAY) #cvtColor, grayscales frame
    blur = cv2.GaussianBlur(gray, (5,5), 0) #blurs the frame
    _, thresh = cv2.threshold(blur, 20, 255, cv2.THRESH_BINARY)
    dilated = cv2.dilate(thresh, None, iterations=3)
    contours, _ = cv2.findContours(dilated, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE) #not an image - list of contours
    test.clearBox() #clears the lists
    for contour in contours:
        (x, y, w, h) = cv2.boundingRect(contour)
        if cv2.contourArea(contour) < 700: #how many pixels are in the contour, if it's less then X then ignore it
            continue

        cv2.rectangle(dilated, (x - dist, y - dist), (x+w + dist, y+h + dist), (255, 255, 255), -1) #used to make a mask of the image
        #cv2.drawContours(frame1, contours, -1, (0, 255, 0), 2)
    image = cv2.resize(frame1, (640,480)) #frame1 and resolution size
    mask = cv2.resize(dilated, (640,480)) #the mask image
    comb = cv2.bitwise_and(image, image, mask = mask) #bitwise the image to combine the original image and the mask

    body1 = cascade1.detectMultiScale(comb, 1.3, 5) #detects fullbody first then calls the removeMask
    for (x, y, w, h) in body1:
        test.addFull([x, y, w, h, 0])
    test.removeMask(test.fullList, comb)
    body2 = cascade2.detectMultiScale(comb, 1.3, 5) #similar to the previous three lines or so
    for (x, y, w, h) in body2:
        test.addUpper([x, y, w, h, 0])
    test.removeMask(test.upperList, comb)
    body3 = cascade3.detectMultiScale(comb, 1.3, 5)
    for (x, y, w, h) in body3:
        test.addLower([x, y, w, h, 0])

    test.combineList() #combines the list
    test.checkBound() #checks the bound of the list and changes i[4] based on distance
    test.drawSD(image) #draws the letters and counts how many people are on the screen
    test.drawBody(image) #draws the body
    test.drawParticle(image) #draws the particle dot

    out.write(image)
    cv2.imshow("feed", image) #change 'image' to 'mask' and then 'comb' to see how method 1 and method 2 are used
    frame1 = frame2
    ret, frame2 = cap.read()
    if cv2.waitKey(40) == 27:
        break
cap.release()
out.release()
cv2.destroyAllWindows()