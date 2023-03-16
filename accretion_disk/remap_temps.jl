using CSV
using Printf
using DataFrames

# reading in data for radius, temp, and λ
filename = "accretion_disk/temps.csv"
df = CSV.read(filename, DataFrame)
wavelengths = df."λ"

# visible light spectrum has wavelengths of
min_visible = 380e-9 #m
max_visible = 750e-9 #m
length_visible = max_visible - min_visible


# mapping the λ spectrum to the visible wavelenth spectrum

min_wave = minimum(wavelengths)
max_wave = maximum(wavelengths)
length_λ = max_wave - min_wave

# so every length_ratio will be a new integer wavelength
# convert from λ to visible by length_ratio
length_ratio = length_λ/length_visible

λ_diff = wavelengths .- min_wave

new_wavelengths = λ_diff * (1/length_ratio) .+ min_visible

# saving the remapped wavelengths to a new column in the dataframe
df."λ_visible" = new_wavelengths

CSV.write("accretion_disk\\temps.csv", df)
