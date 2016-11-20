#!/bin/sh
# Compile and install freepascal v3.0.0
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

# Fail if the Pi model is unknown
fail_unknownmodel() {
  echo "${RED}Sorry, your Raspberry Pi model is currently unsupported / unknown.${NC}"
  echo "${RED}Please submit the output of ${CYAN}cat /proc/cpuinfo${RED} along with more information about your Rasperry Pi${NC}"
  echo "${RED}to the author, by opening a GitHub issue. Please include high resolution images of the top and bottom of the board.${NC}"
  exit 1
}

# Fail if the Pi model is unknown (compilation)
fail_unknown_compile_model() {
  echo "${RED}Sorry, your Raspberry Pi model is currently unsupported by this tool.${NC}"
  echo "${RED}(The compute module is currently not supported!)${NC}"
  exit 1
}

# Report Pi model
pireport() {
  if [ "$PIBOARD" = "" ]; then
    fail_unknownmodel
  fi
  echo "Your Pi: ${CYAN}${PIBOARD}${NC}"
  echo " - Model: ${CYAN}${PIMODEL}${NC}"
  echo " - Sub model: ${CYAN}${PISUBMODEL}${NC}"
  echo " - RAM: ${CYAN}${PIRAM}MB${NC}"
}

# Fail if the Pi has insufficient RAM
fail_ram256() {
  echo "${RED}Sorry, your board is not supported as it has insufficient RAM (256MB).${NC}"
  exit 1
}

# Warn if the Pi only has 512MB of RAM
warn_ram512() {
  echo "${YELLOW}WARNING: Your Pi has 512MB of RAM. This is enough as long as the GPU split is 16/32/64 and you are not running in a GUI.${NC}"
}

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="fpc_3_builder"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

# We must run as root
. $SCRIPT_CHECK_ROOT

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 1 ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

clear
echo "${BLUE}------------------------------------${NC}"
echo "${CYAN}fpc_3_builder version 0.1 (20161120)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${BLUE}------------------------------------${NC}"

echo "${GREEN}Determining Pi model...${NC}"
. $SCRIPT_GET_PI_MODEL
echo "${GREEN}Board revision is ${CYAN}${PIBOARDREVISION}${NC}"
echo
pireport
echo

# Fail for boards that do not have enough RAM - warn for 512MB RAM
if [ "$PIRAM" = "256" ]; then
  fail_ram256
fi
if [ "$PIRAM" = "512" ]; then
  warn_ram512
fi

case "$PIMODEL" in
  "0")
    # Might want a RAM check here.
    echo "${GREEN}This Raspberry Pi can compile freepascal.${NC}"
    ;;
  "1")
    # Might want a RAM check here.
    echo "${GREEN}This Raspberry Pi can compile freepascal.${NC}"
    ;;
  "2")
    echo "${GREEN}This Raspberry Pi can compile freepascal.${NC}"
    ;;
  "3")
    echo "${GREEN}This Raspberry Pi can compile freepascal.${NC}"
    ;;
  *)
    fail_unknown_compile_model
    ;;
esac

echo
echo
echo "${GREEN}Before proceeding, please confirm the following:${NC}"
echo "${YELLOW}1) This script assumes you do not already have freepascal installed, although if you do things should still work correctly.${NC}"
echo "${YELLOW}2) FPC 3.0.0 is not officially available for the Pi yet. Keep this in mind.${NC}"
echo "${YELLOW}3) If you currently use lazarus, STOP NOW. This script does not upgrade lazarus, so it will break!${NC}"
echo "${YELLOW}4) You are running in console mode, and have at least 400MB of RAM free or this will fail.${NC}"
echo "${YELLOW}5) For a Raspberry Pi 1 or Raspberry Pi Zero, please set the GPU split to 16MB first.${NC}"
echo "${YELLOW}6) This can take up to an hour especially on a Pi 1, and will stress your Raspberry Pi. An overclocked Pi may crash!${NC}"
echo "${YELLOW}7) If compilation fails partway through, you may end up with an unusable freepascal compiler. ${RED}Take a backup of your SD card.${NC}"
echo
echo
read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
echo
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

if [ ! -f "files/fpc-2.6.4.arm-linux-pi-bootstrap.tar.bz2" ]; then
  echo "${RED}Cannot find files/fpc-2.6.4.arm-linux-pi-bootstrap.tar.bz2 - Run this script from its own directory!${NC}"
  exit 1
fi

if [ ! -f "files/fpc-3.0.0-source.tar.bz2" ]; then
  echo "${RED}Cannot find files/fpc-3.0.0-source.tar.bz2 - Run this script from its own directory!${NC}"
  exit 1
fi

if [ ! -f "files/quietinstall.sh" ]; then
  echo "${RED}Cannot find files/quietinstall.sh - Run this script from its own directory!${NC}"
  exit 1
fi

# Set some variables about the version of FPC we want and other stuff

OLDDIR=$(pwd)
PACKAGEDIR="${PWD}/files/"
BOOTSTRAP="${PACKAGEDIR}fpc-2.6.4.arm-linux-pi-bootstrap.tar.bz2"
BOOTSTRAPDIR="fpc-2.6.4.arm-linux"
BOOTSTRAPVERNEEDED="2.6.4"
SOURCE="${PACKAGEDIR}fpc-3.0.0-source.tar.bz2"
SOURCEVER="3.0.0"
SOURCEDIR="source"
OUTPUTLOG="/usr/local/fpc/buildlog.log"

# Get the bootstrap compiler installed

