function [F,G,Err]=centralupdate(Graph,Sp,nview,Iter,nsamp,Cnum,G,gamma)

Cp = Graph;
wp=ones(nview,1)/nview;
M =zeros(nsamp,nsamp,nview);
Z = zeros(nsamp,nsamp,nview);


for n = 1:Iter
    G(find(G<0))=0;
    for i = 1:nview
        wp(i) = 1/2*exp(norm(Cp{i}-G,'fro'));
        M(:,:,i)=wp(i)*Cp{i};
        Z(:,:,i)=0.5*((G+G')+(Sp{i}'+Sp{i}));
        loss(i) = wp(i)*norm(Cp{i}-G,'fro')^2;
    end
        Z = sum(Z,3)/nview;
        para.k = 25;   
        St = gsp_nn_hypergraph(Z,para); %hypergraph part
        L = St.L;
        [F, ~, ~]=eig1(L, Cnum, 0);
       
    
    for ij=1:nsamp
        all=distance(F,nsamp,ij);      
        G(:,ij)=(sum(M(:,ij,:),3)-gamma*all'/4)/sum(wp);
    end
        Err(n) = sum(loss)+gamma*trace(F'*L*F);
        
    if(n > 1)
        diffc = abs(Err(n-1) - Err(n));
        if(diffc < 1e-4)
            Err(n+1:Iter)=Err(n);
            break;
        end
    end
  
end
% imagesc(F);colorbar;colormap('cool')
