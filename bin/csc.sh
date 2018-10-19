#! /bin/sh

if [ ! -d flexvnf ] ; then
  echo "no flexvnf dir found here"
  exit 1
fi

LIST_FILE=cscope.files

echo -n "Generating files list .."
(cd flexvnf && git ls-files) | \
    egrep -i '\.([chlys](xx|pp)*|cc|hh|tcl|py)$' | \
    sed -e '/\/CVS\//d' -e '/\/RCS\//d' -e 's/^\.\///' -r -e '/^(lib|bin|deps|objs|\.git|\.hg)\//d' | \
    sort | awk ' {print "flexvnf/" $0 } ' > $LIST_FILE
echo "done"

rm -f tmpcsc*

echo "Building cscope in background"
cscope -b -q -k -i $LIST_FILE -f tmpcsc &
cscope_pid=$!

echo -n "Building ctags database as well .."
ctags -L $LIST_FILE --c++-kinds=+p --fields=+iaS --extra=+q
egrep ';"[[:space:]]f' tags > tags_f
egrep ';"[[:space:]]m' tags > tags_m
egrep ';"[[:space:]](s|t)' tags > tags_s
egrep ';"[[:space:]](d|e)' tags > tags_d
egrep ';"[[:space:]]v' tags > tags_v
egrep 'iom|icc' tags_f > iom_tags_f
egrep 'iom|icc' tags_m > iom_tags_m
egrep 'iom|icc' tags_s > iom_tags_s
egrep 'iom|icc' tags_d > iom_tags_d
egrep 'iom|icc' tags_v > iom_tags_v
echo "done"

echo -n "waiting for cscope to be over .. "
check_for_pid.sh $cscope_pid
rm -f cscope.out*
mv tmpcsc cscope.out
mv tmpcsc.in cscope.in.out
mv tmpcsc.po cscope.po.out
echo "done"
