//
//  MotionManager.swift
//  curling
//
//  Created by User on 2023/04/10.
//

import UIKit
import CoreMotion

class MotionSensor: NSObject, ObservableObject {
    
    @Published var isStarted = true
    
    @Published var xAccel = 0.0
    @Published var yAccel = 0.0
    @Published var zAccel = 0.0
    
    @Published var speed = 0.0
    var vx = 0.0;
    var vy = 0.0;
    
    let manager = CMMotionManager()
    
    override init() {
        super.init()

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.1
            manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error:Error?) in
                self.updateMotionData(deviceMotion: motion!)
            })
        }
    }
    
    private func updateMotionData(deviceMotion:CMDeviceMotion) {
        xAccel = deviceMotion.userAcceleration.x
        yAccel = deviceMotion.userAcceleration.y
        zAccel = deviceMotion.userAcceleration.z
        
        vx = vx + xAccel
        vy = vy + yAccel
        
        speed = sqrt(vx*vx + vy*vy)
    }
    
}
