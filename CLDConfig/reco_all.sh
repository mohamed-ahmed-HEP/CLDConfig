#!/bin/bash

nEvents=100

# thetas=(80 60) # 80 70 60 50 40 30 20 10)
# thetas=(89 80 70 60 50 40 30 20 10)
thetas=(90 87.13401602 84.26082952 81.37307344 78.46304097 75.52248781 72.54239688 69.51268489 66.42182152 63.25631605 60 56.63298703 53.13010235 49.45839813 45.572996 41.40962211 36.86989765 31.78833062 25.84193276 18.19487234 8.109614456)
thetas=(80) #56.63298703 53.13010235 49.45839813 45.572996 41.40962211 36.86989765 31.78833062 25.84193276 18.19487234 8.109614456)
momenta=(1 10 100)
momenta=(100)
particle=mu

# detectors=($K4GEO/FCCee/CLD/compact/CLD_o2_v05/CLD_o2_v05.xml)
# detectorNames=(CLD_o2_v05)

# detectors=($K4GEO/FCCee/CLD_IDEAvertex/compact/CLD_o2_v05_IDEAvertex/CLD_o2_v05_IDEAvertex.xml)
# detectorNames=(CLD_o2_v05_IDEAvertex)

detectors=($K4GEO/FCCee/CLD/compact/CLD_o2_v07/CLD_o2_v07.xml)
detectorNames=(CLD_o2_v07)


# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep20240412_vertex26092024_delta_one_step5e-3/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep20240412_vertex26092024_delta_one_step5e-3_cosTheta/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep20240412_vertex26092024_delta_one_step5e-3_cosTheta_CADbeampipe/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/CLD_o2_v05_key4hep2024041292024_delta_one_step5e-3_cosTheta/

# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe_ultraLight/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe_ultraLight_part/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe_ultraLight_part2/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe_ultraLight_part_truthTracking/

# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe_ultraLight_fixedSurfaces_conformal/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe_ultraLight_conformal/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe_ultraLight_conformal_CT0.05/
# dataFolder=/disk/gfs_data/CMS/arilg/FCC_Simulation/o1_v03_key4hep2025-01-28_vertex26092024_CADbeampipe_ultraLight_conformal_fakePlanar/
# dataFolder=/eos/user/a/afehr/IDEA_ultra-light_06062025/firstTry/
# dataFolder=/eos/user/a/afehr/IDEA_ultra-light_06062025/CADbeampipe_MinClustersOnTrackInVertex3/
# dataFolder=/eos/user/a/afehr/IDEA_ultra-light_06062025/CADbeampipe_MinClustersOnTrackInVertex4_zoffsetFinal_ATLASPix3_res0.005/
# dataFolder=/eos/user/a/afehr/IDEA_ultra-light_06062025/CADbeampipe/
# dataFolder=/eos/user/a/afehr/IDEA_ultra-light_06062025/CADbeampipe_MinClustersOnTrackInVertex4_zoffsetFinal_normalIDEAVertex/
dataFolder=/eos/user/a/afehr/IDEA_classic_rmin11.7_03062025/CADbeampipe_MinClustersOnTrackInVertex4_zoffsetFinal/
dataFolder=/eos/user/a/afehr/IDEA_ultra-light_rmin11.7_03062025/CADbeampipe_MinClustersOnTrackInVertex4_zoffsetFinal_0.005outerVertexDisks/

dataFolder=/eos/user/a/afehr/test_14072025/

# CLD Resolutions
VXDBarrelDigitiserResolutionU="0.003 0.003 0.003 0.003 0.003 0.003"
VXDBarrelDigitiserResolutionV=$VXDBarrelDigitiserResolutionU
VXDEndcapDigitiserResolutionU="0.003 0.003 0.003 0.003 0.003 0.003"
VXDEndcapDigitiserResolutionV=$VXDBarrelDigitiserResolutionU

# IDEA classic resolutions
# VXDBarrelDigitiserResolutionU="0.003 0.003 0.003 0.014 0.014"
# VXDBarrelDigitiserResolutionV="0.003 0.003 0.003 0.042 0.042"
# VXDEndcapDigitiserResolutionU="0.014 0.014 0.014"
# VXDEndcapDigitiserResolutionV="0.042 0.042 0.042"

maxJobs=3
iJob=0

echo Data folder: ${dataFolder}

for iDetector in "${!detectors[@]}"; do
	for momentum in "${momenta[@]}"; do
		for theta in "${thetas[@]}"; do
            runningJobs=$(jobs | wc -l | xargs)     # Get the number of jobs already started
            while [ "$runningJobs" -ge "$maxJobs" ]; do
                runningJobs=$(jobs | wc -l | xargs)     # Get the number of jobs already started
                sleep 1
            done
			iJob=$((iJob+1))

            echo Job number $iJob out of ${#run_list[@]} running now



            inputFile=${dataFolder}${detectorNames[${iDetector}]}/SIM/SIM_${detectorNames[${iDetector}]}_${particle}_${theta}_deg_${momentum}_GeV_${nEvents}_evts_edm4hep.root
			outputFolder=${dataFolder}${detectorNames[${iDetector}]}/REC/
            mkdir ${outputFolder}
            outputFile=${outputFolder}REC_${detectorNames[${iDetector}]}_${particle}_${theta}_deg_${momentum}_GeV_${nEvents}_evts

            echo "Running CLD reconstruction"
            k4run CLDReconstruction.py --inputFiles ${inputFile} \
            --outputBasename ${outputFile} \
            --GeoSvc.detectors ${detectors[${iDetector}]} \
            --trackingOnly  \
            --VXDBarrelDigitiserResolutionU ${VXDBarrelDigitiserResolutionU} \
            --VXDBarrelDigitiserResolutionV ${VXDBarrelDigitiserResolutionV} \
            --VXDEndcapDigitiserResolutionU ${VXDEndcapDigitiserResolutionU} \
            --VXDEndcapDigitiserResolutionV ${VXDEndcapDigitiserResolutionV} \
            -n ${nEvents} > ${outputFile}.log 2>&1 &
		done
	done
done

runningJobs=$(jobs | wc -l | xargs)     # Get the number of jobs already started
while [ "$runningJobs" -gt 1 ]; do
    runningJobs=$(jobs | wc -l | xargs)     # Get the number of jobs already started
    echo "$runningJobs jobs left"
    sleep 10
done
echo "Done!"