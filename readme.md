
# MaxQemu: Run Alpine Linux on Termux with QEMU

This repository provides a simple script to set up a minimal Alpine Linux virtual machine (VM) inside your Termux environment using QEMU. Perfect for testing, development, or exploring Alpine Linux on your Android device!

## Features

* **Lightweight:** Utilizes the minimal footprint of Alpine Linux.
* **Easy Setup:** Straightforward script for quick installation.
* **Port Forwarding:** Access your VM via SSH (port 2222) and HTTP (port 8080).
* **Docker Ready:** Includes installation of Docker and Docker Compose.

## Prerequisites

* **Termux:** Installed and up-to-date on your Android device.
* **Stable Internet Connection:** Required for downloading the ISO and packages.

## Installation Steps

1. **Update and Install Dependencies:**

   ```bash
   pkg update -y
   pkg upgrade -y
   pkg install wget -y
   pkg install qemu-system-x86_64-headless qemu-utils -y
   ```

2. **Create Project Directory:**

   ```bash
   cd $HOME
   mkdir MaxQemu
   cd MaxQemu
   ```

3. **Download Alpine Linux ISO:**

   ```bash
   mkdir alpine
   cd alpine
   wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.2-x86_64.iso
   mv alpine-virt-*-x86_64.iso alpine.iso
   ```

4. **Create Disk Image:**

   ```bash
   qemu-img create -f qcow2 alpine.qcow2 20G
   ```

5. **First Boot and Alpine Setup:**

   ```bash
   qemu-system-x86_64 -smp 2 -m 2048 \
   -drive file=alpine.qcow2,if=virtio,format=qcow2 \
   -netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80 \
   -device virtio-net,netdev=n1 \
   -cdrom alpine.iso -boot d \
   -nographic
   ```

   * During the setup, use the `setup-alpine` command.
   * Choose `vda` (sys) as the installation disk.

6. **Power Off the VM:**

   ```bash
   poweroff
   ```

7. **Boot from the Disk:**

   ```bash
   qemu-system-x86_64 -smp 2 -m 2048 \
   -drive file=alpine.qcow2,if=virtio,format=qcow2 \
   -netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80 \
   -device virtio-net,netdev=n1 \
   -nographic
   ```

8. **Post-Installation Configuration (inside the VM):**

   ```bash
   echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
   apk update
   apk upgrade
   apk add micro git curl docker docker-compose
   ```

## Accessing Your VM

* **SSH:** `ssh root@localhost -p 2222`
* **Web:** `http://localhost:8080` (if you're running a web service)

## Keywords for Search Optimization

Termux, QEMU, Alpine Linux, Virtual Machine, Android, Docker, Docker Compose, ARM, aarch64, Installation Guide, Lightweight VM, Development Environment

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.
