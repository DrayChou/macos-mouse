/**
 * ContentView.swift
 * 主界面 | Main View
 *
 * 核心职责：
 * 显示服务状态、控制按钮和日志，提供用户交互界面
 * Displays service status, controls, and logs
 */

import SwiftUI

/// 主界面
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLogs = false

    var body: some View {
        VStack(spacing: 12) {
            // 状态图标
            Image(systemName: appState.isRunning ? "cursorarrow.rays" : "cursorarrow")
                .font(.system(size: 40))
                .foregroundStyle(appState.isRunning ? .green : .secondary)
                .animation(.easeInOut(duration: 0.3), value: appState.isRunning)

            // 状态文字（双语）
            VStack(spacing: 4) {
                Text(appState.isRunning ? "运行中" : "启动中...")
                    .font(.headline)
                    + Text(" | ")
                        .foregroundColor(.secondary)
                    + Text(appState.isRunning ? "Running" : "Starting...")
                        .font(.headline)
            }

            // 功能说明
            Text("反转鼠标滚轮 | 保持触控板自然\nInvert scroll | Keep trackpad natural")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            // 重启按钮
            Button(action: {
                appState.restartService()
            }) {
                HStack(spacing: 6) {
                    if appState.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                        Text("重启")
                        Text("Restart")
                            .font(.caption)
                    }
                }
                .frame(width: 140)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .disabled(appState.isLoading)

            // 错误提示
            if let error = appState.errorMessage {
                Text(error)
                    .font(.caption2)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }

            Divider()
                .padding(.vertical, 4)

            // 调试日志切换
            Button(action: {
                showLogs.toggle()
            }) {
                Text(showLogs ? "隐藏日志 | Hide Logs" : "查看日志 | View Logs")
                    .font(.caption2)
            }
            .buttonStyle(.link)

            if showLogs {
                ServiceLogsView()
                    .transition(.opacity)
            }

            // 退出按钮
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Text("退出")
                    .font(.caption2) +
                Text(" | ") +
                Text("Quit")
                    .font(.caption2)
            }
            .buttonStyle(.link)
            .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(width: 240)
    }
}

/// 服务日志视图
struct ServiceLogsView: View {
    @State private var logs = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("服务日志 | Service Logs")
                .font(.caption2)
                .foregroundColor(.secondary)

            ScrollViewReader { _ in
                ScrollView(.vertical, showsIndicators: true) {
                    Text(logs.isEmpty ? "暂无日志 | No logs" : logs)
                        .font(.system(.caption2, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(logs.isEmpty ? .secondary : .primary)
                        .onAppear {
                            loadLogs()
                        }
                }
                .frame(height: 100)
            }
        }
        .padding(8)
        .background(Color(NSColor.textBackgroundColor))
        .cornerRadius(6)
    }

    /// 加载日志
    func loadLogs() {
        let outPath = "/tmp/mouse-inverter.out.log"
        let errPath = "/tmp/mouse-inverter.err.log"

        let outLog = (try? String(contentsOfFile: outPath, encoding: .utf8)) ?? ""
        let errLog = (try? String(contentsOfFile: errPath, encoding: .utf8)) ?? ""

        if !outLog.isEmpty || !errLog.isEmpty {
            logs = "=== stdout ===\n\(outLog)\n\n=== stderr ===\n\(errLog)"
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
