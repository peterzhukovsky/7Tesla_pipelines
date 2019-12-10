# 7Tesla_pipelines
A set of scripts for preprocessing diffusion weighted MRI data and resting state functional MRI data (optimized on a 7T dataset, WBIC Cambridge)

# Included files:
  1. Scripts that run preprocessing (preprocessing.sh) and can automate this process using cluster computing by parallelizing the operation (slurm_submit_pz.sh)\
  !!! All paths need to be adjusted to point to the right files
  2. Scripts that generate striatal parcellation maps by registering the target masks and the striatal mask (lister in point 3 below) to subject space (probtrackx.sh) and can be sped up by using the cluster (slurm_probtracx_pz.sh) \
  !!! All paths need to be adjusted to point to the right files
  3. Example parcellation of the brain aiming to generate a set of target masks for striatal parcellation \
    3.1 anterior motor \
    3.2 posterior motor \
    3.3 executive\
    3.4 limbic\
    3.5 occipital\
    3.6 parietal\
    3.7 temporal\
    3.8 striatum (STR_ROI)\
  4. 
    
