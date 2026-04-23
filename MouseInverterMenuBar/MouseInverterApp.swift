/**
 * MouseInverterApp.swift
 * 应用入口
 *
 * 核心职责：
 * 初始化应用，显示菜单栏界面
 */

import SwiftUI

@main
struct MouseInverterApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        MenuBarExtra("Mouse Inverter", systemImage: appState.isRunning ? "cursorarrow.rays" : "cursorarrow") {
            ContentView()
                .environmentObject(appState)
        }
    }
}
