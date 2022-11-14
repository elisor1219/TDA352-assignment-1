%Plots the data given from java

clc;clf;clear;
%Immporting the data from java
data = importdata("data.txt", "|");
X = data(1)+1;
dataHiding = data(2:X+1);
dataBinding = data(X+2:end);

%% Plot the hiding prob.
hold off; clc;
x = linspace(0,X-1);
plot(0:X-1, dataHiding);
hold on
plot(x, 2.^(-(x + 1)))

legend("Simulation", "2^{-(x+1)}", "FontSize",12)
title("Probability of breaking the hiding property", "FontSize",14)
xlabel("X = truncation point", "FontSize",15)
ylabel("Probability", "FontSize",15)

saveas(gcf, "hiding.png");clf;

hold off;clf;
%Plot a shorter version
shortPoint = 8;
x = linspace(0,shortPoint);
plot(0:shortPoint, dataHiding(1:shortPoint+1));
hold on
plot(x, 2.^(-(x + 1)))

legend("Simulation", "2^{-(x+1)}", "FontSize",12)
title("Probability of breaking the hiding property", "FontSize",14)
xlabel("X = truncation point", "FontSize",15)
ylabel("Probability", "FontSize",15)

saveas(gcf, "hidingShort.png");
%% Plot the binding prob.
hold off; clf;
x = linspace(0,X-1);
plot(0:X-1, dataBinding);
hold on
plot(x, 2.^(-x))

legend("Simulation", "2^{-x}", "FontSize",12)
title("Probability of breaking the binding property", "FontSize",14)
xlabel("X = truncation point", "FontSize",15)
ylabel("Probability", "FontSize",15)

saveas(gcf, "binding.png");clf;

hold off;clf;
%Plot a shorter version
shortPoint = 8;
x = linspace(0,shortPoint);
plot(0:shortPoint, dataBinding(1:shortPoint+1));
hold on
plot(x, 2.^(-x))

legend("Simulation", "2^{-x}", "FontSize",12)
title("Probability of breaking the binding property", "FontSize",14)
xlabel("X = truncation point", "FontSize",15)
ylabel("Probability", "FontSize",15)

saveas(gcf, "bindingShort.png");