/**
 * AppState.swift
 * 应用状态管理
 *
 * 核心职责：
 * 管理应用 UI 状态和鼠标滚轮反转服务
 */

import Foundation
import SwiftUI

/// 应用状态管理类
class AppState: ObservableObject {
    /// 服务运行状态
    @Published var isRunning: Bool = false

    /// 加载中状态
    @Published var isLoading: Bool = false

    /// 错误信息
    @Published var errorMessage: String?

    /// 鼠标滚轮反转服务
    private let service = MouseInverterService()

    /// 防止重复重启
    private var isRestarting = false

    init() {
        // 自动启动服务
        startService()
    }

    /// 启动服务
    private func startService() {
        let success = service.start()

        DispatchQueue.main.async {
            self.isRunning = success
            if !success {
                self.errorMessage = "启动失败，请检查辅助功能权限"
            }
        }
    }

    /// 重启服务
    func restartService() {
        // 防止重复点击
        guard !isRestarting else { return }

        isRestarting = true
        isLoading = true

        service.stop()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }

            let success = self.service.start()
            self.isRunning = success

            if !success {
                self.errorMessage = "重启失败，请检查辅助功能权限"
            } else {
                self.errorMessage = nil
            }

            self.isLoading = false
            self.isRestarting = false
        }
    }

    deinit {
        service.stop()
    }
}
