
PREF_MK_LOCATION=~/access-UK/new_clone/prefs.mk
CSCOPE_INDEXER=/usr/local/timostools/cscope-indexer.sh
GIT=/usr/bin/git
GIT_IGNORE=~/access-UK/new_clone/git_ignore_for_panos
CVS_CO_OP_FILE=cvs_co_op_file

debug_dirs="iom iom_api"

usage()
{
  echo "$0 .. ultimate new_cloner script .."
  echo ""
  echo "Usage: $0 [-x path/to/patch] [-p <patch-arg>] [-h] <branch> <comments>"
  echo ""
  echo " -g <dir>         use this directory to collect git'ish patches and commit-info. Overrides -x"
  echo " -x <patch>       a path to the patch."
  echo " -p <patch>       patch arg to use. Default is 0. Ignored if -x isn't used"
  echo " -h               print this help and exit"
  echo " -n               disable pointer checks"
  echo " -c               dont start making"
  echo ""
  echo " <branch>         mandatory arg."
  echo " <comments>       mandatory arg. This creates a entry in 'comments' file in pwd for later use by check_clones. Give sth meaningful!"
  echo ""
  echo "gittish dir:"
  echo " This dir should have a gitstatus file that has exactly n lines as there are commits to patch and a bunch of patch_N files."
  echo " The first field is ignored .. The rest are used at commit comments"
  echo ' The last line is used against a patch_(n-1), last but one against patch_(n-2) .. and first one against patch_0'
  echo ' Finally, if a patch_00 file is present, its applied and left unstaged'
  echo ' If you are saving a work-space, simply do '
  echo '     git log --pretty=oneline | head -n -1 > gitstatus'
  echo '     for i in $(seq 1 $(cat gitstatus | wc -l)) ; do ii=$(expr $i - 1); git export HEAD~$ii > patch_$ii ; done'
  echo '     git diff > patch_00'
  exit 1;
}

verify_gittish_dir()
{
  dir=$1
  if [ ! -d $dir ] ; then
    echo "$dir doesn't seem to be a valid directory"; usage
  fi
  curr=$(pwd)
  cd $dir
  if [ ! -f gitstatus ]; then
    echo "gitstatus file doesn't exist in $dir"; usage
  fi
  number=$(cat gitstatus | wc -l)
  if [ ! $number -ge 1 ] ; then
    echo "gitstatus doesn't have even one line"; usage
  fi
  for i in $(seq 1 $number); do
    ii=$(expr $i - 1)
    if [ ! -f patch_$ii ] ; then
      echo "file patch_$ii doesn't seem to exist, but is expected"; usage
    fi
  done
  cd $curr
}

git_patches=0
gittish_dir=""
patches=0
patch_file=""
patch_p_arg=0
disable_ptr_check=0
skip_compile=0

while getopts "g:x:p:nch" opt; do
  case $opt in
    x)
      patches=1
      patch_file=$OPTARG
      mkdir -p panos ; cd panos
      if [ ! -f $patch_file ] ; then 
         echo "$patch_file doesn't seem to be a regular file"
         usage $0
      fi
      cd ../
      rmdir panos
      if [ $? -ne 0 ] ; then
         echo "panos exists and is not empty!"
         exit 1
      fi
      ;;
    g)
      git_patches=1
      gittish_dir=$OPTARG
      verify_gittish_dir $gittish_dir
      ;;
    p)
      patch_p_arg="$OPTARG"
      ;;
    n)
      disable_ptr_check=1
      ;;
    c)
      skip_compile=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage $0
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "$1" ] ; then
  echo "Supply a branch!"
  usage
fi

BRANCH=$1
shift

if [ -z "$1" ] ; then
  echo "Supply a comment!"
  usage
fi

environment=$(uname)
linux=0
cygwin=1
if [[ $environment == *"Linux"* ]] ; then
  echo "its a linux environment!"
  linux=1
  GIT=git
else 
  echo "Assuming a cygwin environment!"
fi

echo "$1" > comments

echo "checking out $BRANCH .. Please check $CVS_CO_OP_FILE for activity"
cvs co -r $BRANCH panos > $CVS_CO_OP_FILE 2> $CVS_CO_OP_FILE

echo "running cvsrw"
cd panos 
cp $PREF_MK_LOCATION .
#if [ $linux -eq 1 ] ; then
#  sed -i "s/DIST := 1/DIST := 0/" prefs.mk
#fi
#if [ $disable_ptr_check -eq 1 ] ; then 
#  sed -i "/PTR_CHCK_MODE/d" prefs.mk
#  sed -i "/PTR_CHCK_MOD_WHITE_LIST/" prefs.mk
#fi
#for i in $debug_dirs ; do 
#  echo "BUILD_TYPE:=opt_dbg" > $i/prefs.mk
#done
cvsrw --cvs
cd ..

echo "Making up the git repository"
$GIT init .
cp $GIT_IGNORE .gitignore
$GIT add . 
$GIT commit -m "Initial commit on $(date)" 

if [ $git_patches -eq 1 ] ; then 
  echo "Patching git-patches from $gittish_dir"
  cd panos
  number=$(cat $gittish_dir/gitstatus | wc -l)
  tac $gittish_dir/gitstatus | while read i ; do
    number=$(expr $number - 1)
    patch_comments=$(echo $i | cut -d\  -f2-)
    echo "Patching $gittish_dir/patch_$number with comments - $patch_comments"
    git supercommitpatch $gittish_dir/patch_$number "$patch_comments"
    if [ $? -ne 0 ] ; then
      echo "Trouble in applying git patch patch_$number"
      exit 1
    fi
  done
  if [ -f $gittish_dir/patch_00 ] ; then
    patch -p2 -i $gittish_dir/patch_00
    if [ $? -ne 0 ] ; then
      echo "Trouble in applying git patch patch_00"
      exit 1
    fi
    chmod +w $(git lsm)
  fi
  cd ..
elif [ $patches -eq 1 ] ; then
  echo "Patching $patch_file"
  cd panos 
  patch -p$patch_p_arg -i $patch_file
  if [ $? -ne 0 ] ; then
    echo "Some Trouble patching"
    exit 1
  fi
  chmod +w $(git ls-files --modified)
  cd ..
fi

echo "Creating cscope"
$CSCOPE_INDEXER &

cd panos
if [ $skip_compile -eq 1 ] ; then
  echo "Skipping to Build!"
else 
  echo "Building"
  mk all
fi
