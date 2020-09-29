import sys
import pyBigWig
import pandas as pd 
import numpy as np
import time

bw = sys.argv[1] 
annotation_file = sys.argv[2] 
out_path = sys.argv[3]
iterations = sys.argv[4]
iterations = int(iterations)

def get_coverage(bw_path, annotation_file, out_path, iterations):

  annotation = pd.read_csv(annotation_file, sep = "\t", names = ["seqnames", "start", "end"])

  time_taken = []

  for i in range(iterations):

    start = time.time()
    
    bw = pyBigWig.open(bw_path)
  
    for i in range(len(annotation)):
  
      annotation_one_range = annotation.iloc[i]
    
      # get cov across entire range of coords needed
      cov = bw.values(annotation_one_range["seqnames"],
                      annotation_one_range["start"], 
                      annotation_one_range["end"])
                    
      cov = np.nan_to_num(cov)
      cov = np.mean(cov)
  
    bw.close()
  
    end = time.time()
  
    time_taken.append(end - start)

  df = pd.DataFrame({"tool": np.repeat(np.array(["pyBigwig"]), [iterations], axis = 0), 
                   "run_time": time_taken})
                  
  df.to_csv(out_path, sep = "\t", index = False) 

get_coverage(bw, annotation_file, out_path, iterations)
