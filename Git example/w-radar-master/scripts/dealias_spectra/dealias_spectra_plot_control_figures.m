function dealias_spectra_plot_control_figures(data)

% % #### Ze
%  fig = figure;
%  pcolor(10*log10(data.Ze)'); shading('flat');
%  cb = colorbar;
%  title('Z_e [m/s]')
%  
%  fig = figure;
%  hist(reshape(data.Ze,1,numel(data.Ze)),-70:30);
 
 
 % #### vm
 fig = figure;
 pcolor(data.vm'); shading('flat');
 cb = colorbar;
 title('v_m [m/s]')

savefig(fig,['vm_' num2str(data.time(1))])
close(fig)

 
%  fig = figure;
%  hist(reshape(data.vm,1,numel(data.vm)),-20:0.1:20);
%  
%  
%  % #### spectral width
%  fig = figure;
%  pcolor(data.sigma'); shading('flat');
%  cb = colorbar;
%  title('\sigma [m/s]')
%  
%  fig = figure;
%  hist(reshape(data.sigma,1,numel(data.sigma)),0:0.05:5);
%  
%  
%  % ##### skewness
%  fig = figure;
%  pcolor(data.skew'); shading('flat');
%  cb = colorbar;
%  title('skewness')
%  
%  fig = figure;
%  hist(reshape(data.skew,1,numel(data.skew)),-20:0.1:20);
