function [ theta, J ] = music( X,ntx,dr,dt,Delta_T,mtx,nrx,d )
%music DoA estimation using MUSIC algorithm
%   Detailed explanation goes here
    K = 1000;
    theta_scan = linspace(-90,90,K);
    J = ones(K,1);
    Rx = X*X'/size(X,2);
    M = size(X,1);
    [U,~] = eig(Rx);
    Un = U(:,1:M-d);
    for i=1:K
        ar = gen_a(nrx,dr,theta_scan(i));
        at = gen_b( ntx,dt,Delta_T,theta_scan(i),mtx );
        a = kron(ar,at).';
		b(i) = sum(a);
        J(i) = (a'*(Un*Un')*a)/(a'*a);
    end
    [pks,locs] = findpeaks(abs(1./J));
    [~,I] = sort(pks,'descend');
    theta = theta_scan(locs(I(1:d)));
end
