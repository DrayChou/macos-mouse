#!/bin/bash

# 配置变量
APP_NAME="mouse-inverter"
SOURCE_FILE="MouseInverter.swift"
INSTALL_DIR="$HOME/.local/bin"
PLIST_NAME="com.vihv.mouse-inverter.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME"
USER_ID=$(id -u)

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 开始安装 Mouse Inverter (鼠标滚轮反转工具)...${NC}"

# 1. 检查环境
if ! command -v swiftc &> /dev/null; then
    echo -e "${RED}❌ 未找到 swiftc 编译器。${NC}"
    echo "请运行 'xcode-select --install' 安装 Xcode Command Line Tools 后重试。"
    exit 1
fi

if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}❌ 未找到源代码文件: $SOURCE_FILE${NC}"
    exit 1
fi

# 2. 编译代码
echo -e "🔨 正在编译 ${YELLOW}$SOURCE_FILE${NC}..."
swiftc "$SOURCE_FILE" -o "$APP_NAME"
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 编译失败。请检查源代码。${NC}"
    exit 1
fi

# 3. 安装二进制文件
echo -e "📂 安装程序到 ${YELLOW}$INSTALL_DIR${NC}..."
mkdir -p "$INSTALL_DIR"
cp "$APP_NAME" "$INSTALL_DIR/$APP_NAME"

# 4. 生成并安装 plist 配置文件
echo -e "📄 配置自启动服务..."
cat <<EOF > "$PLIST_NAME"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.vihv.$APP_NAME</string>
    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_DIR/$APP_NAME</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/$APP_NAME.out.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/$APP_NAME.err.log</string>
</dict>
</plist>
EOF

mv "$PLIST_NAME" "$PLIST_DEST"

# 5. 重启服务
echo -e "🔄 正在加载服务..."
# 尝试先卸载（忽略错误），确保重新加载
launchctl bootout gui/$USER_ID "$PLIST_DEST" 2>/dev/null
launchctl bootstrap gui/$USER_ID "$PLIST_DEST"

# 6. 清理
rm "$APP_NAME"

echo -e "${GREEN}✅ 安装完成！${NC}"
echo ""
echo -e "${YELLOW}⚠️  重要提示 (如果是新电脑)：${NC}"
echo "1. 系统可能会弹出 '辅助功能访问' 请求，请点击 '打开系统设置' 并授权。"
echo "2. 如果没有弹窗或不生效，请手动前往:"
echo "   系统设置 -> 隐私与安全性 -> 辅助功能"
echo "   确保列表中勾选了: ${YELLOW}$INSTALL_DIR/$APP_NAME${NC}"
echo "   (如果在列表中找不到，请点击 '+' 号手动添加该路径)"
