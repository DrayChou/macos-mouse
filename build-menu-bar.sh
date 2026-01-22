#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/MouseInverterMenuBar"

echo "🚀 构建 Mouse Inverter Menu Bar 应用..."

# 检查 XcodeGen
if ! command -v xcodegen &> /dev/null; then
    echo "❌ 未安装 xcodegen，请运行: brew install xcodegen"
    exit 1
fi

# 生成 Xcode 项目
echo "📦 生成 Xcode 项目..."
cd "$PROJECT_DIR"
xcodegen generate

# 构建项目
echo "🔨 编译项目..."
xcodebuild -project MouseInverterMenuBar.xcodeproj \
    -scheme MouseInverterMenuBar \
    -configuration Release \
    -destination "platform=macOS" \
    build

echo ""
echo "✅ 构建完成！"
echo ""
echo "📱 运行应用:"
echo "   open $PROJECT_DIR/build/Release/MouseInverterMenuBar.app"
echo ""
echo "⚠️  首次运行需要在系统设置中授权辅助功能权限"
