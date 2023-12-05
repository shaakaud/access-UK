#! /bin/sh

LIST_FILE=cscope.files

echo -n "Deleting temporary files..."
find ./ -name "__pycache__" | xargs rm -Rf
echo "done"

echo -n "Generating files list .."
(find . -type f) | \
    egrep -i '\.([chlys](xx|pp)*|go|cc|hh|py|xml|yang|ini|proto|sh|yaml|tf|tfvars)$' | \
    sed -e '/\/CVS\//d' -e '/\/RCS\//d' -e '/waf/d' -e 's/^\.\///' -r -e '/^(lib|bin|deps|objs|build|\.git|\.hg)\//d' | \
    sort > $LIST_FILE
echo "done"

rm -f tmpcsc*

echo "Building cscope in background"
cscope -b -q -k -i $LIST_FILE -f tmpcsc &
cscope_pid=$!

echo -n "Building ctags database as well .."
ctags -L $LIST_FILE --c++-kinds=+p --fields=+iaS --extra=+q
echo "done"

echo -n "waiting for cscope to be over .. "
check_for_pid.sh $cscope_pid
rm -f cscope.out*
mv tmpcsc cscope.out
mv tmpcsc.in cscope.in.out
mv tmpcsc.po cscope.po.out
echo "done"
