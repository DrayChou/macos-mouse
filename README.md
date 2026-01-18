# macOS Mouse Inverter 🖱️🔄

> **反转普通鼠标的滚轮方向，同时保持触摸板/妙控鼠标的“自然滚动”体验。**

这是一个极简的 macOS 实用工具，使用原生 Swift 编写（不到 50 行核心代码）。它解决了 macOS 系统设置中“自然滚动”选项会将鼠标和触摸板逻辑绑定在一起的痛点。

## ✨ 功能特点

*   **智能区分**：自动识别普通鼠标（离散滚动）和触摸板/Magic Mouse（连续滚动）。
*   **独立控制**：只反转普通鼠标的滚轮方向，不影响触摸板手势。
*   **极致轻量**：基于 macOS `CoreGraphics` 底层 API，无任何第三方依赖。
*   **开机自启**：包含自动配置脚本，支持后台静默运行。

## 🚀 快速开始

### 安装

1. 克隆本项目：
   ```bash
   git clone https://github.com/yourusername/macos-mouse-inverter.git
   cd macos-mouse-inverter
   ```

2. 运行安装脚本：
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

### ⚠️ 关键步骤：权限授予

安装完成后，macOS 可能会阻止程序监听输入事件。请务必完成以下操作：

1. 如果系统弹出“辅助功能访问”请求，请点击 **“打开系统设置”**。
2. 前往 **系统设置** -> **隐私与安全性** -> **辅助功能**。
3. 在列表中找到 **`mouse-inverter`** 并确保其 **开关已开启**。
   * *如果列表中没有，请点击底部的 `+` 号，手动添加 `~/.local/bin/mouse-inverter` 文件。*

## 🛠️ 手动编译与运行

如果你不想使用安装脚本，也可以手动操作：

```bash
# 1. 编译
swiftc MouseInverter.swift -o inverter

# 2. 运行
./inverter
```

## 🗑️ 卸载

如果不再需要，运行以下命令彻底清除：

```bash
# 1. 停止并卸载服务
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.vihv.mouse-inverter.plist
rm ~/Library/LaunchAgents/com.vihv.mouse-inverter.plist

# 2. 删除程序
rm ~/.local/bin/mouse-inverter
```

## 📝 许可证

MIT License.
