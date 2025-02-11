#!/bin/bash

# Function to print disk list
function print_disk_list {
    echo "Disk Name | Size | Mount Point"
    echo "---------------------------------"
    lsblk -d -o NAME,SIZE,MOUNTPOINT | awk 'NR>1 {printf "%-10s | %-5s | %s\n", $1, $2, $3}'
}

# Function to extend VG
function extend_vg {
    local vg_name=$1
    local pv_name=$2

    echo "You are extending VG $vg_name with PV $pv_name."
    echo "This may cause data corruption, so please make sure you have a backup before proceeding."

    if sudo pvcreate "$pv_name" && sudo vgextend "$vg_name" "$pv_name"; then
        echo "VG $vg_name successfully extended with PV $pv_name."
    else
        echo "Error: Failed to extend VG $vg_name with PV $pv_name."
    fi
}

# Function to extend LV
function extend_lv {
    local lv_path=$1
    local vg_name=$2
    local lv_name=$3

    echo "You are extending LV $lv_name in VG $vg_name."
    echo "This may cause data corruption, so please make sure you have a backup before proceeding."

    if sudo lvextend -r -l +100%FREE "$lv_path"; then
        echo "LV $lv_name successfully extended."
    else
        echo "Error: Failed to extend LV $lv_name."
    fi
}

# Get list of VGs and LVs
vg_list=$(sudo vgs --noheadings -o vg_name | awk '{print $1}')
lv_list=$(sudo lvs --noheadings -o vg_name,lv_name | awk '{print $1 ":" $2}')

# Prompt user for action
while true; do
    echo "Select an action:"
    echo "1. Get disk list"
    echo "2. Extend VG"
    echo "3. Extend LV"
    echo "4. Exit"
    read -p "Enter the action number: " action

    case $action in
        1)
            # Print disk list
            print_disk_list
            ;;
        2)
            # Extend VG
            read -p "Enter the name of the VG you want to extend: " vg_name
            read -p "Enter the name of the new PV you want to use (e.g., /dev/sdb): " pv_name
            if echo "$vg_list" | grep -qw "$vg_name"; then
                extend_vg "$vg_name" "$pv_name"
            else
                echo "Error: VG $vg_name does not exist."
            fi
            ;;
        3)
            # Extend LV
            read -p "Enter the VG name of the LV you want to extend: " vg_name
            read -p "Enter the LV name you want to extend: " lv_name

            lv_path="/dev/$vg_name/$lv_name"

            if echo "$lv_list" | grep -qw "$vg_name:$lv_name"; then
                extend_lv "$lv_path" "$vg_name" "$lv_name"
            else
                echo "Error: LV $lv_name does not exist in VG $vg_name."
            fi
            ;;
        4)
            # Exit
            exit 0
            ;;
        *)
            # Invalid input
            echo "Error: Invalid input."
            ;;
    esac

    # Ask user if they want to continue
    read -p "Do you want to perform another action? (y/n): " continue
    if [[ "$continue" != "y" ]]; then
        break
    fi
done