echo "${GREEN}Preparing bootstrap compiler...${NC}"
mkdir /usr/local/fpc
cd /usr/local/fpc
tar -jSxf $BOOTSTRAP
if [ ! -d "${BOOTSTRAPDIR}" ]; then
  cd $OLDDIR
  echo "${RED}Could not find the unpacked files for the bootstrap compiler; unpack failed?${NC}"
  exit 1
fi

# Patch quietinstall.sh to avoid me having to push another huge file into the repo.....
cp $OLDDIR/files/quietinstall.sh $BOOTSTRAPDIR

echo "${GREEN}Installing bootstrap compiler - this will take a while...${NC}"
cd $BOOTSTRAPDIR
. ./quietinstall.sh

# Make sure the bootstrap compiler works and is the correct version

echo "${GREEN}Success - testing the bootstrap compiler...${NC}"
BOOTSTRAPVER=$(fpc -iW)
if [ $? != 0 ]; then
  cd $OLDDIR
  echo "${RED}Could not run the bootstrap compiler!${NC}"
  exit 1
fi
if [ "${BOOTSTRAPVER}" != "${BOOTSTRAPVERNEEDED}" ]; then
  cd $OLDDIR
  echo "${RED}The bootstrap compiler version is incorrect, it should be ${CYAN}${BOOTSTRAPVERNEEDED}${RED} but is ${CYAN}${BOOTSTRAPVER}${RED}${NC}"
  echo "${RED}Does this machine already have another version of freepascal installed?${NC}"
  exit 1
fi
echo "${GREEN}Success.${NC}"
echo

# Unpack the source code

echo "${GREEN}Unpacking the source code for freepascal ${CYAN}${SOURCEVER}${GREEN} - this will take a while...${NC}"
cd /usr/local/fpc
tar -jSxf $SOURCE
if [ ! -d "${SOURCEDIR}" ]; then
  cd $OLDDIR
  echo "${RED}Could not find the unpacked files for the source code; unpack failed?${NC}"
  exit 1
fi

# Ready to build!

cd $SOURCEDIR

case "$PIMODEL" in
  "0")
    echo "${GREEN}Setting compiler options for ${CYAN}Raspberry Pi Zero${NC}"
    OPT="-dFPC_ARMHF -CpARMV6 -OpARMV6"
    PREFIX="/usr/local"
    ;;
  "1")
    echo "${GREEN}Setting compiler options for ${CYAN}Raspberry Pi 1${NC}"
    OPT="-dFPC_ARMHF -CpARMV6 -OpARMV6"
    PREFIX="/usr/local"
    ;;
  "2")
    echo "${GREEN}Setting compiler options for ${CYAN}Raspberry Pi 2${NC}"
    OPT="-dFPC_ARMHF"
    PREFIX="/usr/local"
    ;;
  "3")
    echo "${GREEN}Setting compiler options for ${CYAN}Raspberry Pi 3${NC}"
    OPT="-dFPC_ARMHF"
    PREFIX="/usr/local"
    ;;
  *)
    cd $OLDDIR
    fail_unknown_compile_model
    ;;
esac

# Build the compiler

echo "${YELLOW}This may take a significant amount of time (an hour or so), please be patient.${NC}"
echo "${GREEN}Building the compiler and RTL (log output stored in ${YELLOW}${OUTPUTLOG}${GREEN})...${NC}"
make all OPT="$OPT" > $OUTPUTLOG 2>&1
if [ $? != 0 ]; then
  echo "${RED}Build failed. See ${YELLOW}${OUTPUTLOG}{$RED} for diagnosis.${NC}"
  echo $?
  cd $OLDDIR
  exit 1
fi

echo "${GREEN}Installing the compiler and RTL (log output stored in ${YELLOW}${OUTPUTLOG}${GREEN})...${NC}"
make install OPT="$OPT" PREFIX="$PREFIX" >> $OUTPUTLOG 2>&1
if [ $? != 0 ]; then
  echo "${RED}Installation failed. See ${YELLOW}${OUTPUTLOG}{$RED} for diagnosis.${NC}"
  echo $?
  cd $OLDDIR
  exit 1
fi

echo "${GREEN}Installing the sources (log output stored in ${YELLOW}${OUTPUTLOG}${GREEN})...${NC}"
make install sourceinstall OPT="$OPT" PREFIX="$PREFIX" >> $OUTPUTLOG 2>&1
if [ $? != 0 ]; then
  echo "${RED}Installation failed. See ${YELLOW}${OUTPUTLOG}{$RED} for diagnosis.${NC}"
  echo $?
  cd $OLDDIR
  exit 1
fi

echo "${GREEN}Setting up the new compiler...${NC}"
rm -f /usr/local/bin/ppcarm
ln -sf /usr/local/lib/fpc/3.0.0/ppcarm /usr/local/bin/ppcarm
ls -l /usr/local/bin/ppcarm
cp /etc/fpc.cfg /etc/fpc.cfg.backup

echo "${GREEN}Testing the new compiler...${NC}"
NEWVER=$(fpc -iW)
if [ $? != 0 ]; then
  cd $OLDDIR
  echo "${RED}Could not run the new compiler!${NC}"
  exit 1
fi
if [ "${NEWVER}" != "${SOURCEVER}" ]; then
  cd $OLDDIR
  echo "${RED}The new compiler version is incorrect, it should be ${CYAN}${SOURCEVER}${RED} but it is ${CYAN}${NEWVER}${RED}${NC}"
  exit 1
fi
echo "${GREEN}Success.${NC}"
echo
cd $OLDDIR

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED

echo "${GREEN}All done.${NC}"

exit 0
