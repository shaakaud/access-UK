#!/bin/bash
###############################################################################
#
# Author        atsourti
#
# Description   handle testbed boring tasks
#
# Version       0.18.31
#
###############################################################################

# - TODO new features
#
#       * check if  $OUT_DIR/exports/internal/support/hmac-sha1.txt exists to check new build location
#       * start using $OUT_DIR
#
#


function usage {

    echo "Usage: $0 testbed <testbed> [branch <branch>] [subtopology <subtopology>] [action <action>]"
    echo "      Branch:                 MG00 MG80S MG80F MG90S MG100S MG100F       -   default: MG00"
    echo "      Subtopology:            ismMgB ismMgV3 plasmaMgV3 vfp (lteDefault) -   defailt: ismMgV3"
    echo "                              vmgPerfSmall10 vmgPerfSmall40 (mgVm)"
    echo "      Supported options:"
    echo "                          -f                      -   do not ask confirmation on actions"
    echo "                          -h                      -   usage"
    echo "                          --mgplus                -   use mgplus.top"
    echo "                          --mgmerge               -   use custome MG00 MERGE GASH"
    echo "                          --no_ownership_check    -   do not check if testbed is paused by you - USE AT YOUR OWN RISK!"
    echo "      Supported actions:"
    echo "                          setup                   -   set the default images, restore_gash and reboot"
    echo "                          restore                 -   restore_gash and reboot"
    echo "                          hard-reboot             -   hard reboot"
    echo "                          soft-reboot             -   soft reboot"
    echo "                          move-images             -   move the local compiled images to the testbed (overwriting old ones) and reboot"
    echo "                          clean                   -   clean the testbed of the stored images in tmp, the gash screen and setup"
    echo "      Supported GASH actions:"
    echo "                          gash                    -   open gash terminal via screen"
    echo "      Supported GASH actions via testbed_actions.txt:"
    echo "                          config          -   config testbed via gash"
    echo "                          attach          -   open IPv4 pdp via gash"
    echo "                          traffic         -   send IPv4 traffic via gash"
    echo "                          attach6         -   open IPv6 pdp via gash"
    echo "                          traffic6        -   send IPv6 traffic via gash"
    echo "                          detach          -   close pdp via gash"
    echo "                          mirror          -   setup mirroring via gash"
    echo "                          reconnect       -   reconnect gash with dut after restart"
    echo "                          ...             -   add your own actions here!"
    echo "      Show actions in testbed_actions.txt:"
    echo "                          list-actions    -   show testbed_actions.txt actions"
    echo ""
    echo "          Note: BEFORE executing gash commands is REQUIRED to open a screen terminal in testbed via screen -S GASH"
    echo "                As the screen terminal does not close automatically please use screen -r GASH to connect to existing screen window"
    echo "                If above command fails use command screen -S GASH to open new screen window"
    echo ""
    echo "          Note: use file testbed_actions.txt to load more actions"
    echo "                e.g. traffic=\"sendAndVerifyTrafficSimMme 123456789012345 5 15.1.1.1 -count 1"
    echo "                     \"" 


}


function ask_execution {
    while true; do
        read -p "Do you want to execute on testbed $testbed ? [y/n] " yn
        case $yn in
            [Yy]* ) 
                break;;
            [Nn]* ) 
                echo "$0: have a nice day!!!"
                exit -1;;
            * ) 
                echo "Please answer yes or no."
        esac
    done
}


function create_link_testbed_images_script {

    echo '
    dest_image_dir=~/images/

    echo "Link images..."

    ln_op="ln -sf"

    src=`pwd`

    $ln_op $src/both.tim $dest_image_dir
    $ln_op $src/codeversion.mk $dest_image_dir
    $ln_op $src/cpm.tim $dest_image_dir

    $ln_op $src/i386-boot.tim $dest_image_dir
    $ln_op $src/i386-both.tim $dest_image_dir
    $ln_op $src/i386-cpm.tim $dest_image_dir
    $ln_op $src/i386-iom.tim $dest_image_dir
    $ln_op $src/i386-isa-aa.tim $dest_image_dir


    $ln_op $src/iom.tim $dest_image_dir
    $ln_op $src/isa-aa.tim $dest_image_dir
    $ln_op $src/isa-tms.tim $dest_image_dir

    $ln_op $src/setup_cli.cfg -t $dest_image_dir

    $ln_op $src/support.tim $dest_image_dir

    $ln_op $src/teardown_cli.cfg $dest_image_dir

    $ln_op $src/timos_features.mk $dest_image_dir 

    # cloud
    # $ln_op $src/sros-vm.ova $dest_image_dir
    # $ln_op $src/sros-vm.qcow2 $dest_image_dir
    # $ln_op $src/sros-vm.vmdk $dest_image_dir

    # decore is not linked
    # $ln_op $src/decore $dest_image_dir' > ../images/link_testbed_images.sh
    chmod +x ../images/link_testbed_images.sh

}


