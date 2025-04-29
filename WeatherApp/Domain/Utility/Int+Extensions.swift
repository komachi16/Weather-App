import Foundation

extension Int {
    func convertToJstDateString() -> String {
        // UNIXタイムスタンプをDate型に変換
        let date = Date(timeIntervalSince1970: TimeInterval(self))

        // 日本時間のタイムゾーンを設定
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let jstDateString = formatter.string(from: date)
        return jstDateString
    }
}
