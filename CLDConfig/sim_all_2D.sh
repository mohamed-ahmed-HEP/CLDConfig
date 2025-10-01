#!/bin/bash

nEvents=100000
# nEvents=100

particle="mu"
charge="-"
momenta=(1 10 100)

# FCC-SEED
detectors=($K4GEO/FCCee/CLD/compact/CLD_o2_v07/CLD_o2_v07_FCC_SEED.xml)
# detectorNames=(CLD_o2_v07_FCC_SEED)
detectorNames=(CLD_o2_v07_FCC_SEED_MatUpdate_2D_03_09)
dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v07_FCC_SEED_MatUpdate_2D_03_09/
# dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v07_FCC_SEED_2D/

# IDEA ultra-light
# detectors=($K4GEO/FCCee/CLD_IDEAvertex/compact/CLD_o2_v05_IDEAvertex/CLD_o2_v05_IDEAvertex.xml)
# detectorNames=(CLD_o2_v05_IDEAvertex)	
# dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v05_IDEAvertex_2D/

# IDEA ultra-light ALICE3
# detectorNames=(CLD_o2_v05_IDEAvertex_ultraLight_ALICE3_TEST60deg)
# detectors=($K4GEO/FCCee/CLD_IDEAvertex/compact/CLD_o2_v05_IDEAvertex/CLD_o2_v05_IDEAvertex.xml)
# detectorNames=(CLD_o2_v05_IDEAvertex_ultraLight_ALICE3_2D_02_09_OrgRot_0)
# dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v05_IDEAvertex_ultraLight_ALICE3_2D_02_09_OrgRot_0/

mkdir -p ${dataFolder}
echo "Data folder: ${dataFolder}"

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
		echo "Job number $iJob: momentum ${momentum} GeV"

		outputDir=${dataFolder}${detectorNames[${iDetector}]}/SIM/
		mkdir -p ${outputDir}

		outputFileName=SIM_${detectorNames[${iDetector}]}_${particle}_phi0to90_cosTheta0to1_${momentum}GeV_${nEvents}evts_edm4hep

		ddsim --compactFile ${detectors[${iDetector}]} \
			--outputFile ${outputDir}${outputFileName}.root \
			--steeringFile cld_steer.py \
			--random.seed $((RANDOM + iJob)) \
			--enableGun \
			--gun.particle ${particle}${charge} \
			--gun.energy "${momentum}*GeV" \
            --gun.distribution "cos(theta)" \
  			--gun.thetaMin "0*deg" --gun.thetaMax "90*deg" \
			--gun.phiMin "0*deg" --gun.phiMax "90*deg" \
			--crossingAngleBoost 0 \
			--numberOfEvents ${nEvents} \
			> ${outputDir}${outputFileName}.log 2>&1 &
	done
done

# Wait for all background simulation jobs to finish
runningJobs=$(jobs | wc -l | xargs)
while [ "$runningJobs" -gt 1 ]; do
    runningJobs=$(jobs | wc -l | xargs)
    echo "$runningJobs jobs left"
    sleep 10
done

echo "Done!"
