#!/bin/bash
# SPDX-License-Identifier: MIT
# 编译前处理（文件修改、补丁等）

FEEDS_PATH="./feeds"
PACKAGE_PATH="./package"

# argon 配色：sky blue 主色 + 轻微透明 + bing 壁纸
if [ -d "$PACKAGE_PATH/luci-theme-argon" ]; then
	echo " "
	if sed -i "s/primary '.*'/primary '#0ea5e9'/g; s/'0.2'/'0.3'/g; s/'none'/'bing'/g; s/'600'/'600'/g" \
		"$PACKAGE_PATH/luci-theme-argon/luci-app-argon-config/root/etc/config/argon"; then
		echo "theme-argon has been fixed!"
	else
		echo "theme-argon fix failed; continuing!"
	fi
fi
