% multiple frequency phase unwrapping pipelines
clear all
close all

% swap width and height
w = 912;
h = 1140;

T1 = 18;
T2 = T1 * 8;
T3 = 912;

nStep1 = 9;
nStep2 = 3;
nStep3 = 3;

xShift = 0;

GF = fspecial('Gaussian', [9, 9], 9/3);

% high frequency 
I = zeros([h, w, nStep1]);
for N = 0 : nStep1 - 1
    xShift = N * T1 / nStep1 + nStep1/3;
    I0 = createBinPattern(w, h, T1, xShift);
    fileName = sprintf('calib/V_I_%02d.png', N);
    imwrite(I0, fileName);
    % apply Gaussian filter to smooth out noise
    I1 = imfilter(I0, GF, 'same');
    I(:, :, N + 1) = I1;
end
% compute low frequency phase
ph1 = computePhase(I, nStep1);

figure
% check whether at point T1 the phase is the smallest
% if not you need change xShift
plot(ph1(250, 1:2*T1+2));
grid on


% median frequency

Im1 = zeros([h, w, nStep2]);
for N = 0 : nStep2 - 1
    xShift = N * T2/3 + T2/2 + 1;
    I0 = createSinPattern(w, h, T2, xShift);
    % dithe sinusoidal pattern to binary
    Ib = dither(uint8(I0 * 255));
    fileName = sprintf('calib/V_I_%02d.png', N + nStep1);
    imwrite(Ib, fileName);
    
    % apply filter 
    % Note the pattern has to be converted to double before applying filter
    I1 = imfilter(double(Ib), GF, 'same');
    Im1(:, :, N+1) = I1;
end 
ph2 = computePhase(Im1, nStep2);

% check whether at point T2 the phase is the smallest
% if not you need change xShift
figure
plot(ph2(250, 1:2*T2+2));
grid on


% low frequeny 
Im2 = zeros([h, w, nStep3]);
for N = 0 : nStep3-1
    xShift = N * T3/3 + T3/2 + 1;
    I0 = createSinPattern(w, h, T3, xShift);
    Ib = dither(uint8(I0 * 255));
    fileName = sprintf('calib/V_I_%02d.png', N + nStep1 + nStep2);
    imwrite(Ib, fileName, 'BitDepth', 1);
    I1 = imfilter(double(Ib), GF, 'same');
    Im2(:, :, N+1) = I1;
end 
% wrapped phase 2 as unwrapped phase
ph3 = computePhase(Im2, nStep3);

% check whether the first point is close to be the smallest
% if not you need change xShift
figure
plot(ph3(250, :));
grid on

% you may apply Gaussian filter to smooth ph3 here
% if the noise is found too large

% unwrap phase 2
k2 = (ph3*T3/T2 - ph2)/(2*pi);

% check whether k2 is near integer number
figure
plot(k2(250, :));
grid on

uph2 = round(k2)*(2*pi) + ph2;

% check whether median-frequency phase is properly unwrapped
figure
plot(uph2(250, :));
grid on

% you may apply Gaussian filter to smooth uph2 here
% if the noise is found too large

% unwrap phase 1
k1 = (uph2 * T2/T1 - ph1) / (2*pi);

% check whether k1 is near integer number
figure
plot(k1(250, :));
grid on

uph = round(k1)*(2*pi) + ph1;
% check whether high-frequency phase is properly unwrapped
figure
plot(uph(250, :));
grid on

% if there are  unwrapping spikes
% median filter to the phase map
uphf = medfilt2(uph, [7, 7]);
% find those 2*pi problems and remove them
k0 = (uphf - uph)/(2*pi);
uph = uph + round(k0) * 2*pi;




