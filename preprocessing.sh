#!/bin/bash
##################################################################
#preprocessing script to be copied over to an extra file and ran separately
##################################################################
path="/group/p00481/7T_DTI_PZ/DTI_7T/DTI_niis_raw/1004"

### 1 topup and eddy correction
fslroi $path/data $path/A2P_b0 0 1
fslmerge -t $path/A2P_P2A_b0 $path/A2P_b0 $path/data_inv
printf "0 -1 0 0.0646\n0 1 0 0.0646" > $path/acqparams.txt
topup --imain=$path/A2P_P2A_b0 --datain=$path/acqparams.txt --out=$path/my_topup_results --iout=$path/my_hifi_b0

indx=""
for ((i=1; i<=69; i+=1)); do indx="$indx 1"; done
echo $indx > $path/index.txt

bet $path/A2P_b0 $path/nodif_brain -m -f 0.15

/applications/fsl/fsl-5.0.11/bin/eddy --imain=$path/data --mask=$path/nodif_brain_mask --acqp=$path/acqparams.txt --index=$path/index.txt --bvecs=$path/bvecs --bvals=$path/bvals --topup=$path/my_topup_results --repol --out=$path/eddy_corrected_data 


#### 2 registration
#dif to struc
regpath="/group/p00481/7T_VBM_PZ/T1s/struc"
flirt -in $path/nodif_brain -ref ${regpath}/1004_struc_brain.nii.gz -out $path/nodif_in_struc -omat $path/dif2str.mat -dof 6
convert_xfm -inverse $path/dif2str.mat -omat $path/str2dif.mat
#struc to std
flirt -ref $regpath/MNI152_T1_2mm_brain -in ${regpath}/1004_struc_brain.nii.gz -omat $path/str2std.mat
fnirt --in=/home/pz249/scratch/7T_T1_raw/1004.nii.gz --aff=$path/str2std.mat --cout=$path/my_nonlinear_str2std_transf --config=T1_2_MNI152_2mm
invwarp --ref=/home/pz249/scratch/7T_T1_raw/1004.nii.gz --warp=$path/my_nonlinear_str2std_transf --out=$path/my_nonlinear_std2str_transf
#check if reg worked on dif img
applywarp --ref=$regpath/MNI152_T1_2mm --in=$path/nodif_brain --warp=$path/my_nonlinear_str2std_transf --out=$path/nodif_in_std --premat=$path/dif2str.mat

# 3 running bedpostx
mv $path/data.nii $path/old_data.nii
#mv $path/bvals $path/old_bvals
mv $path/bvecs $path/old_bvecs
mv $path/eddy_corrected_data.nii $path/data.nii
mv $path/eddy_corrected_data.eddy_rotated_bvecs $path/bvecs

bedpostx $path/
wait
