#!/bin/bash
# SAA Help Export Script
# This script exports help documentation for all SAA commands
# Usage: ./export_help.sh [output_dir]

set -e

OUTPUT_DIR="${1:-./reference}"
COMMANDS_DIR="$OUTPUT_DIR/commands"

echo "SAA Help Export Script"
echo "======================"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Create output directories
mkdir -p "$COMMANDS_DIR"

# Export main help
echo "Exporting main help..."
saa -h 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' >"$OUTPUT_DIR/saa_help.txt"
echo "  -> $OUTPUT_DIR/saa_help.txt"

# Command list (all 217 SAA commands)
COMMANDS=(
	# License Management
	ActivateProductKey QueryProductKey CpuOnDemand

	# Health Management
	CheckOOBSupport CheckAssetInfo CheckSystemUtilization CheckSensorData
	HDTService ServiceCalls SystemPFA MemoryHealthCheck ChassisIntrusion
	AlertManage SendDiagInterrupt CheckSelfTest SuperDiag TasManage

	# System Management
	GetFruInfo RestoreFruInfo ChangeFruInfo GetFanMode SetFanMode
	GetFirmwareInventoryInfo ClearCMOS LocateServerUid UpdateFirmware
	GetSystemCfg ChangeSystemCfg GetSystemInfo

	# BIOS Management
	GetBiosInfo UpdateBios GetDefaultBiosCfg GetCurrentBiosCfg ChangeBiosCfg
	LoadDefaultBiosCfg SetBiosPassword GetDmiInfo ChangeDmiInfo EditDmiInfo
	EraseOAKey GetScpInfo UpdateScp GetFixedBootCfg ChangeFixedBootCfg
	GetBiosPostCode SetHttpBoot GetBootOption SetBootOption

	# BMC Management
	GetBmcInfo UpdateBmc GetBmcCfg ChangeBmcCfg GetBmcLANCfg ChangeBmcLANCfg
	SetBmcPassword GetKcsPriv SetKcsPriv LoadDefaultBmcCfg GetBmcUserList
	SetBmcUserList BootStrappingAccount RmcpManage GetSessionInfo SessionManage
	BmcHostName DownloadBmcCfg UploadBmcCfg BmcIPv6StaticRouteManage BmcReset
	ManageRHI SnmpManage BmcWatchDog

	# System Event Log
	GetEventLog ClearEventLog GetMaintenEventLog ClearMaintenEventLog
	SetSELTimeMode GetHostDump

	# CMM Management
	GetCmmInfo UpdateCmm GetCmmCfg ChangeCmmCfg SetCmmPassword LoadDefaultCmmCfg
	GetBbpInfo UpdateBbp GetBladePowerStatus SetBladePowerAction ProfileManage
	BladePsuManage BladeSummary BladeConsole GetCmmUserList SetCmmUserList
	UpdateDummySwitch BladeNodeManage

	# Storage Management
	GetRaidControllerInfo UpdateRaidController GetRaidCfg ChangeRaidCfg
	GetSataInfo GetNvmeInfo ControlNVMe GetPMemInfo UpdatePMem GetVROCCfg
	ChangeVROCCfg GetSmartData GetSasExpanderInfo UpdateSasExpander

	# Power Management
	GetPsuInfo UpdatePsu GetPowerStatus SetPowerAction DcmiManage PowerPolicy
	GetAcpiPowerStatus GetPsFruInfo GetAiomStandbyPower SetAiomStandbyPower
	CpuPowerManage GetPowerShelfInfo UpdatePowerShelf

	# PCIe-Switch Management
	GetPCIeSwitchInfo UpdatePCIeSwitch

	# Applications
	GetUsbAccessMode SetUsbAccessMode RawCommand KmsManage RedfishApi Shell
	Prompt RemoteConsole RemoteScreenshot RemoteKeyboard Sol FindBmcDevices
	FoundBmcDevices GetUSBHostControllerInfo UpdateUSBHostController
	RemoteScreenVideo RemoteExec

	# GPU Management
	GetGpuInfo UpdateGpu DiagGpuStatus GetGpuLog GpuPowerManage

	# CPLD Management
	GetCpldInfo UpdateCpld GetFanboardCpldInfo UpdateFanboardCpld
	GetSwitchboardCpldInfo UpdateSwitchboardCpld GetTransitionboardCpldInfo
	UpdateTransitionboardCpld GetMiscCpldInfo UpdateMiscCpld GetAomboardCpldInfo
	UpdateAomboardCpld GetNICCpldInfo UpdateNICCpld GetMidplaneSbbCpldInfo
	UpdateMidplaneSbbCpld GetBackplaneCpldInfo UpdateBackplaneCpld
	GetAipCpldInfo UpdateAipCpld

	# FPGA Management
	GetMotherboardFpgaInfo UpdateMotherboardFpga

	# NIC Management
	GetAocNICInfo UpdateAocNIC

	# Multi-Node Management
	GetMultinodeEcInfo UpdateMultinodeEc GetMultinodeLcmcInfo UpdateMultinodeLcmc
	GetTpInfo ChangeTpInfo

	# VM Management
	MountIsoImage UnmountIsoImage MountFloppyImage UnmountFloppyImage
	GetVmInfo VmManage

	# NM Management
	NmMeManage GeneralNmManage NmCpuManage NmCupsManage BmcNmManage

	# Security Management
	BiosRotManage SecureBootManage GetLockdownMode SetLockdownMode BmcRotManage
	Attestation CmmRotManage SecureEraseDisk SecureEraseRaidHdd TpmProvision
	TpmManage GetTpmInfo UpdateTpm CpldRotManage GetCpuERotInfo UpdateCpuERot
	CpuERotManage GetGpuERotInfo FpgaRotManage GetSpdmInfo CertManage

	# MCU Management
	GetMotherboardMcuInfo UpdateMotherboardMcu

	# Switch Management
	NvSwitchManage GetBladeSwitchInfo UpdateBladeSwitch RebootBladeSwitch

	# Liquid Cooling Management
	MonitorCDUStatus UpdateCDU
)

# Export help for each command
echo ""
echo "Exporting command help (${#COMMANDS[@]} commands)..."
count=0
success=0
failed=0

for cmd in "${COMMANDS[@]}"; do
	count=$((count + 1))
	outfile="$COMMANDS_DIR/${cmd}.txt"

	if saa -h -c "$cmd" 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' >"$outfile"; then
		if [ -s "$outfile" ]; then
			success=$((success + 1))
		else
			rm -f "$outfile"
			failed=$((failed + 1))
		fi
	else
		rm -f "$outfile"
		failed=$((failed + 1))
	fi

	# Progress every 50 commands
	if [ $((count % 50)) -eq 0 ]; then
		echo "  Progress: $count / ${#COMMANDS[@]}"
	fi
done

echo ""
echo "Export complete!"
echo "  Total commands: ${#COMMANDS[@]}"
echo "  Successful: $success"
echo "  Failed/Empty: $failed"
echo "  Output directory: $OUTPUT_DIR"
echo ""
echo "Files:"
echo "  - $OUTPUT_DIR/saa_help.txt"
echo "  - $COMMANDS_DIR/*.txt ($success files)"
