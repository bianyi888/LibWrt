#!/bin/bash
# SPDX-License-Identifier: MIT
# 第三方插件包

# 安装和更新软件包
UPDATE_PACKAGE() {
	local PKG_NAME=$1
	local PKG_REPO=$2
	local PKG_BRANCH=$3
	local PKG_SPECIAL=$4
	local PKG_LIST=("$PKG_NAME" $5)
	local REPO_NAME=${PKG_REPO#*/}
	local REPO_PATH="./package/$REPO_NAME"

	echo " "

	# 删除本地可能存在的不同名称的软件包
	for NAME in "${PKG_LIST[@]}"; do
		echo "Search directory: $NAME"
		local FOUND_DIRS=$(find ./feeds/luci/ ./feeds/packages/ -maxdepth 3 -type d -iname "*$NAME*" 2>/dev/null)

		if [ -n "$FOUND_DIRS" ]; then
			while read -r DIR; do
				rm -rf "$DIR"
				echo "Delete directory: $DIR"
			done <<< "$FOUND_DIRS"
		else
			echo "Not found directory: $NAME"
		fi
	done

	# 克隆 GitHub 仓库
	git clone --depth=1 --single-branch --branch $PKG_BRANCH "https://github.com/$PKG_REPO.git" $REPO_PATH

	# 处理克隆的仓库
	if [[ "$PKG_SPECIAL" == "pkg" ]]; then
		find $REPO_PATH/*/ -maxdepth 3 -type d -iname "*$PKG_NAME*" -prune -exec cp -rf {} ./package \;
		rm -rf $REPO_PATH
	fi
}

# UPDATE_PACKAGE "包名" "项目地址" "项目分支" "pkg，可选" "自定义名称列表，可选"

# lucky (DDNS)
UPDATE_PACKAGE "lucky" "gdy666/luci-app-lucky" "main"

# daed (kenzok8)
UPDATE_PACKAGE "daed" "kenzok8/openwrt-daede" "main" "" "dae luci-app-daede"

# daed 上游 Makefile 引入了 bpf.mk 却没在 DEPENDS 里加 $(BPF_DEPENDS)，
# 导致 NEED_BPF_TOOLCHAIN（无 prompt 的 Kconfig 内部符号）永远不会被 select，
# tools/llvm-bpf 被跳过编译，bpf-headers 以 /invalid/clang 编译失败（unknown compiler）。
# 注意：NEED_BPF_TOOLCHAIN 不能写进 defconfig（Kconfig 会静默丢弃无 prompt 符号的值），只能走 DEPENDS 的 select。
DAED_MAKEFILE="./package/openwrt-daede/daed/Makefile"
if [ -f "$DAED_MAKEFILE" ]; then
	sed -i 's|+DAED_USE_VMLINUX_BTF:vmlinux-btf$|+DAED_USE_VMLINUX_BTF:vmlinux-btf \\\n\t$(BPF_DEPENDS)|' "$DAED_MAKEFILE"
	if grep -qF '$(BPF_DEPENDS)' "$DAED_MAKEFILE"; then
		echo "daed Makefile patched: BPF_DEPENDS added to DEPENDS"
	else
		echo "ERROR: failed to patch daed Makefile for BPF_DEPENDS" && exit 1
	fi
else
	echo "ERROR: $DAED_MAKEFILE not found" && exit 1
fi

# argon 主题
UPDATE_PACKAGE "argon" "sbwml/luci-theme-argon" "openwrt-25.12"
