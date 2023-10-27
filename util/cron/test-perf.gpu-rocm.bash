#!/usr/bin/env bash
#
# Run GPU performance tests

CWD=$(cd $(dirname ${BASH_SOURCE[0]}) ; pwd)
source $CWD/common-slurm-gasnet-cray-cs.bash
source $CWD/common-native-gpu.bash

export CHPL_GPU=amd
export CHPL_GPU_ARCH=gfx906
export CHPL_LLVM=bundled
export CHPL_COMM=none
export CHPL_LAUNCHER_PARTITION=amdMI60
module load rocm


source $CWD/common-native-gpu-perf.bash
export CHPL_TEST_PERF_CONFIG_NAME="1-node-mi60"
export CHPL_NIGHTLY_TEST_CONFIG_NAME="perf.gpu-rocm"
unset CHPL_TEST_PERF_CONFIGS      # not applicable for this config

nightly_args="${nightly_args} -startdate 07/20/23"
$CWD/nightly -cron ${nightly_args}
