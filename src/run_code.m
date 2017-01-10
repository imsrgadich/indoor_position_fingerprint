%% This is the run file for the Indoor positioning 

%% Task 1: Create the reference map.

% get the data files

load('../data/location.mat')

text_files = {'../data/train/1001_104748.txt';
              '../data/train/1001_104907.txt';
              '../data/train/1001_105101.txt';
              '../data/train/1001_105335.txt';
              '../data/train/1001_105412.txt';
              '../data/train/1001_105511.txt';
              '../data/train/1001_105606.txt';
              '../data/train/1001_105640.txt';
              '../data/train/1001_105752.txt';
              '../data/train/1001_105833.txt';
              '../data/train/1001_105902.txt';
              '../data/train/1001_110012.txt';
              '../data/train/1001_110108.txt';
              '../data/train/1001_110202.txt';
              '../data/train/1001_110232.txt';
              '../data/train/1001_110356.txt';
              '../data/train/1001_110437.txt';
              '../data/train/1001_110659.txt';
              '../data/train/1001_110758.txt';
              '../data/train/1001_110842.txt';
              };
          
reference_map = get_reference_map(location,text_files);



