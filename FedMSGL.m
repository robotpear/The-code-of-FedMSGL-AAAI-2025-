
function [result] = FedMSGL(Data, labels,para,l1,l2,l3,Q,gamma)

% This is the main function of FedMSGL



% initial 
Cnum = length(unique(labels));
maxIter = para.max;
maxIterc = para.maxc;
maxIters = para.maxs;
nView = length(Data);%num of views 
nFea = zeros(nView,1);
nSamp = size(Data{1}, 2);%num of samples(assumption: all clients hold same num of samples)
for n = 1:nView
    nFea(n) = size(Data{n}, 1);%num of features
end


% clients initialize matrix 

Xp = cell(nView,1);
Cp = cell(nView,1);
Sp = cell(nView,1);
G = eye(nSamp);
Sumerr = [];




for n = 1:nView
    Xp{n}= scaleSVM(Data{n},0,1);
    Cp{n} = zeros(nSamp,nSamp);
    Sp{n} = initial(rand(nSamp,nSamp));
    Sumerrl{n} = [];
end



%  update

for iter = 1:maxIter
%client update 
    for n = 1:nView
        if iter>1
            Cp{n} = G;% data transimssion
        end
        [Cp{n},Sp{n},Err{n}] = localupdate2(Xp{n},Q{n},maxIterc,Cp{n},Sp{n},l1,l2,l3);
        Sumerrl{n} = horzcat(Sumerrl{n},Err{n});

    end


 % server update 
   [F,G,Errs] = centralupdate(Cp,Sp,nView,maxIters,nSamp,Cnum,G,gamma);
   Sumerr = horzcat(Sumerr,Errs);

    
   fprintf('Communication round %d \n ',iter)

end

for ij=1:10
[res2]= kmeans(F, length(unique(labels)), 'emptyaction', 'singleton', 'replicates', 1, 'display', 'off');
[res(ij,:)] = ClusteringMeasure( labels, res2);
end
result(1,1)=mean(res(:,1));result(1,2)=std(res(:,1));
result(2,1)=mean(res(:,2));result(2,2)=std(res(:,2));
result(3,1)=mean(res(:,3));result(3,2)=std(res(:,3));

end
