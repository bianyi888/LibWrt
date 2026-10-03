#!/bin/bash
# SPDX-License-Identifier: MIT
# 编译前处理（文件修改、补丁等）

FEEDS_PATH="./feeds"
PACKAGE_PATH="./package"

# argon 配色：最流行的青绿 #31a1a1 + bing 壁纸（VIKINGYFY 系固件同款）
if [ -d "$PACKAGE_PATH/luci-theme-argon" ]; then
	echo " "
	if sed -i "s/primary '.*'/primary '#31a1a1'/g; s/'0.2'/'0.5'/g; s/'none'/'bing'/g" \
		"$PACKAGE_PATH/luci-theme-argon/luci-app-argon-config/root/etc/config/argon"; then
		echo "theme-argon has been fixed!"
	else
		echo "theme-argon fix failed; continuing!"
	fi
fi
