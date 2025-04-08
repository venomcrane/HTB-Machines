# HTB-Machines
### Description
Bash script that search machines from Hack The Box platform (Hard Bash Scripting)

### Installation and Setting up 
Before to start searching machines, you have to clone the repo into your machine, install dependencies and download the necessary files like `bundle.js`. 
You just have to do the following:
```bash
git clone https://github.com/venomcrane/HTB-Machines.git
cd HTB-Machines
./htbmachines -d
./htbmachines -u
```
Once you hace already run this commands, you are ready to use this tool.

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


