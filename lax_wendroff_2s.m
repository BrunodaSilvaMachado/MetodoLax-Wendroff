%=====================================================================
%
% 1D Advection equation solution
% Lax-Wendroff two step
% Bruno Da Silva Machado
%
% UFF - Volta Redonda, RJ, Brazil
% Out 05th, 2021
%=====================================================================
%

function [] = lax_wendroff_2s()
N = 120; % divisões da malha
max_t = 0.5; %tempo total
Lx = 1.0; %comprimento
%deltt = [0.0025,0.005,0.0075,0.01]
deltt = 0.005; % passo de tempo
C = 1.0;

deltx = Lx/N;
x = (0:deltx:1)';
CFL = deltt/deltx;
maxIters = round(max_t/deltt);
lambda = C * CFL;

Flux = @(q) 0.5 * q.^2; %fluxo
Q_E = zeros(1, N+1); %solução exata
Q_E(1:0.5/deltx) = 1; %condição inicial
Q_n = Q_E;
Q_n_1 = Q_n;
residualA = zeros(1,maxIters);
% Iteração no tempo
figure(1)
for n = 1: maxIters
    % 1 passo
    Q_n_u = 0.5 * (Q_n(3:N+1) + Q_n(2:N)) - 0.5 * lambda * (Flux(Q_n(3:N+1)) - Flux(Q_n(2:N)));
    Q_n_d = 0.5 * (Q_n(2:N) + Q_n(1:N-1)) - 0.5 * lambda * (Flux(Q_n(2:N)) - Flux(Q_n(1:N-1)));
    % 2 passo
    Q_n_1(2:N) =  Q_n(2:N) - lambda*(Flux(Q_n_u) - Flux(Q_n_d));
    %residuo
    residualA(n) = abs(norm(Q_n_1) - norm(Q_n));
    
    Q_n = Q_n_1;
    %plote
    plot (x, Q_n, x,Q_E,'--','LineWidth',1.5);
    drawnow;
    %calcula a solução exata
    Q_E(Q_n > 0.1) = 1;
end
% Gráfico da solução ( distribuição de temperatura )
grid on;
legend({'Lax-Wendroff','Exato'},'Location','southwest');
title (sprintf('Método de Lax-Wendroff %s = %g','{\lambda}',lambda));
xlabel ('x','fontsize',14);
ylabel ('Q','fontsize',14);
figure(2)
plot(log10(residualA),'LineWidth',2);grid on;
title ('Residuos Lax-Wendroff');
xlabel ('Numero de Iterações','fontsize',14);
ylabel ('Residuo [log]','fontsize',14);
end
