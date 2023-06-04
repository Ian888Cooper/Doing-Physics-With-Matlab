% qmS001.m

% SPIN STATES for 1/2 spin particles

% 230314


clear 
close all
clc


% INPUTS Enter spinsor components >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  A(1) = 1+1i;
  A(2) = 2;
 
  B(1) = 1i;
  B(2) = 2;

% SPIN STATES: normalized spinors
  NA = sqrt( abs(A(1))^2 + abs(A(2)^2) );
  NB = sqrt( abs(B(1))^2 + abs(B(2)^2) );

  A = [A(1); A(2)];
  A = A./NA;
  B = [B(1); B(2)];
  B = B./NB;

% [3D] orientation in space spinor A
  [theta, phi, x, y, z] = Direction(A(1),A(2));
  [thetaB, phiB, xB, yB, zB] = Direction(B(1),B(2));

% Probabilty predictions
  probA = abs(A).^2;
  probB = abs(B).^2;

% INNER PRODUCTS
  AA = A'*A;
  BB = B'*B;
  AB = A'*B;
  BA = B'*A;

% OUTPUT =============================================================
 fprintf('A(1) = %2.3f %2.3fi   A(2) = %2.3f  %2.3fi   \n',real(A(1)),imag(A(1)), real(A(2)), imag(A(2)))
 fprintf('theta = %2.3f deg   phi = %2.3f deg \n', theta,phi)
 fprintf('x = %2.3f   y = %2.3f   z = %2.3f \n', x,y,z)
 disp('  ')
 fprintf('B(1) = %2.3f %2.3fi   B(2) = %2.3f  %2.3fi   \n',real(B(1)),imag(B(1)), real(B(2)), imag(B(2)))
 fprintf('thetaB = %2.3f deg   phiB = %2.3f deg \n', thetaB,phiB)
 fprintf('xB = %2.3f   yB = %2.3f   zB = %2.3f \n', xB,yB,zB)
 disp('  ')
 fprintf('Spin A measurement probabilities w.r.t. Z axis:  prob(+Z) = %2.3f   prob(-Z) = %2.3f \n', probA(1),probA(2))
 fprintf('Spin B measurement probabilities w.r.t. Z axis:  prob(+Z) = %2.3f   prob(-Z) = %2.3f \n', probB(1),probB(2))
 disp('  ')
 disp('Inner products')
 fprintf('A(1) = %2.3f %2.3fi   A(2) = %2.3f  %2.3fi   \n',real(A(1)),imag(A(1)), real(A(2)), imag(A(2)))
 fprintf('B(1) = %2.3f %2.3fi   B(2) = %2.3f  %2.3fi   \n',real(B(1)),imag(B(1)), real(B(2)), imag(B(2)))
 fprintf('AA = %2.3f  %2.3fi  BB = %2.3f  %2.3fi   \n',real(AA),imag(AA),real(BB),imag(BB))
 fprintf('AB = %2.3f  %2.3fi  BA = %2.3f  %2.3fi   \n',real(AB),imag(AB),real(BA),imag(BA))
 
% GRAPHICS =========================================================

figure(1)
   set(gcf,'units','normalized');
   set(gcf,'position',[0.06 0.05 0.15 0.22]);
   set(gcf,'color','w')
  
   plot3([0,x],[0,y],[0,z],'b','LineWidth',2)
   hold on
   plot3([0,xB],[0,yB],[0,zB],'r','LineWidth',2)
   
   ax = gca;
   ax.Box = 'on';
   ax.BoxStyle = 'full';
  
   Hplot = plot(0,0,'ko');
   set(Hplot,'markersize',8,'markerfacecolor','k')
   grid on
   xlim([-1 1])
   ylim([-1 1])
   zlim([-1 1])

   xlabel('x')
   ylabel('y')
   zlabel('z')

   ax = gca;
   ax.BoxStyle = 'full';
   set(gca,'fontsize',12)

%%
% clc
% theta = pi
% phi   = 0
% 
% [nP, nM] = spinN(theta,phi);
% nP



%%
% PAULI SPIN OPERATOR MATRICES ==========================================
% PX = [0 1; 1 0];
% PY = [0 -1i; 1i 0];
% PZ = [1 0; 0 -1];
% 
% zP = [1; 0];
% zM = [0; 1];
% 
% PP = (PX + 1i*PY)/2;
% PM = (PX - 1i*PY)/2;
% 
% PP*zP
% PP*zM
% PM*zP
% PM*zM
% 
% PX*PX
% PY*PY
% PZ*PZ
% 
% PX*PY
% 1i*PZ
% 
% PY*PZ
% 1i*PX
% 
% PZ*PX
% 1i*PY
% 
% % state s
% s = [3; 5]
% N = sqrt(s(1)^2+s(2)^2)
% s = s/N
% 
% zP'*s
% zM'*s

%%

% FUNCTIONS  ===========================================================
function [theta, phi, x, y, z] = Direction(s1,s2)
     s1Mag = abs(s1);
     theta = 2*acosd(s1Mag);
     phi1 = rad2deg(angle(s1));
     phi2 = rad2deg(angle(s2));
     phi = phi1 - phi2;
     x = sind(theta)*cosd(phi);
     y = sind(theta)*sind(phi);
     z = cosd(theta);
end

function [nP, nM] = spinN(theta,phi)
 %  nP = [ cos(theta/2)*exp(-1i*phi/2);  sin(theta/2)*exp(-1i*phi/2)];
   nP = [ cos(theta/2)*exp(1i*phi);  sin(theta/2)];

   nM = [ sin(theta/2)*exp(-1i*phi/2); -cos(theta/2)*exp(1i*phi/2)];
   
end
