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
nEvents=3000

particle="mu"
charge="-"

thetas=(90 87.13401602 84.26082952 81.37307344 78.46304097 75.52248781 72.54239688 69.51268489 66.42182152 63.25631605 60 56.63298703 53.13010235 49.45839813 45.572996 41.40962211 36.86989765 31.78833062 25.84193276 18.19487234 8.109614456)

momenta=(1 10 100)



detectors=($K4GEO/FCCee/CLD_IDEAvertex/compact/CLD_o2_v05_IDEAvertex/CLD_o2_v05_IDEAvertex.xml)
detectorNames=(CLD_o2_v05_IDEAvertex_ultraLight)
dataFolder=/eos/user/a/ahmedmo/data_sim_fcc/CLD_o2_v05_IDEAvertex_ultraLight/


mkdir ${dataFolder}
echo Data folder: ${dataFolder}

maxJobs=9
iJob=0
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


			# mkdir /home/hep/arilg/VertexingPerformance/CLDConfig/CLDConfig/${detectorNames[${iDetector}]}
			# outputDir=/home/hep/arilg/VertexingPerformance/CLDConfig/CLDConfig/${detectorNames[${iDetector}]}/SIM/
			mkdir ${dataFolder}${detectorNames[${iDetector}]}
			outputDir=${dataFolder}${detectorNames[${iDetector}]}/SIM/

			mkdir ${outputDir}
			outputFileName=SIM_${detectorNames[${iDetector}]}_${particle}_${theta}_deg_${momentum}_GeV_${nEvents}_evts_edm4hep

			ddsim --compactFile ${detectors[${iDetector}]} \
			--outputFile ${outputDir}${outputFileName}.root \
			--steeringFile cld_steer.py --random.seed 0123456789 \
			--enableGun --gun.particle ${particle}${charge} --gun.energy "${momentum}*GeV" \
			--gun.distribution uniform --gun.thetaMin "${theta}*deg" --gun.thetaMax "${theta}*deg" \
			--crossingAngleBoost 0 --numberOfEvents ${nEvents} \
			> ${outputDir}${outputFileName}.log 2>&1 &
		done
	done
done

			# --gun.phiMin "${phi}" --gun.phiMax "${phi}" \

runningJobs=$(jobs | wc -l | xargs)     # Get the number of jobs already started
while [ "$runningJobs" -gt 1 ]; do
    runningJobs=$(jobs | wc -l | xargs)     # Get the number of jobs already started
    echo "$runningJobs jobs left"
    sleep 10
done
echo "Done!"
