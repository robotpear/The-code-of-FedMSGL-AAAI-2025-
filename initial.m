function [N] = initial(data)

A = sum(data,1);
n = size(data,2);
N = zeros(n,n);

for i = 1:n
    for j =1:n
        N(i,j) = data(j,i)/A(i);
    end
end
N = N';
