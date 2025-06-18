clear all
clc
load('bbcsport-mtv.mat')
warning('off')

para = [];
para.max = 5;
para.maxc = 10;para.maxs = 10;
lambda1 = [100];
lambda2 = [1];
lambda3 = [1e-4];
gamma =1;
rng(6)

%please use gsp_start to lauch the toolbox before run the code
% you can change k of KNN hypergraph in centralupdate.m file


%bbcsport
Q = cell(length(X),1);
for i = 1:length(X)
    Q{i}=getq2(X{i});
end

for g=1:length(gamma)
    for i=1:length(lambda1)
        for j=1:length(lambda2)
            for k=1:length(lambda3)
                res = FedMSGL(X, gt,para,lambda1(i),lambda2(j),lambda3(k),Q,gamma(g))
            end
        end
    end
end







