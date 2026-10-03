#!/bin/bash
# SPDX-License-Identifier: MIT
# 编译前处理（文件修改、补丁等）

FEEDS_PATH="./feeds"
PACKAGE_PATH="./package"

# argon 恢复原版蓝色 + bing 壁纸
if [ -d "$PACKAGE_PATH/luci-theme-argon" ]; then
	echo " "
	if sed -i "s/primary '.*'/primary '#5e72e4'/g; s/'0.5'/'0.2'/g; s/'none'/'bing'/g; s/'normal'/'600'/g" \
		"$PACKAGE_PATH/luci-theme-argon/luci-app-argon-config/root/etc/config/argon"; then
		echo "theme-argon has been fixed!"
	else
		echo "theme-argon fix failed; continuing!"
	fi
fi
