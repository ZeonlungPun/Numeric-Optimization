function [a,b] = intercross(a,b)
%input: a and b needed to intercross
%output: a and b after intercross
L = length(a);
% generate intercross reigon by random
r1 = randsrc(1,1,[1:L]);% a number between 1-L 
r2 = randsrc(1,1,[1:L]);
if r1~=r2
    a0 = a;
    b0 = b;
    s = min([r1,r2]);
    e = max([r1,r2]);
    for i = s:e
        a1 = a;
        b1 = b;
        % first interchange
        a(i) = b0(i);
        b(i) = a0(i);
        % find same city in one chrome
        x = find(a==a(i));
        y = find(b==b(i));
        % second exchange
        i1 = x(x~=i);
        i2 = y(y~=i);
        if ~isempty(i1)
            a(i1)=a1(i);
        end
        if ~isempty(i2)
            b(i1)=b1(i);
        end
    end
end