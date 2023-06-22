//
//  ContentView.swift
//  curling
//
//  Created by 武藤 颯汰 on 2023/02/15.
//

import SwiftUI
import MapKit
import Foundation


struct ContentView: View {
    
    @ObservedObject var manager = LocationManager()
    @ObservedObject var sensor = MotionSensor()
    @State var res = 0.0
    @State var forYawReset = true
    @State var msg = "回転を内蔵センサにする"
    @State var rotate = true
    
    var body: some View {
        let heading = $manager.heading.wrappedValue
        let speedFromLocation = $manager.speed.wrappedValue
        let formattedSpeed = round(speedFromLocation*10)/10
        let formattedHeading = round(heading*10)/10
        let formattedYaw = round(sensor.yaw*10)/10
        
        
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack{
                Text("gpsから取得: \(String(formattedHeading))")
                    .foregroundColor(Color.white)
                    .padding(.bottom, 10.0)
                    .font(.largeTitle)
                //                Text("速度: \(speed)")
                //                    .foregroundColor(Color.white)
                //                    .padding(.bottom, 40.0)
//                Text("速度: \(sensor.speed)")
//                    .foregroundColor(Color.white)
//                    .padding(.bottom, 10.0)
//                    .font(.largeTitle)
//                Text("x加速度: \(sensor.xAccel), y加速度: \(sensor.yAccel)")
//                                    .foregroundColor(Color.white)
//                                    .padding(.bottom, 20.0)
//                                    .font(.largeTitle)
                Text("内蔵センサから取得: \(String(formattedYaw))")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                
                
                Group {
                    HStack{
                        ZStack {
                            
                            //  for ipad mini 6th gen
                            //                        Path { path in
                            //                            path.move(to: CGPoint(x: 276, y: 208))
                            //                            path.addArc(center: .init(x: 276, y: 208),
                            //                                        radius: 155,
                            //                                        startAngle: Angle(degrees: 90.0),
                            //                                        endAngle: Angle(degrees: (formattedSpeed/10) * 360 + 90),
                            //                                        clockwise: false)
                            //                        }
                            //                        .fill(Color.orange)
                            
                            // for ipad mini 5th gen
                            Path { path in
                                path.move(to: CGPoint(x: 155, y: 179))
                                path.addArc(center: .init(x: 155, y: 179),
                                            radius: 152,
                                            startAngle: Angle(degrees: 90.0),
                                            endAngle: Angle(degrees: (formattedSpeed/10) * 360 + 90),
                                            clockwise: false)
                            }
                            .fill(Color.orange)
                            
                            HStack {
                                Text(String(formattedSpeed))
                                    .font(.system(size: 64))
                                    .foregroundColor(Color.white)
                                Text("m/s")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .padding(.top, 32.0)
                            }
                            
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.red)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 18))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 36))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 54))
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 72))
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 90))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 108))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 126))
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 144))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 162))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 180))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 198))
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 216))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 234))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 252))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 270))
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 288))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 306))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 324))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 342))
                            }
                            
                        }
                        .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
                        
                        Spacer()
                            .frame(width: 400)
                        
                        ZStack {
                            // for ipad mini 6th gen
                            //                        Path { path in
                            //                            path.move(to: CGPoint(x: 276, y: 208))
                            //                            path.addArc(center: .init(x: 276, y: 208),
                            //                                        radius: 155,
                            //                                        startAngle: Angle(degrees: 90.0),
                            //                                        endAngle: Angle(degrees: (formattedSpeed/10) * 360 + 90),
                            //                                        clockwise: false)
                            //                        }
                            //                        .fill(Color.orange)
                            
                            
                            // for ipad mini 5th gen
                            Path { path in
                                path.move(to: CGPoint(x: 155, y: 179))
                                path.addArc(center: .init(x: 155, y: 179),
                                            radius: 152,
                                            startAngle: Angle(degrees: 90.0),
                                            endAngle: Angle(degrees: (formattedSpeed/10) * 360 + 90),
                                            clockwise: false)
                            }
                            .fill(Color.orange)
                            
                            
                            HStack {
                                Text(String(formattedSpeed))
                                    .font(.system(size: 64))
                                    .foregroundColor(Color.white)
                                Text("m/s")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .padding(.top, 32.0)
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.red)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 18))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 36))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 54))
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 72))
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 90))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 108))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 126))
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 144))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 162))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 180))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 198))
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 216))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 234))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 252))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 270))
                            }
                            
                            Group {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:12, height: 56)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 288))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 306))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 324))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(width:5, height: 25)
                                    .padding(.top, 300.0)
                                    .rotationEffect(Angle(degrees: 342))
                            }
                        }
                        .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) - 135 + res))
                        
                    }
                    
                    
                    ZStack {
                        // for ipad mini 6th gen
                        //                        Path { path in
                        //                            path.move(to: CGPoint(x: 276, y: 208))
                        //                            path.addArc(center: .init(x: 276, y: 208),
                        //                                        radius: 155,
                        //                                        startAngle: Angle(degrees: 90.0),
                        //                                        endAngle: Angle(degrees: (formattedSpeed/10) * 360 + 90),
                        //                                        clockwise: false)
                        //                        }
                        //                        .fill(Color.orange)
                        
                        
                        // for ipad mini 5th gen
                        Path { path in
                            path.move(to: CGPoint(x: 514, y: 264))
                            path.addArc(center: .init(x: 514, y: 261),
                                        radius: 152,
                                        startAngle: Angle(degrees: 90.0),
                                        endAngle: Angle(degrees: (formattedSpeed/10) * 360 + 90),
                                        clockwise: false)
                        }
                        .fill(Color.orange)
                        
                        
                        HStack {
                            Text(String(formattedSpeed))
                                .font(.system(size: 64))
                                .foregroundColor(Color.white)
                            Text("m/s")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(.top, 32.0)
                        }
                        
                        Group {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.red)
                                .frame(width:12, height: 56)
                                .padding(.top, 300.0)
                            
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 18))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 36))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 54))
                        }
                        
                        Group {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:12, height: 56)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 72))
                            
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 90))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 108))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 126))
                        }
                        
                        Group {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:12, height: 56)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 144))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 162))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 180))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 198))
                        }
                        
                        Group {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:12, height: 56)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 216))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 234))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 252))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 270))
                        }
                        
                        Group {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:12, height: 56)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 288))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 306))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 324))
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(width:5, height: 25)
                                .padding(.top, 300.0)
                                .rotationEffect(Angle(degrees: 342))
                        }
                    }
                    .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + res))
                    .padding(.top, -350.0)
                }
                .scaleEffect(0.8)
                
                
                Button(action: {
                    print(forYawReset)
                    res = heading
                    if (forYawReset) {
                        sensor.res = sensor.yaw_origin - heading
//                        forYawReset = false
                        
                    }
//                    sensor.vx = 0.0
//                    sensor.vy = 0.0
                }) {
                    Text("Reset")
                        .frame(width: 200, height: 30)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .cornerRadius(20)
                }
                .padding(.top, -100)
                Button(action: {
                    rotate = !rotate
                    msg = rotate ? "回転を内蔵センサにする" : "回転をgpsにする "
                }) {
                    Text(msg)
                        .frame(width: 300, height: 30)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .cornerRadius(20)
                }
                .padding(.top, -60)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
