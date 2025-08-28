# Headless Proxmox Laptop Setup

This setup configures a laptop running Proxmox to operate fully **headless**.  
It ensures:

- ACPI/lid/suspend/hibernate events are ignored  
- NIC power settings persist (network stays online)  
- Optional dummy HDMI support for GPU/display  
- Manual power button remains functional for emergency reboot  

---

## Prerequisites

- Root access  
- Proxmox or Debian-based system  
- (Optional) Dummy HDMI adapter for headless GPU support  

---

## Usage

### 1️⃣ Direct download & run via `curl` (recommended)

```bash
curl -sSL https://raw.githubusercontent.com/mananxg/headless-server/main/headless-setup.sh | bash
```
