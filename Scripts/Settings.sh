#!/bin/bash
# 系统设置

# LAN IP 改为 192.168.5.1
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate
