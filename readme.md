
# MaxQEMU - Alpine Linux Setup in Termux

This guide, created by [Mahendra Mali (Max)](https://github.com/mahendraplus), will walk you through setting up Alpine Linux on your Termux environment using QEMU. This setup is ideal for those who wish to run a lightweight virtual machine directly on their Android device through Termux.

## Quick Start

1. **Download and Run the Script**

   Use either `curl` or `wget` to download and run the setup script directly:

   - **With `curl`**:
     ```bash
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/mahendraplus/MaxQemu/Max/maxqemu.sh)"
     ```

   - **With `wget`**:
     ```bash
     sh -c "$(wget -qO- https://raw.githubusercontent.com/mahendraplus/MaxQemu/Max/maxqemu.sh)"
     ```

2. **Follow On-Screen Instructions**

   The script will guide you through the setup process.

## Table of Contents

- Prerequisites
- Step 1: System Preparation
- Step 2: Install Necessary Packages
- Step 3: Set Up the Directory Structure
- Step 4: Download Alpine Linux ISO
- Step 5: Create a Disk Image for Alpine Linux
- Step 6: First Boot - Start Alpine Installation
- Step 7: Set Up Alpine Linux
- Step 8: Boot from the Installed Disk
- Step 9: Post-Installation Configuration
- Credits

---

## Prerequisites

Make sure you have Termux installed on your Android device. This guide assumes basic familiarity with Termux commands.

## Step 1: System Preparation

First, update and upgrade the packages in Termux:

```
pkg update -y
pkg upgrade -y
```

## Step 2: Install Necessary Packages

Next, install the required packages, including QEMU for emulating the x86_64 architecture:

```
pkg install wget -y
pkg install qemu-system-x86-64-headless qemu-utils -y
```

## Step 3: Set Up the Directory Structure

Create and navigate to the working directory where everything will be stored:

```
cd $HOME
mkdir MaxQemu
cd MaxQemu
```

## Step 4: Download Alpine Linux ISO

Create a subdirectory for Alpine and download the ISO image:

```
mkdir alpine
cd alpine
wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.2-x86_64.iso
mv alpine-virt-*-x86_64.iso alpine.iso
```

## Step 5: Create a Disk Image for Alpine Linux

You need a virtual hard drive to install Alpine:

```
qemu-img create -f qcow2 alpine.qcow2 20G
```

## Step 6: First Boot - Start Alpine Installation

Boot the ISO to start the Alpine Linux installation:

```
qemu-system-x86_64 -smp 2 -m 2048 \
-drive file=alpine.qcow2,if=virtio,format=qcow2 \
-netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80 \
-device virtio-net,netdev=n1 \
-cdrom alpine.iso -boot d \
-nographic
```

## Step 7: Set Up Alpine Linux

Inside the QEMU terminal, follow the setup prompts:

```
setup-alpine
```

- Select disk: **vda**
- Choose **sys** for a full disk install.

Once completed, power off the VM:

```
poweroff
```

## Step 8: Boot from the Installed Disk

Now you can boot directly from the disk image without the ISO:

```
qemu-system-x86_64 -smp 2 -m 2048 \
-drive file=alpine.qcow2,if=virtio,format=qcow2 \
-netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80 \
-device virtio-net,netdev=n1 \
-nographic
```

## Step 9: Post-Installation Configuration

After booting into Alpine, update repositories and install additional packages:

### Update Alpine Repositories

```
echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
```

### Update and Install Packages

```
apk update
apk upgrade
apk add micro git curl docker docker-compose
```

---

## Credits

This guide was created by [Mahendra Mali (Max)](https://github.com/mahendraplus).  
GitHub Repository: [github.com/mahendraplus](https://github.com/mahendraplus)

---

You now have a fully functional Alpine Linux VM running inside Termux using QEMU. Enjoy your lightweight environment!
