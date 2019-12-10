# 7Tesla_pipelines
A set of scripts for preprocessing diffusion weighted MRI data and resting state functional MRI data (optimized on a 7T dataset, WBIC Cambridge)

# Included files:
  1. Scripts that run preprocessing (preprocessing.sh) and can automate this process using cluster computing by parallelizing the operation (slurm_submit_pz.sh)\
  **!!! All paths need to be adjusted to point to the right files**
  2. Scripts that generate striatal parcellation maps by registering the target masks and the striatal mask (lister in point 3 below) to subject space (probtrackx.sh) and can be sped up by using the cluster (slurm_probtracx_pz.sh) \
  **!!! All paths need to be adjusted to point to the right files**
  3. Example parcellation of the brain aiming to generate a set of target masks for striatal parcellation \
    3.1 anterior motor \
    3.2 posterior motor \
    3.3 executive\
    3.4 limbic\
    3.5 occipital\
    3.6 parietal\
    3.7 temporal\
    3.8 striatum (STR_ROI)\
    *Note: this may not be the best target parcellation, especially since it produced different striatal parcellations from Tziortzi et al 2014* \
        https://www.ncbi.nlm.nih.gov/pubmed/23283687  Tziortzi et al 2014 
    also see \
        https://www.sciencedirect.com/science/article/pii/S2213158218303450
    
  4. Targets.txt - a text file to point to the set of target masks, the path to this file needs to be referenced in the scripts
    
# How to automate the pipeline
  1. prepare the individual participant folders  
  2. change the paths on the preprocessing.sh and the probtrackx.sh scripts 
  3. run the scripts with the slurm wrapper scripts on the cluster if it's available. If no cluster computing is available, bear in mind that bedpostx can take several days for one image using one CPU core and 4+ GBP RAM. GPU accelerated implementations may be an alternative.
