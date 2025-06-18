function [Cp,Sp] = localupdate(data,Iter)


% local initialize 

X = data;
nsamp = size(data,2);
Cp = rand(nsamp,nsamp);
Sp = rand(nsamp,nsamp);
PI1 = rand(nsamp,nsamp);
PI2 = rand(nsamp,1);
M1 = rand(nsamp,nsamp);
M2 = rand(nsamp,1);
rou = 0.5;
lambda1 = 0.1;
lambda2 = 0.1;
Q = getq(data,nsamp,0);

for i = 1:Iter
    Pu = X'*(X-X*Sp) + rou*(eye(nsamp,1)*ones(1,nsamp)+Cp) - ones(nsamp,1)*PI2' - PI1;
    Pd = X'*X + rou*eye(nsamp) +rou*eye(nsamp,1)*ones(1,nsamp);
    P = Pu/Pd;
    Cp = (rou*P +PI1)/(rou+lambda1);
    Cp = Cp- diag(Cp);
    PI1 = PI1 + rou*(P - Cp);
    PI2 = PI2 + rou*((P+Sp)'*ones(nsamp,1)-ones(nsamp,1));

    Ku = X'*(X-X*Cp) + rou*(eye(nsamp,1)*ones(1,nsamp)+Sp) - ones(nsamp,1)*M2' - M1;
    Kd = X'*X + rou*eye(nsamp) +rou*eye(nsamp,1)*ones(1,nsamp);
    K = Ku/Kd;
    Sp = (rou*K +M1)/(rou*eye(nsamp)+lambda2*diag(Q^2));
    Sp = Sp- diag(Sp);
    M1 = M1 + rou*(K - Sp);
    M2 = M2 + rou*((K+Cp)'*ones(nsamp,1)-ones(nsamp,1));

end