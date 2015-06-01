~/access-UK/new_clone/backup_cvs.sh iccrx_5Mar_dir <== To take backup -- Issue this command from panos dir
~/access-UK/new_clone/save_gittish.sh <== Before issuing, delete all files in /home/udayakut/ws/patch/. Remove ~/ws/"workspace"/gitstatus, patch_*. Issue this command from /home/udayakut/ws/"workspace". Copy gitstatus,patch_* to ~/ws/patch
~/access-UK/new_clone/new_clone.sh -c -n -g /home/udayakut/ws/patch/ -h TiMOS-MG_0_0 "6:31PM March 02" <== Create a new dir under /home/udayakut/ws/ and then issue this command inside the new directory

~/access-UK/new_clone/continue_patching.sh -c -n -g /home/udayakut/ws/patch/ -t "7" -h TiMOS-MG_0_0 - If some patch fails, issue this command with -t option which takes the patch number from which it needs to start supercommitpatch. If new_clone.sh fails in patch number 8, then fix the merge conflicts by looking *.rej files and then do **git commit** with appropriate comments and then run this script with -t "7" (ie continue patching from 7 - applies patch 7,6,5..). For futher failures, fix merge conflicts, git commit and then run this script again to continue.

git supercommitpatch /home/udayakut/ws/patch/patch_7 "$patch_comments" -> Use this manual command to patch a "patch_*" if any of the patch fails. Run this and do "git commit"
