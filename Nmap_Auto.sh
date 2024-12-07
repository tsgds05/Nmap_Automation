#!/bin/bash

# Check if user is running as root
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

# Gain IP address through user input
read -p "[=] What is the IP address you want to scan: " IP

# Ask user if they want to find a host or scan ports
read -p "[=] Do you want to find host or scan ports? (Type H for Host & P for Port): " scan1

if [[ "$scan1" == "h" || "$scan1" == "H" ]]; then
    echo "[+] What type of scan do you want to use?"
    echo "[1] -sL (List Scan)"
    echo "[2] -sn (No Port scan)"
    echo "[3] -Pn (No ping)"
    echo "[4] --traceroute"

    read -p "[=] Input number here: " scan22

    # Map input number to scan type
    case $scan22 in
        1) host_type="-sL" ;;
        2) host_type="-sn" ;;
        3) host_type="-Pn" ;;
        4) host_type="--traceroute" ;;
        *) echo "[!] Invalid option"; exit 1 ;;
    esac

    echo "[+] Running: nmap $host_type $IP"
    nmap $host_type $IP
    exit 0  # Exit after completing host scan
fi

if [[ "$scan1" == "p" || "$scan1" == "P" ]]; then
    echo "[+] What type of scan do you want to use?"
    echo "[1] -sS (TCP SYN Scan)"
    echo "[2] -sT (TCP Connect Scan)"
    echo "[3] -sU (UDP Scan)"
    echo "[4] -sY (SCTP INIT Scan)"
    echo "[5] -sA (TCP ACK Scan)"
    echo "[6] -sW (TCP Window Scan)"
    echo "[7] -sM (TCP Maimon Scan)"
    echo "[8] -sZ (SCTP Cookie Echo Scan)"
    echo "[9] -sO (IP Protocol Scan)"
    echo "[10] -sV (Version Detection)"

    read -p "[=] Input number here: " scan2

    # Map input number to scan type
    case $scan2 in
        1) scan_type="-sS" ;;
        2) scan_type="-sT" ;;
        3) scan_type="-sU" ;;
        4) scan_type="-sY" ;;
        5) scan_type="-sA" ;;
        6) scan_type="-sW" ;;
        7) scan_type="-sM" ;;
        8) scan_type="-sZ" ;;
        9) scan_type="-sO" ;;
        10) scan_type="-sV" ;;
        *) echo "[!] Invalid option"; exit 1 ;;
    esac

    # Ask if the user wants to add scripts
    read -p "[=] Do you want to add scripts? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        echo "[+] Available script categories:"
        echo "[1] auth"
        echo "[2] broadcast"
        echo "[3] brute"
        echo "[4] default"
        echo "[5] discovery"
        echo "[6] dos (denial of service)"
        echo "[7] exploit"
        echo "[8] external"
        echo "[9] fuzzer"
        echo "[10] intrusive"
        echo "[11] malware"
        echo "[12] safe"
        echo "[13] version"
        echo "[14] vuln"
        echo "[15] other"

        read -p "[=] Choose a script category (1-15): " script_option

        # Map script category
        case $script_option in
            1) script_type="auth" ;;
            2) script_type="broadcast" ;;
            3) script_type="brute" ;;
            4) script_type="default" ;;
            5) script_type="discovery" ;;
            6) script_type="dos" ;;
            7) script_type="exploit" ;;
            8) script_type="external" ;;
            9) script_type="fuzzer" ;;
            10) script_type="intrusive" ;;
            11) script_type="malware" ;;
            12) script_type="safe" ;;
            13) script_type="version" ;;
            14) script_type="vuln" ;;
            15) read -p "Enter custom script type: " script_type ;;
            *) echo "[!] Invalid script category"; exit 1 ;;
        esac

        echo "[+] Running: nmap $scan_type --script=$script_type $IP"
        nmap $scan_type --script=$script_type $IP
    else
        echo "[+] Running: nmap $scan_type $IP"
        nmap $scan_type $IP
    fi
else
    echo "[!] Invalid choice. Exiting."
    exit 1
fi

# Some scans that I ignore
# -sI // -b // --scanflags // -sN, -sF, -sX
# -PS // -PA // -PU // -PY // -PE, -PP, -PM // -PO // --disable-arp-ping // --discovery-ignore-rst