function [all]=distance(F,n,ij)
  for ji=1:n
            all(ji)=(norm(F(ij,:)-F(ji,:)))^2;
  end
end