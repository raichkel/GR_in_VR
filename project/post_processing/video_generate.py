# Author: Rachel Kane
# file to generate video from series of frames, works but creates very large video. FFmpeg method more recommened.


import os
import cv2 
import re

# function to sort a list of file names in numerical order
numbers = re.compile(r'(\d+)')
def numericalSort(value):
    parts = numbers.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts

# Video Generating function
def generate_video():
    image_folder = 'colouriser\colourised' # make sure to use your folder
    video_name = 'GR_video.avi'
    
    
    # ensure that the list of images is sorted in the correct order
    images = [img for img in sorted(os.listdir(image_folder), key=numericalSort)
              if img.endswith(".jpg") or
                 img.endswith(".jpeg") or
                 img.endswith("png")]
     
    # Array images should only consider
    # the image files ignoring others if any
    print(images) 
  
    frame = cv2.imread(os.path.join(image_folder, images[0]))
  
    # setting the frame width, height width
    # the width, height of first image
    height, width, layers = frame.shape  
  
    video = cv2.VideoWriter(video_name, 0, 60, (width, height)) 

    # Appending the images to the video one by one
    for image in images: 
        video.write(cv2.imread(os.path.join(image_folder, image))) 
      
    # Deallocating memories taken for window creation
    cv2.destroyAllWindows() 
    video.release()  # releasing the video generated



#print(sorted(os.listdir("colouriser\colourised"), key=numericalSort))
# Calling the generate_video function
generate_video()