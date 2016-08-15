function DATA=fluolab_vec_rej(DATA,REFERENCE)
%
%
%
%

if isvector(DATA)
	DATA=DATA(:);
end

[nsamples,ntrials]=size(DATA);

for i=1:ntrials	
	dot(DATA(:,i),REFERENCE)./dot(REFERENCE,REFERENCE)
	DATA(:,i)=DATA(:,i)-(dot(DATA(:,i),REFERENCE)./dot(REFERENCE,REFERENCE))*REFERENCE;
end
