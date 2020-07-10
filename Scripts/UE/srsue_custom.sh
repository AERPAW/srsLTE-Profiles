#!/bin/bash
read -p "Modify RF Parameters? (y/n): " rf_ans
if [[ $rf_ans = y ]] ; then
    read -p "EARFCN: " rf_earfcn
    read -p "tx_gain: " rf_tx_gain
fi
read -p "Modify USIM Parameters? (y/n): " usim_ans
if [[ $usim_ans = y ]] ; then
    read -p "Mode? (soft/pcsc): " usim_mode
    read -p "Algo? (xor/milenage): " usim_algo
    if [[ $usim_algo = milenage ]] ; then
	read -p "OP or OPC? (op/opc):" usim_op
    fi
    read -p $usim_op" value: " usim_opval
    echo $usim_opval
    read -p "Key: " usim_k
    read -p "Imsi: " usim_imsi
fi
if [[ $rf_ans = y && $usim_ans = y ]] ; then
    if [[ $usim_algo = milenage ]] ; then
	sudo srsue --rf.dl_earfcn=$earfcn --rf.tx_gain=$tx_gain --usim.mode=$usim_mode --usim.algo=usim_algo --usim.$usim_op =$usim_opval --usim.k=$usim_k --usim.imsi=$usim_imsi
    else
	sudo srsue --rf.dl_earfcn=$earfcn --rf.tx_gain=$tx_gain --usim.mode=$usim_mode --usim.algo=usim_algo --usim.opc=$usim_opval --usim.k=$usim_k --usim.imsi=$usim_imsi
    fi
else
    if [[ $rf_ans = y && $usim_ans != y ]] ; then
	sudo srsue --rf.dl_earfcn=$earfcn --rf.tx_gain=$tx_gain
    else
	if [[ $rf_ans != y && $usim_ans = y ]] ; then
	    if [[ $usim_algo = milenage ]] ; then
		if [[ $usim_op = op ]] ; then
		sudo srsue --usim.mode=$usim_mode --usim.algo=usim_algo --usim.op=$usim_opval --usim.k=$usim_k --usim.imsi=$usim_imsi
    		else
		    if [[ $usim_op = opc ]] ; then
			sudo srsue --usim.mode=$usim_mode --usim.algo=usim_algo --usim.opc=$usim_opval --usim.k=$usim_k --usim.imsi=$usim_imsi
		    fi
		    sudo srsue --usim.mode=$usim_mode --usim.algo=usim_algo --usim.opc=$usim_opval --usim.k=$usim_k --usim.imsi=$usim_imsi
		fi
	    fi
	    else
		sudo srsue
	fi
    fi
fi
