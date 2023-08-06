% QMG23A.m

% DOING PHYSICS WITH MATLAB
% https://d-arora.github.io/Doing-Physics-With-Matlab/
% Documentation
% https://d-arora.github.io/Doing-Physics-With-Matlab/mpDocs/QMG2D.htm
% IAN COOPER
% matlabvisualphysics@gmail.com
% 230512   Matlab R2021b

clear; close all;clc
% INPUTS
   N = 801;
   xMin = -0.5; xMax = 0.5;  % x range [nm]
   x1 = 0.5;                 % width of truncated potential well [nm]
   U0 = -400;                % well depth [eV]

% Graphical display for the state with quantum qn
   qn = 1;
%  Orthonormal startes  qn1  qn2
   qn2 = 2; 
%  Figure 21 Animation of wavefunction & prob. density
%     Save animated gif:  flag1 =  (0 no) / (1 yes) 
      flag1 = 1;    
%  flagC: 1 plot single stationary state / 2 plot compound state
      flagC = 2;

% CONSTANTS ========================================================
  h    = 6.62607015e-34;
  hbar = 1.05457182e-34;
  me    = 9.1093837e-31;
  e    = 1.60217663e-19;
  Ls = 1e-9; Es = e;      % scaling factors
  Cs = -hbar^2/(2*me*Ls^2*Es);

% SETUP  ===========================================================
  qn1 = qn;
  x = linspace(xMin,xMax, N);

% Potential well 
  U = zeros(N,1);
  U_matrix = zeros(N-2);
    
   for cn = 1 : N
   if abs(x(cn))<=x1/2,   U(cn) = -(4*U0/(x1*x1))*x(cn)^2+U0; end
   end  

% Make potential energy matrix
  dx = (x(2)-x(1));
  dx2 = dx^2;
  for cn = 1:(N-2)
    U_matrix(cn,cn) = U(cn+1);
  end

% KINETIC ENERGY and HAMILTONIAN MATRICES ============================
% Second Derivative Matrix 
    off = ones(N-3,1);                 
    SD_matrix = (-2*eye(N-2) + diag(off,1) + diag(off,-1))/dx2;
% KE Matrix
    K_matrix = Cs * SD_matrix;            
% Hamiltonian Matrix
   H_matrix = K_matrix + U_matrix;


% EIGENVALUES and EIGENFUNCTIONS =====================================
   [e_funct, e_values] = eig(H_matrix);

% All Eigenvalues 1, 2 , ... n  where E_N < 0
   flagE = 0;
   n = 1;
while flagE == 0
    E(n) = e_values(n,n);
    if E(n) > 0, flagE = 1; end 
    n = n + 1;
end  
    E(n-1) = [];
    n = n-2;

% Corresponding Eigenfunctions 1, 2, ... ,n: Normalizing the wavefunction
    psi = zeros(N,n); area = zeros(1,n);
