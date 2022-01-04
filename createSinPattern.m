function [I] = createSinPattern(w, h, T, xShift)
    x = 0:w-1;
    b = 0.5 + 0.5 * cos(2*pi * (x+xShift) / T);
    I = repmat(b, [h, 1]);
end