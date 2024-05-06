import Foundation

enum RobotServo: Int, CaseIterable, Identifiable, Codable {
    // Head
    case eyeX = 1
    case eyeY = 2
    case jaw = 3
    // Neck
    case headYaw = 10
    case headPitch = 11
    case headRoll = 12
    case headRollAlt = 13
    // Left Arm
    case leftShoulderYaw = 20
    case leftShoulderPitch = 21
    case leftShoulderRoll = 22
    case leftElbowPitch = 23
    case leftWristRoll = 24
    case leftThumbFinger = 30
    case leftIndexFinger = 31
    case leftMiddleFinger = 32
    case leftRingFinger = 33
    case leftLittleFinger = 34
    // Right Arm
    case rightShoulderYaw = 40
    case rightShoulderPitch = 41
    case rightShoulderRoll = 42
    case rightElbowPitch = 43
    case rightWristRoll = 44
    case rightThumbFinger = 50
    case rightIndexFinger = 51
    case rightMiddleFinger = 52
    case rightRingFinger = 53
    case rightLittleFinger = 54
    // Pelvis
    case pelvisYaw = 60
    case pelvisPitch = 61
    case pelvisRoll = 62
    
    // User
    case unknown = 255
    
    var id: Int {
        return self.rawValue
    }
}

extension RobotServo {
    var displayName: String {
        switch self {
        case .eyeX:
            return "Eye Left/Right"
        case .eyeY:
            return "Eye Up/Down"
        case .jaw:
            return "Jaw"
        case .headYaw:
            return "Head Yaw"
        case .headPitch:
            return "Head Pitch"
        case .headRoll:
            return "Head Roll"
        case .headRollAlt:
            return "Head Roll (2nd servo)"
        case .leftShoulderYaw:
            return "Left Shoulder Yaw"
        case .leftShoulderPitch:
            return "Left Shoulder Pitch"
        case .leftShoulderRoll:
            return "Left Shoulder Roll"
        case .leftElbowPitch:
            return "Left Elbow Pitch"
        case .leftWristRoll:
            return "Left Wrist Roll"
        case .leftThumbFinger:
            return "Left Thumb Finger"
        case .leftIndexFinger:
            return "Left Index Finger"
        case .leftMiddleFinger:
            return "Left Middle Finger"
        case .leftRingFinger:
            return "Left Ring Finger"
        case .leftLittleFinger:
            return "Left Little Finger"
        case .rightShoulderPitch:
            return "Right Shoulder Pitch"
        case .rightShoulderRoll:
            return "Right Shoulder Roll"
        case .rightElbowPitch:
            return "Right Elbow Pitch"
        case .rightWristRoll:
            return "Right Wrist Roll"
        case .rightThumbFinger:
            return "Right Thumb Finger"
        case .rightIndexFinger:
            return "Right Index Finger"
        case .rightMiddleFinger:
            return "Right Middle Finger"
        case .rightRingFinger:
            return "Right Ring Finger"
        case .rightLittleFinger:
            return "Right Little Finger"
        case .pelvisYaw:
            return "Pelvis Yaw"
        case .pelvisPitch:
            return "Pelvis Pitch"
        case .pelvisRoll:
            return "Pelvis Roll"
            
        default:
            return "\(self)"
        }
    }
}
