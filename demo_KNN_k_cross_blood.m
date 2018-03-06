clc
close all
clear all
%%
for img_ix_raw = 1:32
database = [1920	103	80	51	4007	72.72
3178	1011	442	224	830	5.57
2178	343	204	177	2736	24.67
4638	109	54	39	803	27.58
165	41	26	34	4969	120.92
3897	148	65	42	271	3.56
1239	118	80	62	3068	107.09
510	183	182	172	3718	30.89
3433	173	94	68	1297	23.15
1837	203	155	140	4153	48.43
2596	165	137	94	5636	150.52
1345	89	50	105	4593	227.23
1814	222	152	243	2384	44.12
175	45	21	40	6832	200.33
2654	329	248	300	1837	13.01
5504	75	47	54	183	108
1899	213	150	272	2845	28.73
1891	190	133	180	2930	28.11
577	211	161	301	4327	57.84
1771	54	41	51	3136	127.77
2560	212	137	227	2238	30.86
2292	330	242	332	1948	15.97
1372	233	182	263	2929	73.96
1539	191	152	201	2645	45.45
4466	42	44	45	1607	32.96
959	175	151	280	4651	70.45
959	175	151	280	4651	70.45
204	41	39	65	5806	291.12
2576	279	169	227	1438	22.73
4991	186	104	96	247	1.78
3519	144	83	137	1438	26.25
950	171	126	188	3500	104.32];
target = [1	0	0	1	1	1	1	0	1	0	0	1	1	0	1	0	1	1	0	0	0	1	1	1	1	0	0	1	1	1	1	1];
%%
dataMatrix = database(img_ix_raw,:);
indices = crossvalind('Kfold',dataMatrix,10);

queryMatrix = [database(indices(1),:); database(indices(2),:); database(indices(3),:); database(indices(4),:);...
    database(indices(5),:); database(indices(6),:)];

kn = 1;

neighborIds = zeros(size(queryMatrix,1),kn);
neighborDistances = neighborIds;

numDataVectors = size(dataMatrix,1);
numQueryVectors = size(queryMatrix,1);

for i=1:numQueryVectors,
    dist = sum((repmat(queryMatrix(i,:),numDataVectors,1)-dataMatrix).^2,2);
    [sortval sortpos] = sort(dist,'ascend');
     neighborIds(i,:) = sortpos(1:kn);
    neighborDistances(i,:) = sqrt(sortval(1:kn));
end

[mini idx] = min(neighborDistances);
res(img_ix_raw) = target(idx);

end
%accuracy=sum(sum(xor(res,target)))/length(target(:))*100
%%
[ry cy] = size(res);
e = res - target;
mse_test = mse(e);
out = abs(mse_test);
in = cy;
disp('accuracy %')
accuracy = abs(((in - out) / in) * 100)
%%