# macOS Mouse Inverter 🖱️🔄

> **反转普通鼠标的滚轮方向，同时保持触摸板/妙控鼠标的"自然滚动"体验。**

极简的 macOS 实用工具，使用原生 Swift 编写。解决了 macOS 系统设置中"自然滚动"选项会将鼠标和触摸板逻辑绑定在一起的痛点。

## ✨ 功能特点

- **智能区分**：自动识别普通鼠标（离散滚动）和触摸板/Magic Mouse（连续滚动）
- **独立控制**：只反转普通鼠标的滚轮方向，不影响触摸板手势
- **菜单栏应用**：简洁优雅的双语界面（中英文）
- **极致轻量**：单进程架构，基于 CoreGraphics 底层 API，无第三方依赖
- **即开即用**：无需配置，双击即可启动

## 🚀 快速开始

### 安装

```bash
# 1. 克隆项目
git clone https://github.com/DrayChou/macos-mouse.git
cd macos-mouse

# 2. 运行安装脚本
./install.sh
```

安装完成后，应用会自动启动。

### ⚠️ 权限配置（必须）

首次启动时，macOS 会阻止应用监听输入事件。请完成以下操作：

1. **系统会弹出权限请求对话框** → 点击 **"打开系统设置"**
2. 进入 **隐私与安全性** → **辅助功能**
3. 确认 **`MouseInverter`** 已勾选启用
   - *如果列表中有多个 `MouseInverter` 条目，请删除旧条目，只保留一个*
   - *如果列表中没有，点击 `+` 手动添加 `~/Applications/MouseInverter.app`*

### 使用方法

- **启动应用**：双击 `~/Applications/MouseInverter.app`
- **查看状态**：点击菜单栏图标查看运行状态
- **重启服务**：在菜单栏界面点击"重启"按钮
- **退出应用**：在菜单栏界面点击"退出"按钮

## 🛠️ 手动编译

```bash
# 编译菜单栏应用
cd MouseInverterMenuBar
xcodegen generate
xcodebuild -project MouseInverter.xcodeproj \
  -scheme MouseInverter \
  -configuration Release \
  build

# 复制到 Applications 目录
cp -r build/Release/MouseInverter.app ~/Applications/
```

## 🗑️ 卸载

```bash
# 1. 退出应用
killall MouseInverter

# 2. 删除应用
rm -rf ~/Applications/MouseInverter.app

# 3. 清理权限设置（可选）
# 系统设置 → 隐私与安全性 → 辅助功能
# 找到 MouseInverter 并点击 "-" 删除
```

## 🏗️ 技术架构

- **架构模式**：单进程 MenuBar 应用（EventTap 集成在主应用内）
- **编程语言**：Swift 5.9
- **系统要求**：macOS 13.0+
- **核心 API**：CoreGraphics EventTap
- **总代码量**：334 行

## 📸 界面预览

```
┌─────────────────────┐
│   🖱️ (绿色图标)      │
│                     │
│  运行中 | Running   │
│                     │
│ 反转鼠标滚轮 | 保持   │
│ 触控板自然           │
│                     │
│  [🔄 重启 | Restart] │
│                     │
│  [查看日志 | View]   │
│                     │
│  [退出 | Quit]      │
└─────────────────────┘
```

## 🔧 故障排除

### 应用启动但功能不生效？

**症状**：菜单栏图标正常显示，但鼠标滚轮方向未反转。

**解决方案**：
1. 确认辅助功能权限已授予（参考上方"权限配置"）
2. 如果系统设置中有多个 `MouseInverter` 条目，删除所有旧条目
3. 重新添加并勾选启用
4. 重启应用

### 权限列表中有多个 MouseInverter？

**原因**：每次重新编译会生成新的代码签名，TCC 权限系统会为每个签名创建独立记录。

**解决方案**：
1. 删除所有旧的 `MouseInverter` 条目
2. 重新添加当前应用
3. 避免频繁重新编译安装

## 📝 许可证

MIT License
