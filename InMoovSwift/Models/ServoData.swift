import Foundation

enum ServoMixageType: Int, CaseIterable, Identifiable, Codable {
    // Head
    case None = 0
    case SameValue = 1
    case InvertValue = 2
    
    var id: Int {
        return self.rawValue
    }
}

struct ServoData: Codable, Identifiable {
    var id: UUID = UUID()
    var servo: RobotServo
    var invert = false
    var min: UInt8 = 0
    var max: UInt8 = 180
    var neutral: UInt8 = 90
    var pinId: UInt8 = 0
    var cardId: UInt8 = 0
    var enabled = false
    var value: UInt8 = 90
    var scaleValueTo180 = false
    var sleepDelay:UInt8 = 2
    var mixedServo:RobotServo?
    var mixage:ServoMixageType?
}
