clear; clc; close all;

r_max = 100;
targets = [70 45 0.3 210; 40 150 0.2 45];
r = linspace(0, r_max, 500);
a = 0:359;

figure('Color', 'k');

subplot(2,2,1);
h1 = plot(r, zeros(size(r)), 'g');
set(gca, 'Color', 'k', 'XColor', 'g', 'YColor', 'g'); grid on;
xlim([0 r_max]); ylim([0 2.5]);
xlabel('Range (km)'); ylabel('Amplitude'); title('A-Scan', 'Color', 'g');

subplot(2,2,2);
I = 0.05*rand(length(r), length(a));
for k = 1:2
    dA = abs(mod(a - targets(k,2) + 180, 360) - 180);
    I = I + exp(-((r(:) - targets(k,1))/2).^2) * exp(-(dA/6).^2);
end
imagesc(a, r, I); axis xy;
colormap(gca, [zeros(256,1) linspace(0,1,256)' zeros(256,1)]);
set(gca, 'XColor', 'g', 'YColor', 'g');
xlabel('Azimuth (deg)'); ylabel('Range (km)'); title('B-Scan', 'Color', 'g');

ax = polaraxes('Position', [0.25 0.05 0.5 0.42], 'Color', 'k', 'ThetaZeroLocation', 'top', 'ThetaDir', 'clockwise');
hold(ax, 'on'); rlim(ax, [0 r_max]); ax.GridColor = 'g'; ax.RAxis.Color = 'g'; ax.ThetaColor = 'g';
title(ax, 'PPI', 'Color', 'g');
sweep = polarplot(ax, [0 0], [0 r_max], 'g-', 'LineWidth', 1.5);
blips = polarplot(ax, 0, 0, 'g.', 'MarkerSize', 15);

az = 0;
while ishandle(ax) && ishandle(h1)
    set(sweep, 'ThetaData', deg2rad([az az]));
    [x, y] = pol2cart(deg2rad(targets(:,2)), targets(:,1));
    x = x + targets(:,3).*cosd(targets(:,4));
    y = y + targets(:,3).*sind(targets(:,4));
    [th, rr] = cart2pol(x, y);
    targets(:,1) = rr; targets(:,2) = mod(rad2deg(th), 360);
    set(blips, 'ThetaData', th, 'RData', rr);

    amp = 0.05*rand(size(r));
    for k = 1:2
        dA = abs(mod(az - targets(k,2) + 180, 360) - 180);
        amp = amp + exp(-(dA/6)^2) * exp(-((r - targets(k,1))/2).^2);
    end
    set(h1, 'YData', amp);

    az = mod(az + 3, 360);
    drawnow; pause(0.02);
end
