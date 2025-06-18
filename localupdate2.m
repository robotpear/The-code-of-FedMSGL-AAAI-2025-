function [Cp,Sp,Err] = localupdate2(data,Q,Iter,Cp,Sp,lambda1,lambda2,lambda3)


% local initialize 

X = data;
nsamp = size(data,2);





%local update
for i = 1:Iter
    Cu = X'*(X-X*Sp);
    Cd = X'*X + lambda1*eye(nsamp)+lambda2*diag(Q^2);
    C1 = Cd\Cu;
    for j =1:nsamp
        M=(1-(Sp(j,:)+Cp(j,:))*ones(nsamp,1))/nsamp;
        Cp(j,:) = max((C1(j,:)+M*ones(1,nsamp)),0);
        Cp(j,j)=0;
    end


   
    

    Su = X'*(X-X*Cp);
    Sd = X'*X +lambda3*eye(nsamp);
    S1 = Sd\Su;
    for j =1:nsamp
        M=(1-(Sp(j,:)+Cp(j,:))*ones(nsamp,1))/nsamp;
        Sp(j,:) = max((S1(j,:)+M*ones(1,nsamp)),0);
        Sp(j,j)=0;
    end



    if (i > 0) 

        loss = norm(X-X*(Cp+Sp),'fro')^2+0.5*lambda1*norm(Cp,"fro")^2+0.5*lambda3*norm(Sp,"fro")^2+0.5*lambda2*norm(Q.*Cp,"fro")^2;
        Err(i) = loss;
    end

    if(i > 1)
        diffc = abs(Err(i-1) - Err(i));
        if(diffc < 1e-4)
            Err(i+1:Iter)=Err(i);
            break;
        end
    end

end

