#Junk code to test that pixel-wise multiplication of 2 grayscale images works as intended
#application to ensure final accretion disc texture smoothly tapers to black at the edges

using Images
using FileIO

path = "/Users/joel_mills/Documents/GR_in_VR/image3.png"
disc_image = Gray.(load(path))
path2 = "/Users/joel_mills/Documents/GR_in_VR/style5.jpg"
smooth_image = Gray.(load(path2))

for i in eachindex(disc_image)
    disc_image[i] *= smooth_image[i]
end

save("/Users/joel_mills/Documents/GR_in_VR/gray_disc4.png", reverse(disc_image; dims = 1))