#!/bin/bash
for disk in sda sdb sdc sdd sde sdf sdg sdh; do (echo n; echo p; echo 1; echo; echo; echo t; echo 8e; echo w) | fdisk /dev/$disk 2&>/dev/null; done
