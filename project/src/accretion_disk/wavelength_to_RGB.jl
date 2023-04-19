function wav2RGB(wavelength)
    
    # converts wavelength to RGB value
    # input:
    # wavelength, nm
    
    # returns:
    # RGB value
    
    w = trunc(wavelength)
    # colour
    if (w >= 380 && w < 440)
        R = -(w - 440.) / (440. - 350.)
        G = 0.0
        B = 1.0
    elseif (w >= 440 && w < 490)
        R = 0.0
        G = (w - 440.) / (490. - 440.)
        B = 1.0
    elseif (w >= 490 && w < 510)
        R = 0.0
        G = 1.0
        B = -(w - 510.) / (510. - 490.)
    elseif (w >= 510 && w < 580)
        R = (w - 510.) / (580. - 510.)
        G = 1.0
        B = 0.0
    elseif (w >= 580 && w < 645)
        R = 1.0
        G = -(w - 645.) / (645. - 580.)
        B = 0.0
    elseif (w >= 645 && w <= 780)
        R = 1.0
        G = 0.0
        B = 0.0
    else
        R = 0.0
        G = 0.0
        B = 0.0
    end

    # intensity correction
    if (w >= 380 && w < 420)
        SSS = 0.3 + 0.7*(w - 350) / (420 - 350)
    elseif (w >= 420 && w <= 700)
        SSS = 1.0
    elseif (w > 700 && w <= 780)
        SSS = 0.3 + 0.7*(780 - w) / (780 - 700)
    else
        SSS = 0.0
    end

    RGB{N0f8}(SSS*R, SSS*G, SSS*B)
end