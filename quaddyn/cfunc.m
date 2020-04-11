
function C = cfunc(omega, M)

I = M(4:6,4:6);

C = cross(omega, I*omega);

C=[0;0;0;C];




end

