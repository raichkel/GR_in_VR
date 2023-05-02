#Author: Joel Mills

#Junk code to test that pixel-wise multiplication of 2 grayscale images works as intended
#application to ensure final accretion disc texture smoothly tapers to black at the edges

using Images
using FileIO

path = "project/src/pre_computation/images/texture.png"
disc_image = Gray.(load(path))
path2 = "project/src/pre_computation/images/colour_gradient.jpg"
smooth_image = Gray.(load(path2))

for i in eachindex(disc_image)
    disc_image[i] *= smooth_image[i]
end

save("project/test_frames/pixelwise.png", reverse(disc_image; dims = 1))