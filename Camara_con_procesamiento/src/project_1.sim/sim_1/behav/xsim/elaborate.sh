#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Mon Dec 14 02:53:50 -05 2020
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto c9be66f33b86407ba8487a61a4f46e28 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot test_cam_TB_behav xil_defaultlib.test_cam_TB xil_defaultlib.glbl -log elaborate.log"
xelab -wto c9be66f33b86407ba8487a61a4f46e28 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot test_cam_TB_behav xil_defaultlib.test_cam_TB xil_defaultlib.glbl -log elaborate.log

