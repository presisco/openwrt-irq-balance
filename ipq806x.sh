#!/bin/sh /etc/rc.common

START=99

set_irq_affinity() {
	local name="$1"
	local val="$2"

	case "$name" in
	wifi0)
		local irq_wifi0=`grep -E -m1 'ath10k|qcom-pcie-msi' /proc/interrupts | cut -d: -f1 | tail -n1 | tr -d ' '`
		[ -n "$irq_wifi0" ] || echo "$name irq not found."
		echo "$val" > "/proc/irq/$irq_wifi0/smp_affinity"
		;;
	wifi1)
		local irq_wifi1=`grep -E -m2 'ath10k|qcom-pcie-msi' /proc/interrupts | cut -d: -f1 | tail -n1 | tr -d ' '`
		[ -n "$irq_wifi1" ] || echo "$name irq not found."
		echo "$val" > "/proc/irq/$irq_wifi1/smp_affinity"
		;;
	wifi2)
		local irq_wifi1=`grep -E -m3 'ath10k|qcom-pcie-msi' /proc/interrupts | cut -d: -f1 | tail -n1 | tr -d ' '`
		[ -n "$irq_wifi1" ] || echo "$name irq not found."
		echo "$val" > "/proc/irq/$irq_wifi1/smp_affinity"
		;;
	*)
		local irq=`grep -m 1 "$name" /proc/interrupts | cut -d: -f1 | sed 's, *,,'`
		[ -n "$irq" ] || echo "$name irq not found."
		echo "$val" > "/proc/irq/$irq/smp_affinity"
		;;
	esac
}

start() {
	. /lib/functions.sh

	local board=$(board_name)
	
	echo "detected board: $board"

	case "$board" in
	rt-ac58u |\
	'asus,rt-acrh17' |\
	fritz4040)
		echo 2 > /proc/irq/22/smp_affinity
		echo 4 > /proc/irq/23/smp_affinity
		echo 8 > /proc/irq/26/smp_affinity
		set_irq_affinity edma_eth_tx0 2
		set_irq_affinity edma_eth_tx1 2
		set_irq_affinity edma_eth_tx2 2
		set_irq_affinity edma_eth_tx3 2
		set_irq_affinity edma_eth_tx4 4
		set_irq_affinity edma_eth_tx5 4
		set_irq_affinity edma_eth_tx6 4
		set_irq_affinity edma_eth_tx7 4
		set_irq_affinity edma_eth_tx8 2
		set_irq_affinity edma_eth_tx9 2
		set_irq_affinity edma_eth_tx10 2
		set_irq_affinity edma_eth_tx11 2
		set_irq_affinity edma_eth_tx12 4
		set_irq_affinity edma_eth_tx13 4
		set_irq_affinity edma_eth_tx14 4
		set_irq_affinity edma_eth_tx15 4
		set_irq_affinity edma_eth_rx0 2
		set_irq_affinity edma_eth_rx2 4
		set_irq_affinity edma_eth_rx4 2
		set_irq_affinity edma_eth_rx6 4
		set_irq_affinity qcom-pcie-msi f
		set_irq_affinity aerdrv f
		set_irq_affinity ath10k_ahb 8
		set_irq_affinity ath10k_pci f
		set_irq_affinity xhci-hcd:usb1 8
		set_irq_affinity xhci-hcd:usb3 8
		;;
	ap148 |\
	c2600 |\
	db149 |\
	d7800 |\
	ea8500 |\
	nbg6817 |\
	r7500 |\
	r7500v2 |\
	r7800 |\
	vr2600v)
		set_irq_affinity eth0 2
		set_irq_affinity eth1 2
		set_irq_affinity wifi0 2
		;;
	*)
		echo "Unsupported hardware. CPU affinity is not adjusted."
		;;
	esac
}
