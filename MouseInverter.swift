import Cocoa
import CoreGraphics

// 核心逻辑：事件回调函数
func eventTapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    // 只处理滚动事件
    if type == .scrollWheel {
        // 检查是否为连续滚动
        // 触摸板和 Magic Mouse 通常是连续滚动 (Continuous)
        // 普通鼠标滚轮通常是非连续的 (Discrete)
        let isContinuous = event.getIntegerValueField(.scrollWheelEventIsContinuous) != 0
        
        if !isContinuous {
            // 获取当前的滚动值
            let deltaY = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
            
            // 反转方向 (乘以 -1)
            event.setIntegerValueField(.scrollWheelEventDeltaAxis1, value: -deltaY)
        }
    }
    
    // 返回修改后（或未修改）的事件
    return Unmanaged.passUnretained(event)
}

func main() {
    print("🖱️  正在启动鼠标滚轮反转工具...")
    print("👉 请确保系统偏好设置中，触摸板滚动方向设置为‘自然’。")
    
    // 创建 Event Tap
    let eventMask = (1 << CGEventType.scrollWheel.rawValue)
    guard let eventTap = CGEvent.tapCreate(
        tap: .cgSessionEventTap,
        place: .headInsertEventTap,
        options: .defaultTap,
        eventsOfInterest: CGEventMask(eventMask),
        callback: eventTapCallback,
        userInfo: nil
    ) else {
        print("❌ 无法创建 Event Tap。请检查权限。")
        exit(1)
    }

    // 创建 RunLoop 源
    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    
    // 启用 Tap
    CGEvent.tapEnable(tap: eventTap, enable: true)
    
    print("✅ 服务已启动。请在‘系统设置 -> 隐私与安全性 -> 辅助功能’中授予终端或编译后程序权限。")
    print("按 Ctrl+C 退出。")
    
    // 运行主循环
    CFRunLoopRun()
}

main()
