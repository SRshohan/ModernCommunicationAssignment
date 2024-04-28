% MATLAB PROGRAM <ExDSSS.m>
% Extended to handle multiple SIR values and plot corresponding PSDs

clear; clf;
Ldata = 20000;      % data length in simulation; Must be divisible by 8
Lc = 11;            % spreading factor vs data rate.

% Generate QPSK modulation symbols
data_sym = 2*round(rand(Ldata, 1)) - 1 + j*(2*round(rand(Ldata, 1)) - 1);
jam_data = 2*round(rand(Ldata, 1)) - 1 + j*(2*round(rand(Ldata, 1)) - 1);

% Generating a spreading code
pcode = [1 1 1 -1 -1 -1 1 -1 -1 1 -1]';

% Now spread
x_in = kron(data_sym, pcode);

% SIR values to simulate
SIR_values = [5, 8, 10, 20];

for SIR = SIR_values
    Pj = 2*Lc/(10^(SIR/10)); % Calculate jamming power based on SIR
    noiseq = randn(Ldata*Lc, 1) + j*randn(Ldata*Lc, 1); % Power is 2

    % Create jamming signal
    jam_mod = kron(jam_data, ones(Lc, 1));
    jammer = sqrt(Pj/2)*jam_mod.*exp(j*2*pi*0.12*(1:Ldata*Lc)).';

    % Calculate and plot PSD
    [P, x] = pwelch(jammer+x_in, [], [], [4096], Lc, 'twosided');
    figure;
    semilogy(x - Lc/2, fftshift(P));
    axis([-Lc/2 Lc/2 1.e-2 1.e2]);
    grid;
    title(sprintf('CDMA Signal + Narrowband Jammer PSD at SIR = %d dB', SIR));
    xlabel('frequency (in unit of 1/T_s)');
    ylabel('Power Spectral Density');
end
