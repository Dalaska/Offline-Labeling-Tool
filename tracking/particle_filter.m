i_dist = 'Normal'
m_dist = 'Normal'
N = 100
T = 10

X(:,1) = random(i_dist,N,1);
w(:,1) = ones(N,1)/N;
for t =1:T
   w(:,t) = pdf(m_dist,y(t)-g(x(:,t)));
   w(:,t) = w(:,t)/sum(w(:,t));
   Resample x(:,t)
   x(:,t+1) = f(x(:,t),u(t))+random(t_dist,N,1);
end