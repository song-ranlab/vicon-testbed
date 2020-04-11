function [J,j1] = jfunc(phi, theta, psi)

zm = zeros(3,3);

j1 = [(cos(psi)*cos(phi))-(cos(theta)*sin(phi)*sin(psi)) (-sin(phi)*cos(psi))-(sin(psi)*cos(theta)*cos(phi)) (sin(psi)*sin(theta)); 
      (cos(psi)*sin(phi)*cos(theta))+(sin(psi)*cos(phi)) (cos(psi)*cos(phi)*cos(theta))-(sin(phi)*sin(psi)) -cos(psi)*sin(theta);
      sin(theta)*sin(phi) sin(theta)*cos(phi) cos(theta)];
j2 = [1 0 -sin(theta); 0 cos(phi) cos(theta)*sin(phi); 0 -sin(phi) cos(phi)*cos(theta)];

J = [j1 zm; zm j2];

%J = zeros(6,6);

end


% phi=1;
% theta=1;
% psi=1;
