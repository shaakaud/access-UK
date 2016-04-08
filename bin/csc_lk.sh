#! /bin/sh

if [ ! -d panos ] ; then
  echo "no panos dir found here"
  exit 1
fi

LIST_FILE=cscope.files

echo -n "Generating files list .."
(cd panos && git ls-files) | \
    egrep -i '\.([chlys](xx|pp)*|cc|hh|tcl|inc)$' | \
    sed -e '/\/CVS\//d' -e '/\/RCS\//d' -e 's/^\.\///' -r -e '/^(lib|bin|deps|objs|\.git|\.hg)\//d' | \
    sort | awk ' {print "panos/" $0 } ' > $LIST_FILE
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
egrep 'gtp|pmip|lte_cpm' tags_f > gtp_tags_f
egrep 'gtp|pmip|lte_cpm' tags_m > gtp_tags_m
egrep 'gtp|pmip|lte_cpm' tags_s > gtp_tags_s
egrep 'gtp|pmip|lte_cpm' tags_d > gtp_tags_d
egrep 'gtp|pmip|lte_cpm' tags_v > gtp_tags_v
echo "done"

echo -n "waiting for cscope to be over .. "
check_for_pid.sh $cscope_pid
rm -f cscope.out*
mv tmpcsc cscope.out
mv tmpcsc.in cscope.in.out
mv tmpcsc.po cscope.po.out
echo "done"
