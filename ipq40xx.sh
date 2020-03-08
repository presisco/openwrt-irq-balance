#!/bin/sh

set_mask() {
	echo "set mask $2 for irq: $1"
	echo "$2" > "/proc/irq/$1/smp_affinity"
}

set_mask_pattern() {
	local name_pattern="$1"
	local mask="$2"
	
	for irq in `grep "$name_pattern" /proc/interrupts | cut -d: -f1 | sed 's, *,,'`
	do
		set_mask $irq $mask
	done
}

set_mask_index() {
	local name_pattern="$1"
	local index="$2"
	local mask="$3"
	
	set_mask `grep -m$index "$name_pattern" /proc/interrupts | cut -d: -f1 | tail -n1 | tr -d ' '` $mask
}

set_mask_range() {
	local name_pattern="$1"
	local start="$2"
	local end="$3"
	local mask="$4"
	
	local count=`expr $end - $start + 1`
	for irq in `grep "$name_pattern" /proc/interrupts | cut -d: -f1 | head -n$end | tail -n$count | sed 's, *,,'`
	do
		set_mask $irq $mask
	done
}

#dma
set_mask_index bam_dma 1 2
set_mask_index bam_dma 2 4
set_mask_index bam_dma 3 8

#ethernet
set_mask_pattern eth 2
# set_mask_range eth_tx 1 8 2
# set_mask_range eth_tx 9 16 4
# set_mask_range eth_rx 1 2 2
# set_mask_range eth_rx 3 4 4

#soc wifi
set_mask_pattern ath10k_ahb 8

#pcie
set_mask_pattern qcom-pcie-msi 2

#usb
set_mask_pattern usb 8

