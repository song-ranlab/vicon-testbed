
%
% Nonlinear rendezvous docking controller
% of a BlueROV 2 Heavy to a floating WEC (constrained to heave).
% Control of u and w.
% Input u: x and z thrust force
% States eta: [x,0,z,0,0,0]
% States nu: [u,0,w,0,0,0]
% Initial state: x(0) = [0 0 0 0 0 0], u(0) = 0
% Tracking reference: z(t) = sin(0.2*t)
clear 
clc
close all
xhat=zeros(12,1);
uopt = zeros(6,1);

xhat(1:6)=[0;0;10;0;0;0];
xhat(7:12)=[0;0;0;0;0;0];
nu = xhat(7:12);

uopt = [0;0;0.3434;0;0;0];

omega = nu(4:6)

tau = zeros(6,1);
tau = uopt;

getquadparams

% %state vector: [x,x2] = [eta,nu]
% nu = [u;v;w;p;q;r]; %nu vector
% eta = [x;y;z;phi;theta;psi]; %eta vector


M = mfunc(m,ix,iy,iz); % mass = ridgid body mass + added mass
Minv = inv(M); %mass matrix inverse


h = .1; %time step
l=25; %lenth of simulation seconds
ti = 0 % initial time

for i = 1:(l-ti)/h  
    
    eta = xhat(1:6);
    nu = xhat(7:12);
    
    t = (i-1)*h;
    S(i,1) = t;
    S(i,2:7) = transpose(eta); % eta'
    S(i,8:13) = transpose(nu);
                       
            %call matrix building functions
            D = dfunc(kd,nu)
            G = gfunc(m); %hydrostatic forces
            J = jfunc(eta(4),eta(5),eta(6)); %refernce frame transform matrix
            C = cfunc(omega, M);
            
            xhat = eulerfunc2(h,nu,eta,Minv,G,J,tau,M,C,D);

end
nexttile
figure(1)
plot (S(:,1), S(:,2), 'b-', S(:,1), S(:,3), 'r-', S(:,1), S(:,4), 'g-') %plot x, y, z against t
legend('x','y','z')

nexttile
plot (S(:,1), S(:,5), 'b-', S(:,1), S(:,6), 'r-', S(:,1), S(:,7), 'g-')
legend('phi','theta','psi')

nexttile
plot (S(:,1), S(:,8), 'b-', S(:,1), S(:,9), 'r-', S(:,1), S(:,10), 'g-') 
legend('u','v','w')

nexttile
plot (S(:,1), S(:,11), 'b-', S(:,1), S(:,12), 'r-', S(:,1), S(:,13), 'g-') 
legend('p','q','r')

%end
