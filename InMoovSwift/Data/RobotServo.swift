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
    case leftThumb = 30
    case leftIndex = 31
    case leftMiddle = 32
    case leftRing = 33
    case leftLittle = 34
    // Right Arm
    case rightShoulderYaw = 40
    case rightShoulderPitch = 41
    case rightShoulderRoll = 42
    case rightElbowPitch = 43
    case rightWristRoll = 44
    case rightThumb = 50
    case rightIndex = 51
    case rightMiddle = 52
    case rightRing = 53
    case rightLittle = 54
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
        // Ajoutez les autres cas ici...
        default:
            return "\(self)"
        }
    }
}
