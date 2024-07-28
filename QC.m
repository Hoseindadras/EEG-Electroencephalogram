
params.Fs = EEG.srate; % Sampling frequency
params.tapers = [3 5]; % Time-bandwidth product and number of tapers
params.fpass = [0 100]; % Frequency range of interest
params.pad = 0; % Padding factor for FFT
params.trialave = 1; % Average over trials (epochs)

% Number of bootstrap samples
nBoot = size(EEG.data,3);

% Example for a specific channel (e.g., channel 1)
channel_data = squeeze(EEG.data(1, :, :)); % Data for channel 1 across all epochs

% Initialize array to store bootstrap PSD estimates
bootstrap_pxx = zeros(nBoot, length(f));

% Perform bootstrapping
for i = 1:nBoot
    
    
    % Compute PSD for resampled data
    bootstrap_pxx(i, :) = mtspectrumc(channel_data(:,i), params);
end

% Compute the mean and standard deviation of the bootstrap samples
mean_pxx = mean(bootstrap_pxx);
std_pxx = std(bootstrap_pxx);

% Compute confidence intervals (e.g., 95% confidence interval)
conf_interval = [mean_pxx - 1.96 * std_pxx; mean_pxx + 1.96 * std_pxx];

figure;
plot(f, 10*log10(mean_pxx), 'LineWidth', 1.5); % Plot PSD
hold on;
plot(f, 10*log10(conf_interval(1, :)), 'r--', 'LineWidth', 1); % Lower confidence interval
plot(f, 10*log10(conf_interval(2, :)), 'r--', 'LineWidth', 1); % Upper confidence interval
hold off;
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density with Multitaper Method');
legend('PSD', 'Lower CI', 'Upper CI');
grid on;




