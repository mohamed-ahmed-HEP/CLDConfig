#!/bin/bash

# nEvents=100  # same as used in simulation
nEvents=100000

particle="mu"
momenta=(1 10 100)

# Detector and geometry
detectors=($K4GEO/FCCee/CLD/compact/CLD_o2_v07/CLD_o2_v07_FCC_SEED.xml)
detectorNames=(CLD_o2_v07_FCC_SEED)

# EOS simulation folder
dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v07_FCC_SEED_2D/
mkdir -p ${dataFolder}
echo "Data folder: ${dataFolder}"

# CLD FCC-SEED vertex resolutions
VXDBarrelDigitiserResolutionU="0.003 0.003 0.003 0.003 0.003"
VXDBarrelDigitiserResolutionV=$VXDBarrelDigitiserResolutionU
VXDEndcapDigitiserResolutionU="0.003 0.003 0.003 0.003 0.003 0.003"
VXDEndcapDigitiserResolutionV=$VXDEndcapDigitiserResolutionU

maxJobs=9
iJob=0

for iDetector in "${!detectors[@]}"; do
	for momentum in "${momenta[@]}"; do

		runningJobs=$(jobs | wc -l | xargs)
		while [ "$runningJobs" -ge "$maxJobs" ]; do
			runningJobs=$(jobs | wc -l | xargs)
			sleep 1
		done

		iJob=$((iJob+1))
		echo "Reco job $iJob: momentum ${momentum} GeV"

		inputFile=${dataFolder}${detectorNames[${iDetector}]}/SIM/SIM_${detectorNames[${iDetector}]}_${particle}_phi0to90_cosTheta0to1_${momentum}GeV_${nEvents}evts_edm4hep.root

		outputDir=${dataFolder}${detectorNames[${iDetector}]}/REC/
		mkdir -p ${outputDir}
		outputFile=${outputDir}REC_${detectorNames[${iDetector}]}_${particle}_phi0to90_cosTheta0to1_${momentum}GeV_${nEvents}evts

		k4run CLDReconstruction.py \
			--inputFiles ${inputFile} \
			--outputBasename ${outputFile} \
			--GeoSvc.detectors ${detectors[${iDetector}]} \
			--trackingOnly \
			--VXDBarrelDigitiserResolutionU ${VXDBarrelDigitiserResolutionU} \
			--VXDBarrelDigitiserResolutionV ${VXDBarrelDigitiserResolutionV} \
			--VXDEndcapDigitiserResolutionU ${VXDEndcapDigitiserResolutionU} \
			--VXDEndcapDigitiserResolutionV ${VXDEndcapDigitiserResolutionV} \
			-n ${nEvents} \
			> ${outputFile}.log 2>&1 &
	done
done

# Wait for all reco jobs to finish
runningJobs=$(jobs | wc -l | xargs)
while [ "$runningJobs" -gt 1 ]; do
    runningJobs=$(jobs | wc -l | xargs)     # Get the number of jobs already started
	echo "$runningJobs reco jobs left"
	sleep 10
done
echo "Reconstruction done!"
