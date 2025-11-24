# MikroTik Mijn.host Dynamic DNS Updater

A ready-to-use MikroTik RouterOS solution for automatically updating a Mijn.host DNS A-record with the router’s public IP address.  
Perfect for dynamic IP connections, VPN endpoints, and home-lab environments.

This repository includes a fully automated `.rsc` installer script.


## 🚀 Features

- Automatically detects your public IP  
- Updates one or more A-records at Mijn.host  
- Uses the Mijn.host DNS API (v2)  
- Includes IP-change detection  
- Safe validation and logging  
- Scheduler included (5-minute interval)  
- One-shot installation using the `.rsc` file  


## 📦 Installation

### 1. Edit the RSC file

Open `mijnhost-ddns.rsc` and update the User Configuration section:

\`routeros
:local apiKey "CHANGE_ME"
:local domain "DOMAIN.COM"
:local subdomains {"vpn";"home"}
:local ttl "900"
\`

### 2. Upload the file to your MikroTik

Using WinBox or WebFig:

**Files → Upload → select `mijnhost-ddns.rsc`**

### 3. Import the installer

Open a MikroTik terminal and run:

\`routeros
/import file-name=mijnhost-ddns.rsc
\`

The installer will:

- Create the DDNS script  
- Apply the required policies  
- Create the scheduler  
- Write confirmation to the system log  

No manual steps required.


## 🧪 Testing

Run the script manually:

\`routeros
/system script run mijnhost-ddns
\`

View logs:

\`routeros
/log print where message~"mijnhost"
\`

Example output:

\`
mijnhost-ddns: Public IP changed to 123.45.67.89
mijnhost-ddns: Updated A-record: vpn.domain.com → 123.45.67.89
\`


## 📁 Files in This Repository

| File | Description |
|------|-------------|
| `mijnhost-ddns.rsc` | Fully automated RouterOS installer |
| `README.md` | Documentation and installation instructions |


## 🛡 License

This project is released under the MIT License.  
You are free to use, modify, and distribute this script.


## 😎 Contributing

Pull requests and improvements are welcome — feel free to contribute.


## ⭐ Support

If you find this project useful, please consider starring the repository.
