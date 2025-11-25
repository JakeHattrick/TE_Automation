#!/bin/bash
. /home/diags/nv/mods/test/commonlib
cd $mods

 pn=$(get_config "900PN")
 Output_Upper_SN=`grep "serial_number=" $SCANFILE | sed 's/.*= *//'`
 #Example)
#To run BAT: ./run.sh --process=FLA --product=PG133 --sku=215 --factory=<factory> --pbr=PB-XXXXX
python3 sorting.py

foldname=$(find $mods/ -name "*${Output_Upper_SN}*.zip" 2>/dev/null)
if [ -n "$foldname" ];then
	cp $foldname $LOGFILE
	unzip $foldname -d $LOGFILE/
	summary=$(find $LOGFILE/ -name "summary.log" 2>/dev/null)
	./nvflash_mfg -v | tee -a $LOGFILE/log.txt
	echo ""
	echo ""
	cat $summary >> $mods/log.txt
	cat $summary >> $LOGFILE/log.txt
	
	result=$(find $mods/ -name "*${Output_Upper_SN}_P_1st*.zip" 2>/dev/null)
	if [ -n "$result" ];then
		show_pass_msg "sort test pass" && exit 0
	else
		show_fail_msg "sort test fail" && exit 1
	fi
else
	show_fail_msg "No zip file formed or tests not completed" && exit 1
fi	
	
	
