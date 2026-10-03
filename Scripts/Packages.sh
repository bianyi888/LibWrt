#!/bin/bash
# 第三方插件源

# lucky (DDNS)
if ! grep -q "luci-app-lucky" feeds.conf.default; then
  echo 'src-git lucky https://github.com/gdy666/luci-app-lucky.git' >> feeds.conf.default
fi

# daede (kenzok8/openwrt-daede)
if ! grep -q "openwrt-daede" feeds.conf.default; then
  echo 'src-git daede https://github.com/kenzok8/openwrt-daede.git' >> feeds.conf.default
fi

cat feeds.conf.default
