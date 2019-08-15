function [ out ] = receiver( cfg,rx,tx )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here    
    out = cell(rx.nrx,1);
    for i=1:rx.nrx
        rx_d = zeros(tx.ntx*tx.mtx,cfg.N/cfg.f_dec);
        for k=1:tx.ntx*tx.mtx
            r_deramp = conj(rx.r.*repmat(conj(tx.waveform(k,:)),rx.nrx,1));
%             temp = r_deramp(i,:).*exp(-2i*pi*cfg.mu*(k-1)*cfg.tmax.*cfg.t);
            temp = filter(rx.hd,r_deramp(i,:));
            rx_d(k,:) = decimate(temp,cfg.f_dec);
        end
        out{i} = rx_d;
    end
end