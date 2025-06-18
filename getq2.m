function q = getq2(X)

N = size(X,2);
X2 = sum(X.^2,1);
Dist = real(sqrt( repmat(X2,N,1)+repmat(X2',1,N)-2*(X'*X) ));
D = triu(Dist);
KMax =N;

q = zeros(N,N);

for i = 1:N
    [~,ids] = sort(Dist(:,i),'ascend');
    ids = ids(1:KMax);
    
    y = X(:,ids(1));
    Y = X(:,ids);
    Y(:,1) = [];
    Y = Y - repmat(y,1,KMax-1);
    v = Dist(ids,i);
    v(1) = [];
    for j = 1:KMax-1
        Y(:,j) = Y(:,j) ./ v(j);
    end
    
    q(ids(2:KMax),i) = abs(v) / sum(abs(v));
end