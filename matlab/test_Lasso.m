clear all;
addpath('../matlab_fista/');
randn('seed',0);
fprintf('Testing C++ Lasso implementation against Matlab\n');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Decomposition of a large number of signals
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Data are generated
% X=randn(100,100000);
% X=X./repmat(sqrt(sum(X.^2)),[size(X,1) 1]);
% D=randn(100,200);
% D=D./repmat(sqrt(sum(D.^2)),[size(D,1) 1]);
% 
% % parameter of the optimization procedure are chosen
% %param.L=20; % not more than 20 non-zeros coefficients (default: min(size(D,1),size(D,2)))
% param.lambda=0.15; % not more than 20 non-zeros coefficients
% param.numThreads=-1; % number of processors/cores to use; the default choice is -1
%                      % and uses all the cores of the machine
% param.mode=2;        % penalized formulation
% 
% tic
% alpha=mexLasso(X,D,param);
% t=toc
% fprintf('%f signals processed per second\n',size(X,2)/t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Regularization path of a single signal 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for c = 1:100
    d = randi([100 200],1,1);
    N = randi([10 20],1,1);
    k = randi([10 20],1,1);
  
    X=randn(d,N);
    D=randn(d,k);
    D=D./repmat(sqrt(sum(D.^2)),[size(D,1) 1]);
    param.lambda=0.15;
    param.pos = true;

    % [alpha path]=mexLasso(X,D,param);
    X_mat = fista_lasso(X, D, [], param);
    X_mex = mex_fista_lasso(X, D);
    diff = sum((X_mat(:)-X_mex(:)).^2);
    if diff > 1.0e-20
        warning('Error while testing lasso function ');
    end
end

