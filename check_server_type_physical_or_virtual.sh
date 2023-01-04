#!/bin/bash
dmidecode | grep Product | awk 'NR == 1'
