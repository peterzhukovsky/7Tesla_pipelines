# 7Tesla_pipelines
A set of scripts for preprocessing diffusion weighted MRI data (optimized on a 7T dataset, WBIC Cambridge)

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
        https://www.ncbi.nlm.nih.gov/pubmed/23283687  Tziortzi et al 2014; also see \
        https://www.sciencedirect.com/science/article/pii/S2213158218303450
    
  4. Targets.txt - a text file to point to the set of target masks, the path to this file needs to be referenced in the scripts \
  **!!! All paths need to be adjusted to point to the right files**
# How to automate the pipeline
  1. prepare the individual participant folders\
    Each subject's folder should contain the following:
      - data.nii (the large diffusion file with many diffusion directions)\
      - data_inv.nii (the small diffusion file with reverse encoding direction: you can see if it's X, Y or Z by looking at which direction the image distortion takes)\
      - bvals (from the large diffusion file)\
      - bvecs (from the large diffusion file)\
      *Note: this preprocessing pipeline uses FSL topup and FSL eddy; it relies on having acquired a diffusion image in the reverse direction from the main diffusion file as described on the FSL user guide.*\
      https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup/TopupUsersGuide\
      https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy/UsersGuide\ \
  **2. Critical: make sure the brain extraction works well on structural images. For the 7T data, bet and fsl_anat failed to brain extract the images. Therefore, SPM segmentation tool was used to generate a grey, white and csf image; those were added together to get a brain mask. Without appropriate brain extraction FSL flirt and fnirt will fail. Generally Freesurfer registration is preferable, especially if using Freesurfer surface-based atlases.**
  3. change the paths on the preprocessing.sh and the probtrackx.sh scripts 
  3. run the scripts with the slurm wrapper scripts on the cluster if it's available. If no cluster computing is available, bear in mind that bedpostx can take several days for one image using one CPU core and 5+ GBP RAM. Running bedpostx with GPU acceleration may be an alternative.
