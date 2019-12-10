#!/bin/bash
#########################################################################
######## PROBTRACKX SCRIPT
#########################################################################
name=1004
path="/group/p00481/7T_DTI_PZ/DTI_7T/DTI_niis_raw/$name"
regpath="/group/p00481/7T_VBM_PZ/T1s/struc"
flirt -in $path/nodif_brain -ref /group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_brain -out $path/nodif_in_struc -omat $path/dif2str.mat -dof 6
convert_xfm -inverse $path/dif2str.mat -omat $path/str2dif.mat
#struc to std
flirt -ref $regpath/MNI152_T1_2mm_brain -in /group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_brain -omat $path/str2std.mat
fnirt --ref=$regpath/MNI152_T1_2mm --in=/group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_struc --aff=$path/str2std.mat --cout=$path/my_nonlinear_str2std_transf --config=T1_2_MNI152_2mm --inmask=/group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_brain_mask --refmask=$regpath/MNI152_T1_2mm_brain_mask

invwarp --ref=/group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_struc --warp=$path/my_nonlinear_str2std_transf --out=$path/my_nonlinear_std2str_transf

roinames="STR_ROI Occipital Parietal anterior_motor executive posterior_motor limbic"
for roi in $roinames; do
applywarp --ref=/group/p00481/7T_rs_fmri_PZ/fsl_anat_dir/struc_bet/${name}_brain --in=/group/p00481/7T_DTI_PZ/DTI_7T/MASKS/ROI_masks/$roi --warp=$path/my_nonlinear_std2str_transf --out=$path/${roi}_int1
flirt -ref $path/nodif_brain -in $path/${roi}_int1 -applyxfm -init $path/str2dif.mat -out $path/${roi}_indiffspace
fslmaths $path/${roi}_indiffspace -thr 10 $path/${roi}_indiffspace
fslmaths $path/STR_ROI_indiffspace -thr 25 $path/STR_ROI_indiffspace
fslmaths $path/limbic_indiffspace -thr 30 $path/limbic_indiffspace
done

probtrackx2 -x $path/STR_ROI_indiffspace.nii.gz -V 1 -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s $path.bedpostX/merged -m $path/nodif_brain_mask --dir=$path/Classification --targetmasks=$path/targets.txt --os2t 

wait
