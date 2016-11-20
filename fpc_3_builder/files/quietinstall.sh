#!/usr/bin/env bash
#
# Free Pascal installation script for Unixy platforms.
# Copyright 1996-2004 Michael Van Canneyt, Marco van de Voort and Peter Vreman
#
# Don't edit this file.
# Everything can be set when the script is run.
#

# Release Version will be replaced by makepack
VERSION=2.6.4
FULLVERSION=2.6.4

# some useful functions

CMDTAR="tar"
TAR="$CMDTAR --no-same-owner"
# Untar files ($3,optional) from  file ($1) to the given directory ($2)
unztar ()
{
 $TAR -xzf "$HERE/$1" -C "$2" $3
}

# Untar tar.gz file ($2) from file ($1) and untar result to the given directory ($3)
unztarfromtar ()
{
 $CMDTAR -xOf "$HERE/$1" "$2" | $TAR -C "$3" -xzf -
}

# Get file list from tar archive ($1) in variable ($2)
# optionally filter result through sed ($3)
listtarfiles ()
{
  askvar="$2"
  if [ ! -z "$3" ]; then
    list=`$CMDTAR tvf "$1" | awk '{ print $(NF) }' | sed -n /"$3"/p`
  else
     list=`$CMDTAR tvf "$1" | awk '{ print $(NF) }'`
  fi
  eval $askvar='$list'
}

# Make all the necessary directories to get $1
makedirhierarch ()
{
  mkdir -p "$1"
}

# check to see if something is in the path
checkpath ()
{
 ARG="$1"
 OLDIFS="$IFS"; IFS=":";eval set "$PATH";IFS="$OLDIFS"
 for i
 do
   if [ "$i" = "$ARG" ]; then
     return 0
   fi
 done
 return 1
}

# Install files from binary-*.tar
#  $1 = cpu-target
#  $2 = cross prefix
installbinary ()
{
  if [ "$2" = "" ]; then
    FPCTARGET="$1"
    CROSSPREFIX=
  else
    FPCTARGET=`echo $2 | sed 's/-$//'`
    CROSSPREFIX="$2"
  fi

  BINARYTAR="${CROSSPREFIX}binary.$1.tar"

  # conversion from long to short archname for ppc<x>
  case $FPCTARGET in
    m68k*)
      PPCSUFFIX=68k;;
    sparc*)
      PPCSUFFIX=sparc;;
    i386*)
      PPCSUFFIX=386;;
    powerpc64*)
      PPCSUFFIX=ppc64;;
    powerpc*)
      PPCSUFFIX=ppc;;
    arm*)
      PPCSUFFIX=arm;;
    x86_64*)
      PPCSUFFIX=x64;;
    mips*)
      PPCSUFFIX=mips;;
    ia64*)
      PPCSUFFIX=ia64;;
    alpha*)
      PPCSUFFIX=axp;;
  esac

  # Install compiler/RTL. Mandatory.
  echo "Installing compiler and RTL for $FPCTARGET..."
  unztarfromtar "$BINARYTAR" "${CROSSPREFIX}base.$1.tar.gz" "$PREFIX"

  if [ -f "binutils-${CROSSPREFIX}$1.tar.gz" ]; then
    unztar "binutils-${CROSSPREFIX}$1.tar.gz" "$PREFIX"
  fi

  # Install symlink
  rm -f "$EXECDIR/ppc${PPCSUFFIX}"
  ln -sf "$LIBDIR/ppc${PPCSUFFIX}" "$EXECDIR/ppc${PPCSUFFIX}"

  echo "Installing utilities..."
  unztarfromtar "$BINARYTAR" "${CROSSPREFIX}utils.$1.tar.gz" "$PREFIX"

  # Should this be here at all without a big Linux test around it?
  if [ "x$UID" = "x0" ]; then
    chmod u=srx,g=rx,o=rx "$PREFIX/bin/grab_vcsa"
  fi

  ide=`$TAR -tf $BINARYTAR | grep "${CROSSPREFIX}ide.$1.tar.gz"`
  if [ "$ide" = "${CROSSPREFIX}ide.$1.tar.gz" ]; then
    unztarfromtar "$BINARYTAR" "${CROSSPREFIX}ide.$1.tar.gz" "$PREFIX"
  fi

  listtarfiles "$BINARYTAR" packages units
  for f in $packages
  do
    if echo "$f" | grep -q fcl > /dev/null ; then
      p=`echo "$f" | sed -e 's+^.*units-\([^\.]*\)\..*+\1+'`
      echo "Installing $p"
      unztarfromtar "$BINARYTAR" "$f" "$PREFIX"
    fi
  done
  listtarfiles "$BINARYTAR" packages units
  for f in $packages
  do
    if ! echo "$f" | grep -q fcl > /dev/null ; then
      p=`echo "$f" | sed -e 's+^.*units-\([^\.]*\)\..*+\1+'`
      echo "Installing $p"
      unztarfromtar "$BINARYTAR" "$f" "$PREFIX"
    fi
  done
  rm -f *."$1".tar.gz
}


# Zipplet: Modified to install to /usr/local and ask no questions.
# --------------------------------------------------------------------------

# Here we start the thing.
HERE=`pwd`

OSNAME=`uname -s | tr A-Z a-z`

PREFIX=/usr/local

# Support ~ expansion
PREFIX=`eval echo $PREFIX`
export PREFIX
makedirhierarch "$PREFIX"

# Set some defaults.
LIBDIR="$PREFIX/lib/fpc/$VERSION"
SRCDIR="$PREFIX/src/fpc-$VERSION"
EXECDIR="$PREFIX/bin"

BSDHIER=0
case "$OSNAME" in
*bsd)
  BSDHIER=1;;
esac

SHORTARCH="$ARCHNAME"
FULLARCH="$ARCHNAME-$OSNAME"
DOCDIR="$PREFIX/share/doc/fpc-$VERSION"

case "$OSNAME" in
  freebsd)	
     # normal examples are already installed in fpc-version. So added "demo"
     DEMODIR="$PREFIX/share/examples/fpc-$VERSION/demo"
     ;;
  *)
     DEMODIR="$DOCDIR/examples"
     ;;
esac

# Install all binary releases
for f in *binary*.tar
do
  target=`echo $f | sed 's+^.*binary\.\(.*\)\.tar$+\1+'`
  cross=`echo $f | sed 's+binary\..*\.tar$++'`

  installbinary "$target" "$cross"
done

echo Done.
echo

# Install the documentation. Optional.
if [ -f doc-pdf.tar.gz ]; then
  echo Installing documentation in "$DOCDIR" ...
  makedirhierarch "$DOCDIR"
  unztar doc-pdf.tar.gz "$DOCDIR" "--strip 1"
  echo Done.
fi
echo

# Install the demos. Optional.
if [ -f demo.tar.gz ]; then
  echo Installing demos in "$DEMODIR" ...
  makedirhierarch "$DEMODIR"
  unztar demo.tar.gz "$DEMODIR"
  echo Done.
fi
echo

# Install /etc/fpc.cfg, this is done using the samplecfg script
if [ "$cross" = "" ]; then
  "$LIBDIR/samplecfg" "$LIBDIR"
else
  echo "No fpc.cfg created because a cross installation has been done."
fi

# The End
