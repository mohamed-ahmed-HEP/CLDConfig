#!/bin/bash
##
## Copyright (c) 2014-2024 Key4hep-Project.
##
## This file is part of Key4hep.
## See https://key4hep.github.io/key4hep-doc/ for further info.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##


# nEvents=100  # same as used in simulation
nEvents=100000

particle="mu"
momenta=(1 10 100)

# Detector and geometry
# detectors=($K4GEO/FCCee/CLD/compact/CLD_o2_v07/CLD_o2_v07_FCC_SEED.xml)
# detectorNames=(CLD_o2_v07_FCC_SEED)
# detectorNames=(CLD_o2_v07_FCC_SEED_MatUpdate_2D_02_09)
detectorNames=(CLD_o2_v05_IDEAvertex_ultraLight_ALICE3_2D_02_09_OrgRot_0)

# dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v07_FCC_SEED_2D/
# dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v07_FCC_SEED_MatUpdate_2D_02_09/
dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v05_IDEAvertex_ultraLight_ALICE3_2D_02_09_OrgRot_0/


# IDEA ultra-light
detectors=($K4GEO/FCCee/CLD_IDEAvertex/compact/CLD_o2_v05_IDEAvertex/CLD_o2_v05_IDEAvertex.xml)
# detectorNames=(CLD_o2_v05_IDEAvertex)
# dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v05_IDEAvertex_2D/

mkdir -p ${dataFolder}
echo "Data folder: ${dataFolder}"

# CLD FCC-SEED vertex resolutions
# VXDBarrelDigitiserResolutionU="0.003 0.003 0.003 0.003 0.003"
# VXDBarrelDigitiserResolutionV=$VXDBarrelDigitiserResolutionU
# VXDEndcapDigitiserResolutionU="0.003 0.003 0.003 0.003 0.003 0.003"
# VXDEndcapDigitiserResolutionV=$VXDEndcapDigitiserResolutionU


# IDEA classic resolutions
# VXDBarrelDigitiserResolutionU="0.003 0.003 0.003 0.014 0.014"		# less resolution in outer disks?! 	outerVertexResolution_x
# VXDBarrelDigitiserResolutionV="0.003 0.003 0.003 0.043 0.043"		# less resolution in outer disks?! 	outerVertexResolution_y
# VXDEndcapDigitiserResolutionU="0.014 0.014 0.014"
# VXDEndcapDigitiserResolutionV="0.042 0.043 0.043"

# IDEA ultralight resolutions
# VXDBarrelDigitiserResolutionU="0.003 0.003 0.003 0.003 0.014 0.014"
# VXDBarrelDigitiserResolutionV="0.003 0.003 0.003 0.003 0.043 0.043"
# VXDEndcapDigitiserResolutionU="0.014 0.014 0.014"
# VXDEndcapDigitiserResolutionV="0.042 0.043 0.043"

# ALICE3 resolutions
VXDBarrelDigitiserResolutionU="0.003 0.003 0.003 0.003 0.014 0.014"
VXDBarrelDigitiserResolutionV="0.003 0.003 0.003 0.003 0.043 0.043"
VXDEndcapDigitiserResolutionU="0.014 0.014 0.014"
VXDEndcapDigitiserResolutionV="0.042 0.043 0.043"


# VXDBarrelDigitiserResolutionU (and V) of 0.003 0.003 0.003 0.003 0.014 0.014 and 0.003 0.003 0.003 0.003 0.042 0.042


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
