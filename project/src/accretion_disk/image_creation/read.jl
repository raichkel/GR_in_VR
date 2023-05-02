#Author: Joel Mills

#Junk code to test seam removal is working as expected
#basically replace pixel values along the seam with the average of their immediate horizontal neighbours

using Images
using FileIO

image_file = "project/test_frames/colour_frame_2708.png"
disc_image = Gray.(load(image_file))
image_y, image_x = size(disc_image)
image_y_mid = image_y ÷ 2
image_x_mid = image_x ÷ 2

for y in 1:image_y_mid
    disc_image[y, image_x_mid] = (disc_image[y, image_x_mid-1])/2 + (disc_image[y, image_x_mid+1])/2
end

save("project/test_frames/seamless.png", disc_image)