function copy_images {
    echo "Changing local images..."

    if [ ! -d "../images" ]; then
        echo "Creating dir images ..."
        mkdir "../images"
    fi

    rm -f ../images/*

    src=`pwd`
    ln_op="ln -sf"

    timos_path_to_binaries_i386="exports/internal/images/i386"
    timos_path_to_binaries_chile="exports/internal/images/chile"
    timos_path_to_binaries_hops="exports/internal/images/hops"

    if [ $branch == "MG80S" ] || [ $branch == "MG90S" ]; then
        timos_path_to_binaries_i386="bin/7xxx-i386"
        timos_path_to_binaries_chile="bin/7xxx-chile"
        timos_path_to_binaries_hops="bin/7xxx-hops"
    fi

    if [ "$testbed_is_vm" = true ] ; then

        if [ -d "$src/$timos_path_to_binaries_i386" ]; then
            $ln_op $src/$timos_path_to_binaries_i386/iom.tim ../images/i386-iom.tim
            $ln_op $src/$timos_path_to_binaries_i386/cpm.tim ../images/i386-cpm.tim
            $ln_op $src/$timos_path_to_binaries_i386/both.tim ../images/i386-both.tim
            $ln_op $src/$timos_path_to_binaries_i386/boot.tim ../images/i386-boot.tim
            $ln_op $src/$timos_path_to_binaries_i386/isa-aa.tim ../images/i386-isa-aa.tim
            $ln_op $src/$timos_path_to_binaries_i386/vxrom.bin ../images/i386-vxrom.bin
        else
            echo "Cannot find dir $timos_path_to_binaries_i386 ... Skipping..."
        fi

    else

        if [ -d "$src/$timos_path_to_binaries_chile" ]; then
            $ln_op $src/$timos_path_to_binaries_chile/isa-aa.tim ../images/isa-aa.tim
            $ln_op $src/$timos_path_to_binaries_chile/isa-tms.tim ../images/isa-tms.tim
        else
            echo "Cannot find dir $timos_path_to_binaries_chile ... Skipping..."
        fi

        if [ -d "$src/$timos_path_to_binaries_hops" ]; then
            $ln_op $src/$timos_path_to_binaries_hops/support.tim ../images/support.tim
            $ln_op $src/$timos_path_to_binaries_hops/iom.tim ../images/iom.tim
            $ln_op $src/$timos_path_to_binaries_hops/cpm.tim ../images/cpm.tim
            $ln_op $src/$timos_path_to_binaries_hops/both.tim ../images/both.tim
            $ln_op $src/$timos_path_to_binaries_hops/boot.tim ../images/boot.tim
            $ln_op $src/$timos_path_to_binaries_hops/vxrom.bin ../images/vxrom.bin
            $ln_op $src/$timos_path_to_binaries_hops/isa-aa.tim ../images/isa-aa.tim
        else
            echo "Cannot find dir $timos_path_to_binaries_hops ... Skipping..."
        fi

    fi

    if [ -d "$src/gen" ]; then
        $ln_op $src/gen/timos_features.mk ../images/timos_features.mk
        $ln_op $src/gen/make/codeversion.mk ../images/codeversion.mk
    else
        echo "$0: error - Cannot find dir gen ... Exitting..."
        exit -1
    fi

    if [ -d "$src/test" ]; then
        $ln_op $src/test/setup_cli.cfg ../images/setup_cli.cfg
        $ln_op $src/test/teardown_cli.cfg ../images/teardown_cli.cfg
    else
        echo "$0: error - Cannot find dir test ... Exitting..."
        exit -1
    fi

    # decore is not copied
    # if [ -f "$src/bin/linux/decore" ]; then
    #     $ln_op $src/bin/linux/decore ../images/decore
    # fi

}


function link_images {

    dest_image_dir=/home/$testbed/images/

    echo "Link images... from $1 to $dest_image_dir"

    ln_op="ln -sf"

    src=$1

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/both.tim $dest_image_dir
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/codeversion.mk $dest_image_dir
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/cpm.tim $dest_image_dir

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/i386-boot.tim $dest_image_dir
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/i386-both.tim $dest_image_dir
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/i386-cpm.tim $dest_image_dir
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/i386-iom.tim $dest_image_dir
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/i386-isa-aa.tim $dest_image_dir


    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/iom.tim $dest_image_dir
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/isa-aa.tim $dest_image_dir
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/isa-tms.tim $dest_image_dir

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/setup_cli.cfg -t $dest_image_dir

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/support.tim $dest_image_dir

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/teardown_cli.cfg $dest_image_dir

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/timos_features.mk $dest_image_dir 

    # cloud
    #sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/sros-vm.ova $dest_image_dir 
    #sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/sros-vm.qcow2 $dest_image_dir 
    #sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/sros-vm.vmdk $dest_image_dir 

    # decore is not copied
    # sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no $ln_op $src/decore $dest_image_dir

}


function hard_reboot_testbed {
    # restart hypervisors
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no /home/$testbed/ws/gash/bin/powercycle.tcl $testbed
    echo "Reboot result is: $?"
}


function soft_reboot_testbed {
    # restart dut only and not hypervisors
    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no /home/$testbed/ws/gash/bin/powercycleVMs.py $testbed
    echo "Reboot result is: $?"
}


function setup_testbed {

    latest_branch="none"

    if [ $branch == "MG00" ]; then
        latest_branch="latest 0.0"
    fi
    if [ $branch == "MG80S" ]; then
        latest_branch="latest_s 8.0"
    fi
    if [ $branch == "MG80F" ]; then
        latest_branch="latest_f 8.0"
    fi
    if [ $branch == "MG90S" ]; then
        latest_branch="latest_s 9.0"
    fi
    if [ $branch == "MG100S" ]; then
        latest_branch="latest_s 10.0"
    fi
    if [ $branch == "MG100F" ]; then
        latest_branch="latest_f 10.0"
    fi
    if [ "$latest_branch" == "none" ]; then
        echo "$0: error - branch is not known" 1>&2; exit 1;
    fi

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no mklinks $latest_branch 7750mg

    if [ "$mgplus" == "mgplus" ]; then
        sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no restore_gash -subTopology $subtopology -network_top mgplus.top
    else
        if [ "$mgmerge" == "mgmerge" ]; then
            sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no restore_gash -subTopology $subtopology -useCustom mg00_sr15_merge_mibs -cvs_tag TiMOS-MG_0_0_MERGE_SR15 -reparseMibs true
        else
            sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no restore_gash -subTopology $subtopology
        fi
    fi
    hard_reboot_testbed
}


function restore_testbed {

    if [ "$mgplus" == "mgplus" ]; then
        sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no restore_gash -subTopology $subtopology -network_top mgplus.top
    else
        if [ "$mgmerge" == "mgmerge" ]; then
            sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no restore_gash -subTopology $subtopology -useCustom mg00_sr15_merge_mibs -cvs_tag TiMOS-MG_0_0_MERGE_SR15 -reparseMibs true
        else
            sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no restore_gash -subTopology $subtopology
        fi
    fi

    if [ "$testbed_is_vm" = true ] ; then
        soft_reboot_testbed
    else
        hard_reboot_testbed
    fi
}


function move_images {

    copy_images

    create_link_testbed_images_script

    clean_testbed

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no mkdir -p $tmp_path

    echo "Using tmp path $tmp_path"    

    #scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no ../images/* $testbed@$testbeduri:$tmp_path

    rsync -P --rsh="sshpass -ptigris ssh -l $testbed -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no " --copy-links ../images/* $testbeduri:$tmp_path

    link_images $tmp_path

    if [ "$testbed_is_cloud" = true ] ; then
        # on cloud we need to execute restore_gash in order to use the new images and hard-reboot to boot them
        #sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no restore_gash -subTopology $subtopology
        #hard_reboot_testbed

        # on cloud we need to delete previous qcow2 images and execute updateVmImage.sh to create the qcow files
        sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no rm /home/$testbed/images/sros-vm.*
        sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no /usr/global/tools/lte/bin/updateVmImage.sh
    else
        if [ "$testbed_is_vm" = true ] ; then
            soft_reboot_testbed
        else
            hard_reboot_testbed
        fi
    fi

}


function clean_testbed {

    # make sure that we are talking for tmp dir
    images_in_testbed=`echo $tmp_path | grep "^/tmp"`

    if [[ ! -z "$images_in_testbed" ]]; then

        echo "Cleaning dir $images_in_testbed"

        sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no "rm -f $images_in_testbed/*"
        sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no "rmdir $images_in_testbed"

    fi
}


function gash_shell {

    echo "BEFORE executing this command remember to open a screen in testbed via command \"screen -S GASH\""
    echo "    BEFORE executing this command is REQUIRED to open a screen terminal in testbed "
    echo "        As the screen terminal does not close automatically please use screen -r GASH to connect to existing screen window"
    echo "        If above command fails use command screen -S GASH to open new screen window"

    while [ $force -eq 0 ]; do
        read -p "Have you opened the screen window in testbed? [y/n] " yn
        case $yn in
            [Yy]* ) 
                break;;
            [Nn]* ) 
                echo "Please open the screen window in testbed...";;
            * ) 
                echo "Please answer yes or no."
        esac
    done

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no "screen -S GASH -X stuff \"gash 
\""

}


function gash_extra_actions {

    if [[ ! -z "$1" ]]; then

        echo "executing extra actions"
        echo $1

        sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no "screen -S GASH -X stuff \"$1 
\""
    fi

}


function clean_screen {

    sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no "screen -S GASH -X quit" 

}


function check_testbed_link {

    if [ $testbed == "none" ]; then
        echo "$0: error - testbed is not known" 1>&2; exit 1;
    fi

    if [ ${testbed:0:3} == "ath" ]; then
        testbeduri="$testbed.athmg.eecloud.dynamic.nsn-net.net"
    elif [ ${testbed:0:2} == "es" ]; then
        testbeduri="$testbed.dev.cic.nsn-rdnet.net"
    elif [ ${testbed:0:2} == "mv" ]; then
        if [ ${testbed:0:5} == "mvmg4" ]; then
            testbeduri="$testbed.mvcalab.us.alcatel-lucent.com"
        else
            testbeduri="$testbed.us.alcatel-lucent.com"
        fi
    elif [ ${testbed:0:3} == "npv" ]; then
        testbeduri="$testbed.ih.lucent.com"
        if [[ "$testbed" == *"red"* ]]; then
            # red testbeds have different uri !!!
            testbeduri="$testbed.illab.us.alcatel-lucent.com"
        fi
    elif [ ${testbed:0:2} == "ba" ]; then
        testbeduri="$testbed.lab.sk.alcatel-lucent.com"
    fi

    # check if testbed is vm
    if [[ "$testbed" == *"ltevm"* ]]; then
        testbed_is_vm=true
        echo "testbed is vm"
    elif [[ "$testbed" == *"rtb2vm"* ]]; then
        testbed_is_vm=true
        echo "testbed is vm"
    # check if testbed is cloud
    elif [[ "$testbed" == *"mgperf"* ]]; then
        testbed_is_vm=true
        testbed_is_cloud=true
        echo "testbed is cloud"
    elif [[ "$testbed" == *"mg4perf"* ]]; then
        testbed_is_vm=true
        testbed_is_cloud=true
        echo "testbed is cloud"
    elif [[ "$testbed" == *"mgptb"* ]]; then
        testbed_is_vm=true
        testbed_is_cloud=true
        echo "testbed is cloud"
    else
    # if testbed is not vm or cloud it is hw
        echo "testbed is hw"
    fi

    if [ "$testbeduri" == "none" ]; then
        echo "$0: error - testbeduri is not known" 1>&2; exit 1;
    fi

}


function check_testbed_ownership {

    testbed_username_email=`sshpass -ptigris ssh "$testbed@$testbeduri" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -o GSSAPIAuthentication=no "cat /var/www/html/jobs/pause"`

    if [[ -n "$USER" && "$testbed_username_email" == *"$USER"* ]]; then
        return
    fi

    user_email=`curl -s "http://sw.mv.usa.alcatel.com/cgi-bin/siteconfig.cgi?key=email;user=$USER" 2> /dev/null | grep '@'`

    if [[ -n "$user_email" && "$testbed_username_email" == *"$user_email"* ]]; then
        return
    fi

    echo "$0: You do not have paused the testbed!!! Have a nice day!!!"
    exit -1
}

#================================================================================================
#=======================================MAIN=====================================================
#================================================================================================


testbed="none"
testbeduri="none"
testbed_is_vm=false
testbed_is_cloud=false
branch="MG00"
subtopology="ismMgV3"
action="none"
mgplus="none"
mgmerge="none"
tmp_path="/tmp/tmp.tTl2cHqEV2_testbed_helper"
force=0
no_ownership_check=0

while [ $# -gt 0 ]
do
    case "$1" in
    (testbed) testbed=$2; shift;;
    (branch) branch=$2; shift;;
    (subtopology) subtopology=$2; shift;;
    (action) action=$2; shift;;
    (--no_ownership_check) no_ownership_check=1;;
    (--mgplus) mgplus="mgplus";;
    (--mgmerge) mgmerge="mgmerge";;
    (-h) usage; exit 0;;
    (-f) force=1;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done

echo `date`

echo "running on testbed $testbed for branch $branch and subtopology $subtopology and we should execute $action"
check_testbed_link

if [ $no_ownership_check -eq 0 ]; then
    echo "checking testbed ownership..."
    check_testbed_ownership;
fi

if [ "$action" == "setup" ]; then
    if [ $force -eq 0 ]; then ask_execution; fi
    echo "executing setup on testbed $testbed for BRANCH $branch and SUBTOPOLOGY $subtopology"
    setup_testbed
    exit 0
fi

if [ "$action" == "restore" ]; then
    if [ $force -eq 0 ]; then ask_execution; fi
    echo "executing restore on testbed $testbed for BRANCH $branch and SUBTOPOLOGY $subtopology"
    restore_testbed
    exit 0
fi

if [ "$action" == "hard-reboot" ]; then
    if [ $force -eq 0 ]; then ask_execution; fi
    echo "executing hard reboot on testbed $testbed"
    hard_reboot_testbed
    exit 0
fi

if [ "$action" == "soft-reboot" ]; then
    if [ $force -eq 0 ]; then ask_execution; fi
    echo "executing soft reboot on testbed $testbed"
    soft_reboot_testbed
    exit 0
fi

if [ "$action" == "move-images" ]; then
    if [ $force -eq 0 ]; then ask_execution; fi
    echo "executing move-images on testbed $testbed"
    move_images
    exit 0
fi

if [ "$action" == "clean" ]; then
    if [ $force -eq 0 ]; then ask_execution; fi
    echo "executing clean on testbed $testbed"
    clean_screen
    clean_testbed
    setup_testbed
    exit 0
fi

if [ "$action" == "gash" ]; then
    echo "executing gash on testbed $testbed"
    gash_shell
    exit 0
fi

if [ "$action" == "list-actions" ]; then
    echo "executing list-actions"

    org_vars=`compgen -v`

    if [ -f $(dirname "${0}")/testbed_actions.txt ]; then
        echo "reading extra actions from file testbed_actions.txt"
        . $(dirname "${0}")/testbed_actions.txt

        my_vars=`compgen -v`

        diff --changed-group-format='%>' --unchanged-group-format='' <(echo "$org_vars") <(echo "$my_vars") | grep -v org_vars

    fi

    exit 0
fi

if [ -f $(dirname "${0}")/testbed_actions.txt ]; then
    echo "reading extra actions from file testbed_actions.txt"
    . $(dirname "${0}")/testbed_actions.txt

    gash_extra_actions "${!action}"

    exit 0
fi



echo "$0: error - action "$action" is unknown or not given..." 1>&2; exit 1;



