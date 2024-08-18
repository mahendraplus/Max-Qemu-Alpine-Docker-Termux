#!/bin/bash

# Function to update and upgrade the system
update_system() {
    echo "Updating and upgrading the system..."
    pkg update -y
    pkg upgrade -y
}

# Function to install necessary packages
install_packages() {
    echo "Installing necessary packages..."
    pkg install wget -y
    pkg install qemu-system-x86-64-headless qemu-utils -y
}

# Function to set up directories
setup_directories() {
    echo "Setting up directories..."
   # cd $HOME
    mkdir -p MaxQemu/alpine
    cd MaxQemu/alpine
}

# Function to download Alpine Linux ISO
download_alpine() {
    echo "Downloading Alpine Linux ISO..."
    wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.2-x86_64.iso -O alpine.iso
}

# Function to create disk image
create_disk_image() {
    echo "Creating disk image..."
    qemu-img create -f qcow2 alpine.qcow2 20G
}

# Function to perform first boot
first_boot() {
    echo "Starting first boot..."
    qemu-system-x86_64 -smp 2 -m 2048 \
    -drive file=alpine.qcow2,if=virtio,format=qcow2 \
    -netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80 \
    -device virtio-net,netdev=n1 \
    -cdrom alpine.iso -boot d \
    -nographic
}

# Function to set up Alpine Linux
setup_alpine() {
    echo "Setting up Alpine Linux..."
    echo "Run 'setup-alpine' command after booting into Alpine."
}

# Function to power off the system
poweroff_system() {
    echo "Powering off the system..."
    poweroff
}

# Function to boot from disk
boot_from_disk() {
    echo "Booting from disk..."
    qemu-system-x86_64 -smp 2 -m 2048 \
    -drive file=alpine.qcow2,if=virtio,format=qcow2 \
    -netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80 \
    -device virtio-net,netdev=n1 \
    -nographic
}

# Function to update Alpine repositories and install packages
update_alpine() {
    echo "Updating Alpine repositories and installing packages..."
    echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
    apk update
    apk upgrade
    apk add micro git curl docker docker-compose
}

# Main menu function
main_menu() {
    clear
    echo "Select an option:"
    echo "1. Update and Upgrade System"
    echo "2. Install Necessary Packages"
    echo "3. Set Up Directories"
    echo "4. Download Alpine Linux ISO"
    echo "5. Create Disk Image"
    echo "6. Perform First Boot"
    echo "7. Set Up Alpine Linux"
    echo "8. Power Off System"
    echo "9. Boot from Disk"
    echo "10. Update Alpine and Install Packages"
    echo "0. Exit"
    echo -n "Enter your choice: "
    read choice

    case $choice in
        1) update_system ;;
        2) install_packages ;;
        3) setup_directories ;;
        4) download_alpine ;;
        5) create_disk_image ;;
        6) first_boot ;;
        7) setup_alpine ;;
        8) poweroff_system ;;
        9) boot_from_disk ;;
        10) update_alpine ;;
        0) exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac

    # Return to the main menu
    main_menu
}

# Run the main menu function
main_menu
