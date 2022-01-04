function [I] = createBinPattern(w, h, T, xShift)
    x = 0:w-1;
    p = mod(x+xShift, T);
    b = floor(2*p/T);
    I = repmat(b, [h, 1]);
end