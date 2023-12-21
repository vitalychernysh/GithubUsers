//
//  Logger.swift
//  Core
//
//  Created by Vitalii Chernysh on 21.12.2023.
//

import Foundation
import UIKit

enum LogLevel: Int {

    case verbose, success, warn, fail, app, reachable, socket

    func glyph() -> String {
        switch self {
        case .fail: return "💔"
        case .verbose: return "💙"
        case .success: return "💚"
        case .warn: return "💛"
        case .app: return "💜"
        case .reachable: return "📶"
        case .socket: return "🔌"
        }
    }

}

public enum LogType: CaseIterable {

    case common, socket

    public var filePathURL: URL? {
        let fileName: String

        switch self {
        case .common:
            fileName = "CommonLogs.txt"

        case .socket:
            fileName = "SocketLogs.txt"
        }

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            return documentsDirectory.appendingPathComponent(fileName)
        } else {
            return nil
        }
    }

}

public enum Logger {
    
    static let currentLogLevel = LogLevel.verbose

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm:ss a"

        return formatter
    }

    public static func success(_ string: @autoclosure () -> String) {
        log(.success, string(), logType: .common)
    }

    public static func error(_ string: @autoclosure () -> String) {
        log(.fail, string(), logType: .common)
    }
    
    public static func verbose(_ string: @autoclosure () -> String, file: String = #file, line: Int = #line) {
        log(.verbose, string(), logType: .common)
    }

    public static func warn(_ string: @autoclosure () -> String) {
        log(.warn, string(), logType: .common)
    }

    public static func app(_ string: @autoclosure () -> String) {
        log(.app, string(), logType: .common)
    }

    public static func reachable(_ string: @autoclosure () -> String) {
        log(.reachable, string(), logType: .common)
    }

    public static func socketMessage(_ string: @autoclosure () -> String) {
        log(.socket, string(), logType: .socket)
    }

    private static func log(
        _ level: LogLevel,
        _ string: @autoclosure () -> String,
        logType: LogType
    ) {
        if currentLogLevel.rawValue > level.rawValue {
            return
        }

        let date = dateFormatter.string(from: Date())
        let finalString = "\(level.glyph()) [\(date)] | \(string())"

        #if DEBUG
        if logType != .socket {
            debugPrint(finalString)
        }
        #endif

        write(string: finalString + "\n", logType: logType)
    }

}

extension Logger {
    
    public static func error(_ error: Error) {
        self.error("\(error)")
    }

    public static func warn(_ error: Error) {
        self.warn("\(error)")
    }

}

extension Logger {

    public static func clearLogFiles() {
        LogType.allCases.forEach {
            createLogFile(with: "", forType: $0)
        }
    }

    private static func write(string: String, logType: LogType) {
        guard let fileUrl = logType.filePathURL,
              let fileUpdater = try? FileHandle(forUpdating: fileUrl),
              let data = string.data(using: .utf8) else {
            createLogFile(with: string, forType: logType)

            return
        }

        // If the logfile grows too big, we cut it's lines amount twice, removing oldest logs.
        if let currentLogFileSize = fileUrl.fileSizeMegabytes, currentLogFileSize >= 0.5,
           let currentLinesCount = try? String(contentsOf: fileUrl).components(separatedBy: "\n").count {
            clearOldestLogs(logsAmountToKeep: currentLinesCount / 2, for: logType)
        }

        fileUpdater.seekToEndOfFile()
        fileUpdater.write(data)
        fileUpdater.closeFile()
    }

    private static func createLogFile(with string: String, forType logType: LogType) {
        guard let fileUrl = logType.filePathURL else { return }

        do {
            try string.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            Logger.error("### failed to write")
        }
    }

    private static func clearOldestLogs(logsAmountToKeep: Int, for logType: LogType) {
        guard let fileUrl = logType.filePathURL else { return }

        do {
            let data = try Data(contentsOf: fileUrl, options: .dataReadingMapped)
            let newlineCharacterData = "\n".data(using: String.Encoding.utf8)!

            var currentLineNumber = 0
            var dataPosition = data.count - 1

            while currentLineNumber <= logsAmountToKeep {
                // Find next newline character:
                guard let range = data.range(
                    of: newlineCharacterData,
                    options: [.backwards],
                    in: 0..<dataPosition
                ) else { return }

                currentLineNumber += 1
                dataPosition = range.lowerBound
            }

            let trimmedData = data.subdata(in: dataPosition..<data.count)
        
            try trimmedData.write(to: fileUrl)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}

private extension URL {

    /// Measured in megabytes for convenience.
    var fileSizeMegabytes: Float? {
        guard let value = try? resourceValues(forKeys: [.fileSizeKey]), let fileSize = value.fileSize else {
            return nil
        }

        return Float(fileSize) / 1024.0 / 1024.0
    }

}
