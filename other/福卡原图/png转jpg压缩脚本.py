import cv2

def convert(filename: str):
    img = cv2.imread(filename)

    h,w,_ = img.shape
    print(w,h)
    img = cv2.resize(img,(int(w),int(h)))

    cv2.imwrite(filename.split('.')[0]+'.jpg',img)

import os

for filename in filter(lambda x:'.png' in x,os.listdir()):
    convert(filename)