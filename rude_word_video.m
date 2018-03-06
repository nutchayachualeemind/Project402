clc
close all
clear all
%%
% Read video
xyloObj = VideoReader('C:\Users\Admin\Desktop\rate detection for programming\movie\13\Baby And Me.mp4');
get(xyloObj)
nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

resX = vidHeight;
resY = vidWidth;

position = [23 373;35 185]; 
box_color = {'red','green'};
%%
count_frame = 0;
oldPoints = [];
mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),'colormap',[]);
for k = 10000 : nFrames %k = 15200 : 16000
    mov(k).cdata = read(xyloObj,k);
    rgb_im = mov(k).cdata;
    
    img = rgb_im; %ayyildiz-20501-yesil-desenli-bikini-1991-11-B
    img = img(220:end,200:450,:);
    imagen = rgb2gray(img);
     %Convert to BW
    threshold = graythresh(imagen);
    imagen = im2bw(imagen,threshold);
    % Remove all object containing fewer than 30 pixels
    imagen = bwareaopen(imagen,30);
%     imshow(imagen)
    %Storage matrix word from image
    word=[ ];
    re=imagen;
    
    % Load templates
    load templates
    global templates
    % Compute the number of letters in template file
    num_letras=size(templates,2);
    while 1
        %Fcn 'lines' separate lines in text
        [fl re]=lines(re);
        imgn=fl;
        %Uncomment line below to see lines one by one
        %imshow(fl);pause(0.5)    
        %-----------------------------------------------------------------     
        % Label and count connected components
        [L Ne] = bwlabel(imgn);    
        for n=1:Ne
            [r,c] = find(L==n);
            % Extract letter
            n1=imgn(min(r):max(r),min(c):max(c));  
            % Resize letter (same size of template)
            img_r=imresize(n1,[42 24]);
            %Uncomment line below to see letters one by one
            imshow(img_r);pause(0.5)
            %-------------------------------------------------------------------
            % Call fcn to convert image to text
            letter=read_letter(img_r,num_letras);
            % Letter concatenation
            word=[word letter]
        end
        %fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
%         fprintf(fid,'%s\n',word);%Write 'word' in text file (upper)
        % Clear 'word' variable
        word=[ ];
        %*When the sentences finish, breaks the loop
        if isempty(re)  %See variable 're' in Fcn 'lines'
            break
        end    
    end

end

