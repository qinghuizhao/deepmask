function log_detections(log_fid, imPath, alignedImagePath, detection)
%LOG_DETECTIONS Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('preCalcValues','var')
        fprintf(log_fid, '%s,%s\n', imPath, alignedImagePath);  
    else
        fprintf(log_fid, ...
                '%s,%s,%d %d %d %d\n', ...
                imPath, ...
                alignedImagePath, ...
                detection(1), ...
                detection(2), ...
                detection(3), ...
                detection(4));  
    end
    

end

