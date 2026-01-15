function[x] = rcpulse(t,T,a)
    x = (sin(pi*(t+1e-10)/T)./(pi*(t+1e-10)/T)) ...
                    .* cos(a.*pi*(t+1e-10)/T)./((1-4*a^2.*((t+1e-10)/T).^2));
return 