#!/bin/bash

# 配置变量
APP_NAME="mouse-inverter"
SOURCE_FILE="MouseInverter.swift"
USER_ID=$(id -u)

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 开始安装 Mouse Inverter (鼠标滚轮反转工具)...${NC}"

# 1. 检查环境
if ! command -v xcodegen &> /dev/null; then
    echo -e "${RED}❌ 未安装 xcodegen，无法编译菜单栏应用。${NC}"
    echo "   请运行: brew install xcodegen"
    exit 1
fi

# 2. 编译 Menu Bar 应用
echo ""
echo -e "${GREEN}🎛️  正在编译菜单栏应用...${NC}"
cd MouseInverterMenuBar
xcodegen generate

# 先执行构建（静默输出）
xcodebuild -project MouseInverter.xcodeproj \
    -scheme MouseInverter \
    -configuration Release \
    -destination "platform=macOS" \
    build > /dev/null 2>&1

# 然后通过 -showBuildSettings 获取准确路径
BUILD_PRODUCTS_DIR=$(xcodebuild -project MouseInverter.xcodeproj \
    -scheme MouseInverter \
    -configuration Release \
    -showBuildSettings | grep -m 1 "BUILT_PRODUCTS_DIR" | sed 's/.*= //')/MouseInverter.app

if [ -z "$BUILD_PRODUCTS_DIR" ]; then
    echo -e "${RED}❌ 构建失败，未找到产物。${NC}"
    cd ..
    exit 1
fi

# 安装 Menu Bar 应用
rm -rf "$HOME/Applications/MouseInverter.app"
cp -R "$BUILD_PRODUCTS_DIR" "$HOME/Applications/MouseInverter.app"
echo -e "✅ 菜单栏应用已安装到: $HOME/Applications/MouseInverter.app"

cd ..

# 3. 清理旧的 launchd 服务
PLIST_DEST="$HOME/Library/LaunchAgents/com.vihv.mouse-inverter.plist"
if [ -f "$PLIST_DEST" ]; then
    echo -e "🧹 清理旧的自启动服务..."
    launchctl bootout gui/$USER_ID "$PLIST_DEST" 2>/dev/null
    rm -f "$PLIST_DEST"
fi

echo ""
echo -e "${GREEN}✅ 安装完成！${NC}"
echo ""
echo -e "${YELLOW}⚠️  重要提示：${NC}"
echo "请在 '系统设置 -> 隐私与安全性 -> 辅助功能' 中添加并勾选:"
echo "   ${YELLOW}$HOME/Applications/MouseInverter.app${NC}"
echo ""
echo "📱 运行应用:"
echo "   open $HOME/Applications/MouseInverter.app"
echo ""
echo "架构说明："
echo "  • 单进程 MenuBar 应用，EventTap 服务已集成"
echo "  • 点击菜单栏图标查看状态和控制"
echo "  • 无需 launchd，应用启动即自动启用服务"