for cn = 1 : n
    psi(:,cn) = [0; e_funct(:,cn); 0];
    area(cn) = simpson1d((psi(:,cn) .* psi(:,cn))',xMin,xMax);
  if psi(5,cn) < 0, psi(:,cn) = -psi(:,cn); end  % curve starts positive
end % for
    psi = psi./sqrt(area);
    probD = psi.* psi;
    PROB = simpson1d(probD',xMin,xMax);


% SINGLE QUANTUM STATE and EXPECTATION VALUES  qn  ==================
   K = E(n) -U;          % kinetic energy  (eV)
   EB = -E(qn);            % binding energy  (eV)
   bra = psi(:,qn)';
   Psi = psi(:,qn)';

% probability
  ket = Psi;
  braket = bra .* ket;
  Prob = simpson1d(braket,xMin,xMax);

% position x
  ket = x .* Psi;
  braket = bra .* ket;
  xavg = simpson1d(braket,xMin,xMax);

% position x^2
  ket = (x.^2) .* Psi;
  braket = bra .* ket;
  x2avg = simpson1d(braket,xMin,xMax);

% momentum ip      change length units from nm to m
  ket = gradient(Psi,x)* hbar / Ls;
  braket = bra .* ket;
  ipavg = simpson1d(braket,xMin,xMax);

% momentum ip^2    chnage length unit from nm to m
  psi1 = gradient(Psi,x);
  ket = -gradient(psi1,x) * hbar^2 / Ls^2;
  braket = bra .* ket;
  ip2avg = simpson1d(braket,xMin,xMax);

% potential energy U
  ket = U' .* Psi;
  braket = bra .* ket;
  Uavg = simpson1d(braket,xMin,xMax);

% kinetic energy K
  psi1 = gradient(Psi,x);
  ket = - (hbar^2/(2*me))* gradient(psi1,x) / (Ls^2*Es);
  braket = bra .* ket;
  Kavg = simpson1d(braket,xMin,xMax);

% total energy
  psi1 = gradient(Psi,x);
  ket = - (hbar^2/(2*me))* gradient(psi1,x) / (Ls^2*Es) + (U.*Psi')';	
  braket = bra .* ket;
  Eavg = simpson1d(braket,xMin,xMax);

% Calculate uncertainites 
deltax = sqrt(x2avg - xavg^2) * Ls;         % length units nm to m
deltaip = sqrt(ip2avg + ipavg^2);            % unit N.s
dxdp = (deltax * deltaip)/hbar;              % N.s.m = J.s   (SI unit)


% Two quantum numbers for two states qn1  qn2
%    to test normalization or that two different 
%    eigenvectors are orthogonal to each other orthogonal
%    Evaluate integral -------------------------------------------
     bra = psi(:,qn1)';
     ket = psi(:,qn2)';
     braket = bra .* ket;
     integral = round(simpson1d(braket,xMin,xMax));

% Theortical calculations  =========================================
  k = -8*(U0*Es)/(x1*Ls)^2;
  w = sqrt(k/me);
  ET = ((1:n)-0.5).*hbar*w/e + U0 ;


% TIME EVOULTION OF STATIONARY STATE qn ============================
  NT = 81;
  E1 = abs(U0)+E(qn); E2 = abs(U0)+E(qn2);
  w1 = E1*Es/hbar;  w2 = E2*Es/hbar;
  TN = 2*pi/w1;
  psi1 = psi(:,qn);  psi2 = psi(:,qn2);
  tNmin = 0;
  tNmax = 3*TN;
  tN = linspace(tNmin,tNmax,NT);
  PSI1 = zeros(N,NT); PSI2 = zeros(N,NT);

  for cN = 1:NT
      PSI1(:,cN) = psi1.*exp(-1i*w1*tN(cN));
      PSI2(:,cN) = psi2.*exp(-1i*w2*tN(cN));
  end

  PROB_D1 = conj(PSI1).*PSI1; PROB_D2 = conj(PSI2).*PSI2;

% COMPOUND STATE ===================================================
    c1 = 2; c2 = 5;
    A = c1^2+c2^2; c1 = c1/sqrt(A); c2 = c2/sqrt(A);
    PSI = c1.*PSI1 + c2.*PSI2;
    PROB_D = conj(PSI).*PSI;
% Expection position <x>
    xAVG = zeros(NT,1); 
    for cN = 1:NT
        fn = conj(PSI2(:,cN)).*x'.*PSI1(:,cN);
        xAVG(cN) = simpson1d(fn',xMin,xMax);
    end


% ANIMATION SETUP ===================================================
% (0 no)  (1 yes) for flag1
%   flag1 = 0;    
% file name for animated gif   
    ag_name = 'agQMG23A.gif'; 
% Delay in seconds before displaying the next image  
    delay = 0.00; 
% Frame to start
    frame1 = 0;  


% OUTPUT =============================================================
% Display eigenvalues in Command Window
  disp('   ');
  disp('================================================================  ');
  disp('  ');
  fprintf('No. bound states found =  %0.0f   \n',n);
  disp('   ');
  disp('Quantum State / Eigenvalues  En / Theory ET  (eV)');

for cn = 1 : n
    fprintf('  %0.0f   ',cn);
    fprintf('   %0.5g   ',E(cn));
    fprintf('         %0.5g   \n',ET(cn));
end    

% Display results of calculations in Command Window
  disp('  ');
  disp('  ');
  fprintf('Quantum number, n  =  %0.0g   \n',qn);
  fprintf('Energy, E =  %0.6g  eV \n',E(qn));
  fprintf('Total Probability = %0.6g   \n',Prob);
  fprintf('<x> = %0.6g   nm\n',xavg);
  fprintf('<x^2> = %0.6g   nm^2\n',x2avg);
  fprintf('<ip> = %0.6g   N.s\n',ipavg);
  fprintf('<ip^2> = %0.6g   N^2.s^2\n',ip2avg);
  fprintf('<U> = %0.6g   eV\n',Uavg);
  fprintf('<K> = %0.6g   eV\n',Kavg);
  fprintf('<E> = %0.6g   eV\n',Eavg);
  fprintf('<K> + <U> = %0.6g   eV\n',Kavg+Uavg);
  disp('  ')
  fprintf('deltax,dx = %0.6g  m \n',deltax);
  fprintf('deltap,dp = %0.6g   N.s\n',deltaip);
  fprintf('(dx dp)/hbar = %0.6g   \n',dxdp);
  disp('Stationary states qn1 and qn2  ')
  fprintf('qn1 =  %0.0f     qn2 = %0.0f  \n',qn1, qn2);
  fprintf('Integral =  %0.1f  \n',integral);
  if integral < 0.5
    disp('Wavefunctions are orthogonal');
  else
    disp('Wavefunction is normalized');
  end 
   

% GRAPHICS  ======================================================

figure(21)  
   set(gcf,'units','normalized');
   set(gcf,'position',[0.05 0.05 0.25 0.40]);
   set(gcf,'color','w');
   FS = 14;

   for cN = 1:NT
subplot(2,1,1)
       xP = x'; yP = real(PSI1(:,cN));
       plot(xP,yP,'b','LineWidth',2);
       if flagC == 2
          hold on
          yP = real(PSI2(:,cN));
          plot(xP,yP,'r','LineWidth',2);
          yP = real(PSI(:,cN));
          plot(xP,yP,'k','LineWidth',2);
       end
       xticks(-0.5:0.25:0.5)
       ylim([-4 4])
       grid on
       xlabel('x  [ nm ]'); ylabel('\Psi(x,t)')
       txt = sprintf('qn1 = %2.0f    qn2 = %2.0f   \n',qn1,qn2);
       title(txt,'FontWeight','normal')
       set(gca,'FontSize',FS)
       hold off
subplot(2,1,2)
       xP = x'; yP = PROB_D1(:,cN); 
       plot(xP,yP,'b','LineWidth',1);
       if flagC == 2
          hold on
          yP = PROB_D2(:,cN); 
          plot(xP,yP,'r','LineWidth',1);
          yP = PROB_D(:,cN); 
          plot(xP,yP,'k','LineWidth',2)
       end
       xticks(-0.5:0.25:0.5)
       ylim([0 12])
       grid on
       xlabel('x  [nm ]'); ylabel('|\Psi(x,t)|^2')
       set(gca,'FontSize',FS)
       hold off
  
  if flag1 > 0
         frame1 = frame1 + 1;
         frame = getframe(21);
         im = frame2im(frame);
         [imind,cm] = rgb2ind(im,256);
      % On the first loop, create the file. In subsequent loops, append.
         if frame1 == 1
           imwrite(imind,cm,ag_name,'gif','DelayTime',delay,'loopcount',inf);
         else
          imwrite(imind,cm,ag_name,'gif','DelayTime',delay,'writemode','append');
         end
  end 
       pause(0.01)
       
  end

figure(1)  % 1111111111111111111111111111111111111111111111111111111
   set(gcf,'units','normalized');
   set(gcf,'position',[0.05 0.6 0.25 0.25]);
   set(gcf,'color','w');
   FS = 14;
   
   plot(x,U,'b','LineWidth',2);
   set(gca,'fontsize',14)
   xlabel('position x  [ nm ]','FontSize',14);
   ylabel('energy U, E_n   [ eV ]','FontSize',14);
   hold on

  cnmax = length(E);
for cn = 1 : cnmax
  ys(1) = E(cn);
  ys(2) = ys(1);
  plot([xMin xMax],ys,'r','LineWidth',2);
  hold on
end %for   
  axis([xMin-eps xMax min(U)-50 max(U)+50]);

% Plots first 5 wavefunctions & probability density functions
if n < 6
    nMax = n;
else
    nMax = 5;
end
  xticks(-0.5:0.25:0.5)

figure(9)  % 99999999999999999999999999999999999999999999999999999
  set(gcf,'units','normalized');
  set(gcf,'position',[0.305 0.05 0.25 0.25]);
  set(gcf,'color','w');
  FS = 14;

  xP = x; yP = U;
  plot(xP,yP,'b','LineWidth',2)
  grid on
  xticks(-0.5:0.25:0.5)
  xlabel('x  [ nm ]')
  ylabel('U  [ eV ]')
  title('Potential energy function','FontWeight','normal')
  set(gca,'FontSize',FS)
   
figure(2)  % 222222222222222222222222222222222222222222222222222222
  clf
  set(gcf,'Units','Normalized');
  set(gcf,'Position',[0.305 0.38 0.30 0.50]);
 % set(gcf,'NumberTitle','off');
 % set(gcf,'Name','Eigenvectors & Prob. densities');
  set(gcf,'Color',[1 1 1]);
  FS = 14;
  %nMax = 8;
  for cn = 1:nMax
    subplot(nMax,2,2*cn-1);
    y1 = psi(:,cn) ./ (max(psi(:,cn)-min(psi(:,cn))));
    y2 = 1 + 2 * U ./ (max(U) - min(U));
    plot(x,y1,'m','lineWidth',2)
    hold on
    plot(x,y2,'b','lineWidth',1)
    %plotyy(x,psi(:,cn),x,U);
    axis off
    %title('\psi cn);
    title_m = ['\psi   n = ', num2str(cn)] ;
    title(title_m,'Fontsize',14);
    
    subplot(nMax,2,2*cn);
    y1 = probD(:,cn) ./ max(probD(:,cn));
    y2 = 1 + 2 * U ./ (max(U) - min(U));
    plot(x,y1,'m','lineWidth',2)
    hold on
    plot(x,y2,'b','lineWidth',1)
    title_m = ['\psi^2   n = ', num2str(cn)] ;
    title(title_m,'Fontsize',14);
    axis off
  end

  
% Graphical display for quantum state qn  % 33333333333333333333333333
figure(3) 
   set(gcf,'units','normalized');
   set(gcf,'position',[0.56 0.05 0.25 0.25]);
   set(gcf,'color','w');
   FS = 14;
   left_color = [0 0 1];
   right_color = [1 0 1];
   
   yyaxis left
   plot(x,U,'b-','linewidth',2)
   hold on
   plot(x,K,'k-','linewidth',2);
   plot([xMin xMax], [-EB -EB],'r-','linewidth',2)
   legend('U','K','E','Orientation','horizontal','location','northeast','AutoUpdate','off','box','off')
 %  ylim([-1.1*U0 1.5*U0])
   txt = sprintf('qn = %2.0f  \n',qn);
   title(txt,'fontweight','normal')
   grid on
   set(gca,'YColor',left_color);
   xticks(-0.5:0.25:0.5)

   yyaxis right
   plot(x,psi(:,qn),'m','linewidth',2)
   hold on
   plot([xMin xMax],[0 0],'m-','linewidth',0.5)
   ylabel('   \psi','fontsize',16,'rotation',0)
   set(gca,'ytick',[])
   set(gca,'YColor',right_color);
   xlabel('position x [ nm ]');
   set(gca,'FontSize',FS)
   
figure(4)  % 4444444444444444444444444444444444444444444444444444444444
 %  set(gcf,'Name','Schrodinger Equation: Bound States');
 %  set(gcf,'NumberTitle','off');
   set(gcf','Units','normalized')
   set(gcf,'Position',[0.58 0.38 0.25 0.3]);
   set(gcf,'Color',[1 1 1]);
   left_color = [0 0 1];
   right_color = [1 0 1];
   axes('position',[0.1 0.48 0.75 0.35]);
   
   yyaxis left
   plot(x,U,'b-','linewidth',2)
   hold on
   plot([xMin xMax], [-EB -EB],'r-','linewidth',2)
   legend('U','E','Orientation','horizontal','location','northeast','AutoUpdate','off','box','off')
   xticks(-0.5:0.25:0.5)
%   ylim([-1.1*U0 10])
   xlabel('x  [nm]')
   txt = sprintf('qn = %2.0f  \n',qn);
   title(txt,'fontweight','normal')
   grid on
   set(gca,'YColor',left_color);
   set(gca,'fontsize',14)
    
   yyaxis right
   plot(x,probD(:,qn),'m','linewidth',2)
   hold on
   plot([xMin xMax],[0 0],'m-','linewidth',0.5)
   ylabel('     \psi^2','fontsize',16,'rotation',0)
   set(gca,'ytick',[])
   set(gca,'YColor',right_color);
   

% Each point represents the location of the particle after
%    a measuerment is made on the system 
   axes('position',[0.1 0.05 0.75 0.25]);
   hold on
   num1 = 10000;
   axis off

for c = 1 : num1
  xIndex = ceil(1+(N-2)*rand(1,1));
  yIndex = rand(1,1);
  pIndex = max(probD(:,n))*rand(1,1);
   if pIndex < probD(xIndex,qn)
   plot(x(xIndex),yIndex,'s','MarkerSize',2,'MarkerFaceColor','m','MarkerEdgeColor','none');
   end
end
   set(gca, 'Xlim',[xMin xMax]);
   set(gca, 'Ylim',[0,1]);
   set(gca,'FontSize',14)
hold off
  
figure(5)  % 5555555555555555555555555555555555555555555555555555555
   set(gcf,'units','normalized');
   set(gcf,'position',[0.73 0.05 0.25 0.40]);
   set(gcf,'color','w');
   FS = 14;
   
   bra = psi(:,qn)';
   ket = x .* psi(:,qn)';
   braket = bra .* ket;
    
subplot(3,1,1)
   plot(x,Psi,'m','LineWidth',2);
   grid on
   ylabel('bra  \psi');
   tm1 = '<x>  =  ';
   tm2 = num2str(xavg,'%2.2f');
   tm3 = '  nm';
   tm = [tm1 tm2 tm3];
   title(tm);  
   set(gca,'fontsize',FS)
   xticks(-0.5:0.25:0.5)
subplot(3,1,2)
   plot(x,ket,'b','LineWidth',2);
   grid on
   ylabel('ket  x \psi ');
   set(gca,'fontsize',FS)
   xticks(-0.5:0.25:0.5)
subplot(3,1,3);
   plot(x,braket,'b');
   fill(x,braket,'r')
   grid on
   ylabel('bra ket  \psi x \psi');
   hold on
   plot([xavg xavg],[min(min(braket)) max(max(braket))],'lineWidth',3);
   xlabel('position x [ nm ]');
   hold off
   set(gca,'fontsize',FS)
   xticks(-0.5:0.25:0.5)

% <x> time evolution
figure(7)  % 77777777777777777777777777777777777777777777777777
   set(gcf,'units','normalized');
   set(gcf,'position',[0.5 0.5 0.2 0.2]);
   set(gcf,'color','w');
   FS = 14;
   
   xP = tN./1e-19; yP = real(xAVG);
   plot(xP,yP,'b','LineWidth',2)
   title('<x>','FontWeight','normal')
   xlabel('t  [ fs ]'); ylabel('<x>  [ nm ]')
   grid on
   set(gca,'FontSize',FS)


% CLASSICAL PARTICLE   11111111111111111111111111111111111111111111111
  xC = linspace(-0.9999, 0.9999, 9999);
  pd = (1/pi)./sqrt(1-xC.^2);
  check = simpson1d(pd,-0.9999,0.9999);
figure(11)
   set(gcf,'units','normalized');
   set(gcf,'position',[0.72 0.38 0.20 0.20]);
   set(gcf,'color','w');
   FS = 14;
   plot(xC,pd,'r','LineWidth',2)
   title('Classical particle: prob. density','FontWeight','normal')
   xlabel('x'); ylabel('prob. density')
   grid on
   text(-0.35,20,'probability = 1.00','FontSize',14)
   set(gca,'FontSize',FS)