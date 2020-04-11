function xhat = eulerfunc2(h,nu,eta,Minv,G,J,tau,C,D)

    nu = nu + (h.*(Minv*( G + D + tau - C)));
    eta = eta + (h * (J * nu));

    xhat = [eta; nu];
    
end
