/**
 * MouseInverterService.swift
 * 鼠标滚轮反转服务
 *
 * 核心职责：
 * 创建 EventTap 拦截并反转鼠标滚轮事件
 */

import Foundation
import CoreGraphics
import AppKit

/// 鼠标滚轮反转服务
class MouseInverterService {
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let serviceRunLoop = CFRunLoopGetMain()  // 固定使用主 RunLoop

    /// 启动服务
    func start() -> Bool {
        // 创建 Event Tap
        let eventMask = (1 << CGEventType.scrollWheel.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                // 只处理滚动事件
                if type == .scrollWheel {
                    // 检查是否为连续滚动（触控板）
                    let isContinuous = event.getIntegerValueField(.scrollWheelEventIsContinuous) != 0

                    // 只反转鼠标滚轮（非连续滚动）
                    if !isContinuous {
                        let deltaY = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
                        event.setIntegerValueField(.scrollWheelEventDeltaAxis1, value: -deltaY)
                    }
                }

                return Unmanaged.passUnretained(event)
            },
            userInfo: nil
        ) else {
            print("❌ Failed to create event tap")
            return false
        }

        // 创建 RunLoop 源
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(serviceRunLoop, source, .commonModes)

        // 启用 Tap
        CGEvent.tapEnable(tap: tap, enable: true)

        self.eventTap = tap
        self.runLoopSource = source

        print("✅ Mouse inverter service started")
        return true
    }

    /// 停止服务
    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            CFMachPortInvalidate(tap)
        }

        if let source = runLoopSource {
            CFRunLoopRemoveSource(serviceRunLoop, source, .commonModes)
        }

        eventTap = nil
        runLoopSource = nil

        print("🛑 Mouse inverter service stopped")
    }

    deinit {
        stop()
    }
}
