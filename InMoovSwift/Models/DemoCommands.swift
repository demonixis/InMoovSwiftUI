enum DemoCommands: Int {
    case headYaw = 1
    case headPitch = 2
    case jaw = 3
    case eyeX = 4
    case eyeY = 5
    case eyeLeft = 6
    case eyeRight = 7
    case allNeutral = 90
    case animEyeBlink = 100
    case animJawOpenClose = 110
    case animJawTalk = 111
    case animHeadYes = 120
    case animHeadNo = 121
    case animAudioRandom = 180
    case sysDemoMode = 200
    case sysDemoModeTiming = 201
    
    var id: Int {
        return self.rawValue
    }
}

enum RobotCommand: Int {
    case setServoValue = 1
    case updateServoConfig = 2
    case removeServoConfig = 3
    case setServoEnabled = 4
    case playAnimation = 10
    case requestSensorStatus = 20
    
    var id: Int {
        return self.rawValue
    }
}
