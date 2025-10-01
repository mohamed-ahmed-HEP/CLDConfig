#!/bin/bash
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
