using Printf
"""
From Reynolds (2020) (Eq2-4)
Calculates the radius of the inner most stable circular orbit of the a black hole,
with spin a_star, and mass M.
"""
function r_isco(a_star, M)
    a = a_star
    r_g = M
    z1 = 1 + ∛(1 - a^2) * (∛(1 + a) + ∛(1 - a))
    z2 = √(3 * a^2 + z1^2)
    if a >= 0
        r_isco = (3 + z2 - √((3 - z1) * (3 + z1 + 2 * z2))) * r_g
    elseif a < 0
        r_isco = (3 + z2 + √((3 - z1) * (3 + z1 + 2 * z2))) * r_g
    end
end

"""
From Page & Thorne (1974) (Eq15n)
Calculates the function f at radius r, for a black hole of spin a_star, and mass M, 
which is used to calculate the flux given by its accretion disk.
"""
function flux(r, a_star, M)
    R_isco = r_isco(a_star, M)
    x = √(r / M)
    x0 = √(R_isco / M)
    x1 = 2 * cos((1 / 3) * (acos(a_star)) - (π / 3))
    x2 = 2 * cos((1 / 3) * (acos(a_star)) + (π / 3))
    x3 = -2 * cos((1 / 3) * (acos(a_star)))

    flux =
        (3 / (2 * M)) *
        (1 / (x^2 * (x^3 - (3 * x) + (2 * a_star)))) *
        (
            x - x0 - ((3 / 2) * a_star * log(x / x0)) -
            (3 * (x1 - a_star)^2) / (x1 * (x1 - x2) * (x1 - x3)) *
            log((x - x1) / (x0 - x1)) -
            (3 * (x2 - a_star)^2) / (x2 * (x2 - x1) * (x2 - x3)) *
            log((x - x2) / (x0 - x2)) -
            (3 * (x3 - a_star)^2) / (x3 * (x3 - x1) * (x3 - x2)) *
            log((x - x3) / (x0 - x3))
        )
end

function mdot(M)
    # need something here to convert M into SI units, as M_☼ is in SI, althought we 
    # aren't currently clear about what the units M currently is in
    # would look something like:
    # M_kg = M*c^2
    # L_edd = 3e4*L_☼*(M_kg/M_☼)

    L_edd = 3e4 * L_☼ * (M / M_☼)
    Mdot = -L_edd / (c^2 * η)
    mdot = -0.1 * Mdot
end

function diss(mdot, r, a_star, M)
    diss = ((c^6) / (G^2)) * mdot * flux(r, a_star, M) / (4 * π * r)
end

function temperature(r, a_star, M)
    m_dot = mdot(M)
    temperature = (diss(m_dot, r, a_star, M) / σ_SB)^(1 / 4)
end

function wiens_law(T)
    # calculates Wien's displacement law
    # T: temperature, in Kelvin
    wiens_law = b/T

end

# constants
G = 6.67e-11
c = 3e8
L_☼ = 3.8e26
M_☼ = 1.99e30
σ_SB = 5.67e-8
η = 0.1
b = 2.90e-3 # Wien's displacement constant
M = 1.0
a = 0.05

#  J. Jiménez-Vicente et al 2014 ApJ 783 47 DOI 10.1088/0004-637X/783/1/47 says that the width of an accretion disk of a 
# quasar averages 4.5 (-1.2 or + 1.5) light days 
# http://www.scholarpedia.org/article/Accretion_discs says:
#M/M_☼ * 10e6 *10e-2 (for a supermassive black hole) # between 10e6 - 10e11 * M/M_☼ cm , choose 10e6 for now.

# so for now I will use 4.5 light days ie. 1.16e14 m

r_outer = 1.16e14

r_in = r_isco(a, M)
r_max = r_in + r_outer
dist_step = 1e13

filename = "temps.txt"
file = open(filename, "w")

write(file, "radius, temp, λ \n")

for radius in range(start = r_in+dist_step, stop = r_max, step = dist_step)
    # we cant use r_in as it has T=0 and we get infinite wavelength

    temp = temperature(radius, a, M)
    wavelength = wiens_law(temp)
    
    write(file, " $radius , $temp, $wavelength \n" )
end

close(file)
