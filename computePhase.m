function [ph, Idp] = computePhase(I, nStep)
    c = 0;
    s = 0;
    s0 = 0;
    for N = 0 : nStep - 1
        c = c + I(:, :, N+1) * cos(2*pi * N / nStep);
        s = s + I(:, :, N+1) * sin(2*pi * N / nStep);
        s0 = s0 + sin(2*pi * N / nStep)^2;
      %  Ip = Ip + I(:, :, N+1)/nStep;
    end
    ph = -atan2(s, c)+pi;
    Idp = (s.^2 + c.^2).^0.5*2/nStep;
%     figure
%     imagesc(Idp);
%     colormap(gray);
%     colorbar
end
