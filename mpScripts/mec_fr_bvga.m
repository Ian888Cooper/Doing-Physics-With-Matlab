% mec_fr_bvga.m

clear all
close all
clc

m = 2;
b = 5;

g = 9.8;

tMin = 0;
tMax = 3;
Nt = 1500;

t = linspace(tMin,tMax,Nt);
vT = m*g/b; k = b/m;

v0 = 0;

v = vT + (v0 - vT) .* exp(-k*t);
a = g - k .* v;
x = vT .* t + (1/k) .* (v0-vT) .* (1-exp(-k*t));
x1 = (m/b) .* ((v0-v) + vT.*log((vT-v0)./(vT-v)));



figure(1)
col = 'b';
fs = 9;
set(gcf,'units','normalized','position',[0.2 0.2 0.18 0.22]);
tx = 'time  t   [s]';
ty = 'velocity  v  [m.s^{-1}]';
xP = t; yP = v;

Xrange = [0 1.0 * max(xP)];
Yrange = [0 1.1 * max(yP)];
Xrange = [0 1.0 * 2];
Yrange = [0 1.1 * 10];
   plot(xP,yP,col,'lineWidth',2)
hold on
% yP = vA;
%     plot(xP,yP,'r')
grid on
xlabel(tx); ylabel(ty);
%set(gca,'Xlim',Xrange);
%set(gca,'Ylim',Yrange);

figure(2)
fs = 9;
set(gcf,'units','normalized','position',[0.4 0.2 0.18 0.22]);
tx = 'time  t   [s]';
ty = 'acceleration  a  [m.s^{-2}]';
xP = t; yP = a;

Xrange = [0 1.0 * max(xP)];
Yrange = [-1.1*max(yP) 1.1 * max(yP)];
Xrange = [0 1.0 * 2];
Yrange = [-1.1*10 1.1 * 10];
   plot(xP,yP,col','lineWidth',2)
hold on
% yP = vA;
%     plot(xP,yP,'r')
grid on
xlabel(tx); ylabel(ty);
%set(gca,'Xlim',Xrange);
%set(gca,'Ylim',Yrange);

figure(3)
fs = 9;
set(gcf,'units','normalized','position',[0.6 0.2 0.18 0.22]);
tx = 'time  t   [s]';
ty = 'displacement  x  [m]';
xP = t; yP = x;

Xrange = [0 1.0 * max(xP)];
Yrange = [0 1.1 * max(yP)];
Xrange = [0 1.0 * 2];
Yrange = [0 1.1 * 10];
   plot(xP,yP,col','lineWidth',2)
hold on
% yP = vA;
%     plot(xP,yP,'r')
grid on
xlabel(tx); ylabel(ty);
%set(gca,'Xlim',Xrange);
%set(gca,'Ylim',Yrange);

figure(4)
fs = 9;
set(gcf,'units','normalized','position',[0.8 0.2 0.18 0.22]);
tx = 'velocity  v   [m.s^{-1}]';
ty = 'displacement  x  [m]';
xP = v; yP = x1;

Xrange = [0 1.0 * max(xP)];
Yrange = [0 1.1 * max(yP)];
Xrange = [0 1.0 * 2];
Yrange = [0 1.1 * 10];
   plot(xP,yP,col','lineWidth',2)
hold on
% yP = vA;
%     plot(xP,yP,'r')
grid on
xlabel(tx); ylabel(ty);
%set(gca,'Xlim',Xrange);
%set(gca,'Ylim',Yrange);