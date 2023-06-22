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
    @Published var yaw = 0.0
    @Published var yaw_origin = 0.0
    
    @Published var speed = 0.0
    var vx = 0.0;
    var vy = 0.0;
    
    var res = 0.0
    
    let manager = CMMotionManager()
    
    override init() {
        super.init()

        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error:Error?) in
                self.updateMotionData(deviceMotion: motion!)
            })
        }
    }
    
    private func updateMotionData(deviceMotion:CMDeviceMotion) {
        xAccel = deviceMotion.userAcceleration.x
        yAccel = deviceMotion.userAcceleration.y
        zAccel = deviceMotion.userAcceleration.z
        
        yaw_origin = 360 - (deviceMotion.attitude.yaw * 180 / Double.pi + 180)
        yaw = yaw_origin - res
        if (yaw < 0) {
            yaw = 360 + yaw
        }
        if (yaw > 360) {
            yaw = yaw - 360
        }
        
//        xAccel = round(xAccel*100)/100
//        yAccel = round(yAccel*100)/100
//        
        if (fabs(xAccel) < 0.02) {
            xAccel = 0.0
        }
        if (fabs(yAccel) < 0.02) {
            yAccel = 0.0
        }
        
        vx = vx + 0.1*xAccel
        vy = vy + 0.1*yAccel
        
        speed = sqrt(vx*vx + vy*vy)
    }
    
}
