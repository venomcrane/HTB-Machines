<h1 align="center">
 HTB MACHINES 
</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Bash-Script-green?style=for-the-badge&logo=gnubash" />
  <img src="https://img.shields.io/badge/HACKING-HTB%20Machines-blueviolet?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Interactive-Terminal-yellow?style=for-the-badge" />
</p>

---

## About

**`htbmachines.sh`** is a Bash-based command-line utility to query Hack The Box (HTB) machine data from the community-maintained `bundle.js` database.  
It allows you to **search machines by name, IP address, skills, OS, difficulty**, or browse interactively by category.

This tool is ideal for:
-  HTB players who want fast recon of machines
-  Keeping track of progress or searching for skill-based practice
-  Filtering targets for specific certifications or challenges

> 📦 Requires internet for updates, and uses a local cached JS file once downloaded.

---

##  Features

-  Search by **machine name**, **IP address**, or **skill**
-  Show machines by **difficulty** or **OS**
-  Live updates of the latest HTB machines
-  Installs required tools automatically (`js-beautify`, `moreutils`, etc.)
-  Clean, colored terminal output
-  Interactive menu mode

## Installation and Setting up 
Before to start searching machines, you have to clone the repo into your machine, install dependencies and download the necessary files like `bundle.js`. 
You just have to do the following:
```bash
git clone https://github.com/venomcrane/HTB-Machines.git
cd HTB-Machines
./htbmachines -d
./htbmachines -u
```
Once you have already run this commands, you are ready to use this tool.

### Usage

![image](https://github.com/user-attachments/assets/6c919bb5-cd1c-4ae0-b83c-19bffbb4e3a7)

### Examples:
Searching by Machine Name:
```bash
./htbmachines -m Inception
```
![image](https://github.com/user-attachments/assets/6a54ec1b-a0b8-45a5-b834-94ece5f2608b)

Searching by IP Address:
```bash
./htbmachines.sh -i 10.10.10.84
```
![image](https://github.com/user-attachments/assets/1b3593e1-00f3-400f-868f-f8e4bda1ee15)

Show all options available:
```bash
./htbmachines -a
```
![image](https://github.com/user-attachments/assets/09001098-97a4-4e55-8fc3-c26bb0987c7f)


