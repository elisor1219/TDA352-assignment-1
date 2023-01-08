% Plot the binding prob.
clc;clf;
x = 0:30;
sigmoidFun = @(x) 1 ./ (1 + exp(17 - x));
hold on
%Plot the binding property sigmoid function
plot(x, 1 - sigmoidFun(x), "LineWidth", 2);
%Plot the hiding property sigmoid function
plot(x, sigmoidFun(x), "LineWidth", 2);
plot(17, 0.5, 'black o', "LineWidth", 1, 'MarkerFaceColor','black')
grid on

textInLegend = ["Binding: $1 - \frac{1}{1 \, + \, \exp ({17 - x})}$", "Hiding: $\frac{1}{1 \, + \, \exp ({17 - x})}$"];
legend(textInLegend, "FontSize", 20, 'Location','northwest', 'Interpreter','latex')
title("Probability of breaking the binding and hiding property", "FontSize",14)
xlabel("X = truncation point", "FontSize",15)
ylabel("Probability", "FontSize",15)
axis([0, 30, 0, 1.2])


hold off
saveas(gcf, "sigmoidBindingHidingPlot.png")

