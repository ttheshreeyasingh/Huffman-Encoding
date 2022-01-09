function [codes] = huffman(fd)


% takes frequency of each symbol as input 
% returns the code of each the symbol in the same order as received
% But doesn't take the symbols as input , because huffmaan coding doesn't
% depend on the symbol but only on its frequency in the data
% NOTE  : frequencies' ratio is nothing but the probabilities' ratio


r = size(fd,2) ; 
% r = the no of unique symbols present
%   = the no of codewords that should be obtained 


% we recursively keep combining 2 least likely events and finding codes for
% that distribution until r = 2
% (r decreases by 1 in each recursive call ) 


if r == 2 
    
    % this is the deepest level of recursion . Here, only 2 events will be
    % present and we assign 1 length codeword for each event and assigning
    % either '0' or '1' to any event doesn't matter . But we used a
    % convention that more probable event is assigned '0'
    
    
    if ( fd(1)  < fd(2) ) 
        codes = {'1','0'};  
    else
        codes = {'0','1'} ;
    end
    
    % with this if condition , it is ensured that the order of assigning 
    % is same as order in which the frequencies are received following the
    % convention mentioned above 
    
    
    
else  
    % this is code for a general recursive call where we combine
    % frequencies of the 2 least likely events 
    
    A = 1 : r ;
    
    fd = num2cell(fd);
    A = num2cell(A) ; 
    
    boxes = struct2table(struct('freq',fd,'keys',A) ) ; % row to column
    boxes = sortrows(boxes , 'freq','descend' ) ; % column to row
    % or just -1 for 1st column in descending order 
    % 1st column is frequencies ,2nd column is keys


%     % combining 2 least probable events
%     comb_boxes = boxes(1:r-1) ;  % comb_fd for 2 least probable events combined 
%     comb_boxes(r-1).freq = comb_boxes(r-1).freq + boxes(r).freq ; 
%     % least probabilities combined box will be the right most 
    
    
    
    
    comb_fd = transpose(boxes.freq) ;
    comb_fd(r-1) = comb_fd(r-1)+comb_fd(r) ; 
    comb_fd = comb_fd(1:r-1) ; 
    
    
    codes = huffman( comb_fd) ;
    codes = transpose(([codes , {'0'}]) );
%     codes = renamevars(codes, 1 , 'str'); 
    
    boxes.('str') = codes ;
    
    boxes(r-1,'str').str = {[codes{r-1} , '0']} ;
    boxes(r,'str').str = {[codes{r-1} , '1']} ;
    
    boxes = sortrows(boxes ,'keys' ) ;
    codes = transpose(boxes.str) ;
    

% l = transpose(boxes) 
% [codes,'0']
% cell2table(['str' ,codes , '0'])
end


end


