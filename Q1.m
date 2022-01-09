close all; 
clear all ; 
clc;

% -- File is read using appropriate Matlab functions  

Fptr = fopen("file1.src", 'r'); 

A = fread(Fptr);
A = transpose(A) ; % converting into row vector for convenience


% -- Frequency distribution of each of the symbol is calculated by
% traversing through the array containing all the characters r̥of the file
% one-by-one 

freqdist = zeros(1,128) ; 


for i = 1 : size(A,2) 
freqdist(A(i)+1) =  freqdist(A(i)+1) + 1 ; 
end


% -- this nonZero array stores the source symbols that have appeared
% atleast once , their frequencies and their code-words obtained by Huffamn
% encoding 

nonZero = [] ;

for i = 1:128 
    
    if freqdist(i) ~= 0
        
        nonZero = [nonZero,[freqdist(i);i-1]];
        
    end
           
end

a= huffman(nonZero(1,:));

% -- this calls the huffman encoding function which is the main part of
% this process and rest all after this are just functions that help us read
% and write the files properly 

 

nonZero = [num2cell(nonZero); a];
%-- appending the code-word list to the nonZero array 


%-- Now,  here , we traverse through the array that has all the characters
% of the file one-by-one and then make an array that holds the code-words
% of each symbol in the same order as the symbols occur in the file 

encoder = num2cell(zeros(1,128));
% encoder = {encoder} ;

for i = 1 : size(a,2)
encoder{nonZero{2,i}} = a{i} ; 

% a = huffman([150,30,25,50,40]) ;
% 
% a = str2double(a) ; 

% wriA = zeros(size(A,2)); 

end

% string 

wriA = strjoin(encoder(A),'') ;

% -- at this point we have the long string containg all the code-words one
% after the other . In order write this string, composed of 0s and 1s we
% have to spilt into equal length strings of 8 bits each and convert the 8
% bit strings into integers 
% this is done because , in Matlab, we can write integers directly in their
% binary representation into a file 


% we need to pad 0 to 8 extra zeros for this 
% and to know how many zeros we padded  , we add extra 8 bits at the end 

lastbyte = 8-mod(length(wriA),8) ; 

wriA = [wriA,('0'+zeros(1,lastbyte))] ; 
 

final = [] ;

for i = 1:8:length(wriA)-7
    
        final = [final;wriA(i:i+7)];  %reading 8 bits
        
end


final = bin2dec(final) ;
final = [final;lastbyte] ;


encoded_file_ptr   = fopen("encoded_file1.bin", 'w' ) ; 

fwrite(encoded_file_ptr,final,'uint8') ; 

fclose(encoded_file_ptr) ;

% note that here we have closed the encoded file 


%% decoder



faail = fopen("encoded_file1.bin", 'r') ; 

new = fread(faail) ;
new = dec2bin(new);

con = [] ; 
for i = 1 : length(new)
    con = [con,new(i,1:8)] ;
end

reclb = bin2dec(con(length(con)-7:length(con)));

reading_string = [];
decoded = [];

for i = 1:length(con)-(reclb+8)
    
    reading_string = [reading_string,con(i)];
    
    pos = 0; 
    
    for j = 1:length(a)
        
        if strcmp(a{j},reading_string) == 1
            pos = j ;
           
            break 
        end
        
    end
    
    if pos ~= 0 
        decoded = [decoded,nonZero{2,pos}] ;
        reading_string = [] ;
    end
        
    
end

fptr1 = fopen("decoded_file1.txt",'w') ; 

% now we have to write the characters directly from their ASCII values ,
% hence no conversions are required 

fwrite(fptr1, decoded ) ;

fclose(fptr1) ; 
fclose(faail) ; 







