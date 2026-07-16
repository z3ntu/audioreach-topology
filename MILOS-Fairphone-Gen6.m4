# SPDX-License-Identifier: BSD-3-Clause
# Copyright, Jorijn van der Graaf, 2026
# Copyright, Luca Weiss, 2026
include(`audioreach/audioreach.m4')
include(`audioreach/stream-subgraph.m4')
include(`audioreach/device-subgraph.m4')
include(`util/route.m4')
include(`util/mixer.m4')
include(`audioreach/tokens.m4')
#
# Stream SubGraph for MultiMedia1 Playback
#
#  ______________________________________________
# |               Sub Graph 1                    |
# | [WR_SH] -> [PCM DEC] -> [PCM CONV] -> [LOG]  |- Kcontrol
# |______________________________________________|
#
dnl Playback MultiMedia1
STREAM_SG_PCM_ADD(audioreach/subgraph-stream-vol-playback.m4, FRONTEND_DAI_MULTIMEDIA1,
	`S16_LE', 48000, 48000, 2, 2,
	0x00004001, 0x00004001, 0x00006001, `110000')
dnl
#
# Device SubGraph for Senary MI2S RX Backend (stereo AW88261)
#
#         ___________________
#        |   Sub Graph 2     |
# Mixer -| [LOG] -> [I2S EP] |
#        |___________________|
#
dnl Senary MI2S Playback (32-bit slots: AW88261 boost needs 3.072 MHz BCLK)
DEVICE_SG_ADD(audioreach/subgraph-device-i2s-playback-mfc.m4, `Senary', SENARY_MI2S_RX,
	`S32_LE', 48000, 48000, 2, 2,
	LPAIF_INTF_TYPE_WSA, I2S_INTF_TYPE_PRIMARY, SD_LINE_IDX_I2S_SD0, DATA_FORMAT_FIXED_POINT,
	0x00004006, 0x00004006, 0x00006060, `SEN_MI2S_RX')

STREAM_DEVICE_PLAYBACK_MIXER(SENARY_MI2S_RX, ``SEN_MI2S_RX'', ``MultiMedia1'')
STREAM_DEVICE_PLAYBACK_ROUTE(SENARY_MI2S_RX, ``SEN_MI2S_RX Audio Mixer'', ``MultiMedia1, stream0.logger1'')
