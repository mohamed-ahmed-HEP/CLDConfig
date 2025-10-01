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

# condor_sim.sh

# Arguments passed from Condor
MOMENTUM=$1
SEED=$2
NEVENTS=$3
OUTDIR=$4

PARTICLE="mu"
CHARGE="-"
DETECTOR_XML="$K4GEO/FCCee/CLD/compact/CLD_o2_v07/CLD_o2_v07_FCC_SEED.xml"
DETECTOR_NAME="CLD_o2_v07_FCC_SEED"

# Output file name
FILENAME=SIM_${DETECTOR_NAME}_${PARTICLE}_phi0to90_cosTheta0to1_${MOMENTUM}GeV_${NEVENTS}evts_edm4hep

mkdir -p ${OUTDIR}

ddsim --compactFile ${DETECTOR_XML} \
  --outputFile ${OUTDIR}/${FILENAME}.root \
  --steeringFile cld_steer.py \
  --random.seed ${SEED} \
  --enableGun \
  --gun.particle ${PARTICLE}${CHARGE} \
  --gun.energy "${MOMENTUM}*GeV" \
  --gun.distribution "cos(theta)" \
  --gun.thetaMin "0*deg" --gun.thetaMax "90*deg" \
  --gun.phiMin "0*deg" --gun.phiMax "90*deg" \
  --crossingAngleBoost 0 \
  --numberOfEvents ${NEVENTS} \
  > ${OUTDIR}/${FILENAME}.log 2>&1
