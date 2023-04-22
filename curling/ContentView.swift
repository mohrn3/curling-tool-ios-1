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
    
    var body: some View {
        let heading = $manager.heading.wrappedValue
        let speedFromLocation = $manager.speed.wrappedValue
        let formattedSpeed = round(speedFromLocation*10)/10
        let formattedXStr = round(sensor.xAccel*100)/100
        let formattedYStr = round(sensor.yAccel*100)/100
        let formattedZStr = round(sensor.zAccel*100)/100
        let speedFromAccel = fabs(sensor.speed)
        
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack{
                Text("北方向: \(heading)")
                    .foregroundColor(Color.white)
                    .padding(.bottom, 40.0)
                //                Text("速度: \(speed)")
                //                    .foregroundColor(Color.white)
                //                    .padding(.bottom, 40.0)
                Text("速度: \(sensor.speed)")
                    .foregroundColor(Color.white)
                    .padding(.bottom, 40.0)
                //                Text("x加速度: \(String(format: "%.2f", formattedXStr)), y加速度: \(String(format: "%.2f", formattedYStr)), z加速度: \(String(format: "%.2f", formattedZStr))")
                //                    .foregroundColor(Color.white)
                //                    .padding(.bottom, 40.0)
                
                
                
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
                            path.move(to: CGPoint(x: 250, y: 232))
                            path.addArc(center: .init(x: 250, y: 232),
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
                    .rotationEffect(Angle(degrees: -heading + 135 + res))
                    
                    Spacer()
                        .frame(width: 25)
                    
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
                            path.move(to: CGPoint(x: 250, y: 232))
                            path.addArc(center: .init(x: 250, y: 232),
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
                    .rotationEffect(Angle(degrees: -heading - 135 + res))
                    
                }
                
                Button(action: {
                    res = heading
                }) {
                    Text("Reset")
                        .frame(width: 200, height: 30)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .cornerRadius(20)
                        .padding(.top, 60.0)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
