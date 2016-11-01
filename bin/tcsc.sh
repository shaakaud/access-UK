#! /bin/sh
###############################################################################
#
# Usage:
#
#     cscope-indexer [ -v ] [ -l ] [DIR]
#
# where:
#
#    DIR  defaults to '.'
#
#     -l
#          Suppress the generation/updating of the cscope database
#          file.  Only a list of files is generated.
#
#     -v
#          Be verbose.  Output simple progress messages.
#
#
###############################################################################
set -e

# May have to edit this:
if [ -n "$CSCOPE_PATH" ]; then
    PATH="$CSCOPE_PATH:$PATH"
    export PATH
else
    PATH="/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin:$PATH"
    export PATH
fi

LIST_ONLY=
DIR='.'
LIST_FILE='cscope.files'
DATABASE_FILE='cscope.out'
RECURSE=1
VERBOSE=0

export DIR RECURSE          # Need to pass these to subprocesses

while [ -n "$1" ]
do
    case "$1" in
    -l)
        LIST_ONLY=1
        ;;
    -v)
        VERBOSE=1
        ;;
    *)
        DIR="$1"
        ;;
    esac
    shift
done

if [ -f 'make/get_output_dir.sh' ]; then
    GEN_DIR_BASE=$(make/get_output_dir.sh gen)
    SKIP_DIRS="! -path \"${DIR}/gen*/*\""
fi

cd $DIR

[ $VERBOSE -ne "0" ] && echo "Creating list of files to index ..."

(
    if [ "X$RECURSE" = "X" ]
    then
        # Ugly, inefficient, but it works.
        [ -d panos ] && EXTRA=panos/
        [ -d gash ] && EXTRA=gash/
        for f in ${EXTRA}*
        do
            echo "${DIR}/${EXTRA}$f"
        done
    else
        eval "find $DIR $SKIP_DIRS \( -type f \)"
        [ -n "$GEN_DIR_BASE" ] && find $GEN_DIR_BASE \( -type f \)
    fi
) | \
    egrep -i '\.([chlys](xx|pp)*|cc|hh|tcl|inc)$' | \
    sed -e '/\/CVS\//d' -e '/\/RCS\//d' -e 's/^\.\///' -r -e '/^(panos\/)?(lib.*|bin.*|deps.*|objs.*|\.git|\.hg)\//d' -e '/gen\/.*\/work\//d' | \
    sort > $LIST_FILE

[ $VERBOSE -ne "0" ] &&  echo "Creating list of files to index ... done"

if [ "X$LIST_ONLY" != "X" ]
then
    exit 0
fi

[ $VERBOSE -ne "0" ] &&  echo "Indexing files ..." && cscope --version

cscope -b -q -k -i $LIST_FILE

[ $VERBOSE -ne "0" ] &&  echo "Indexing files ... done"

exit 0

