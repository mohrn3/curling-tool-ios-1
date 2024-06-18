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
    
    @State private var receivedMessage: String = "00000000000000"
    //デバッグ用
//    @State private var receivedMessage: String = "02810003610100"
    
    private let udpServer = UDPServer()
    private let udpPort: UInt16 = 8888 // ポート番号をここで指定

    
    var body: some View {
//        let heading = $manager.heading.wrappedValue
        let heading = 0.0
        let speedFromLocation = $manager.speed.wrappedValue
        let formattedSpeed = round(speedFromLocation*10)/10
        let formattedHeading = round(heading*10)/10
//        let formattedHeading = 0
        let formattedYaw = round(sensor.yaw*10)/10
        let msg_double = Double(receivedMessage)
        
        if let value = msg_double {
            let formattedFromUDP = round(value * 10) / 10
        } else {
            // msg_doubleがnilの場合の処理
            let formattedFromUDP = 0.0
        }
        
        let speedFromUDP = Int(receivedMessage.prefix(3)) ?? 0 //最初から3文字目までを小数点以降も整数として読み込む
        let formattedspeedFromUDP = Double(speedFromUDP / 10) + Double(speedFromUDP % 10) / 10
        
        //文字列の最初（１文字目）の"位置"を取得する
        let index1: String.Index = receivedMessage.startIndex
//        //上記の「index1」を使用して文字列の最初から"圧力最初"までの"位置"を取得する
//        let index2: String.Index = receivedMessage.index(index1, offsetBy: 3)
//        //上記の「index1」を使用して文字列の最初から"圧力最後"までの"位置"を取得する
//        let index3: String.Index = receivedMessage.index(index1, offsetBy: 6)
//        //上記の「index2」「index3」を使用して、「圧力」を取得する
//        let formattedPressureFromUDP = Double(receivedMessage[index2...index3]) ?? 0

        //デバック用
//        let formattedspeedFromUDP = 10.0
        let formattedPressureFromUDP = 4095.0
        
        //上記の「index1」を使用して文字列の最初から"回転角度最初"までの"位置"を取得する
        let index4: String.Index = receivedMessage.index(index1, offsetBy: 7)
        //上記の「index1」を使用して文字列の最初から"回転角度最後"までの"位置"を取得する
        let index5: String.Index = receivedMessage.index(index1, offsetBy: 10)
        //上記の「index2」「index3」を使用して、「回転角度」を取得する
        let RpmFromUDP = Int(receivedMessage[index4...index5]) ?? 0
        //マイナス角度の差分
        let formattedRpmFromUDP = abs((RpmFromUDP - 3600)/360)
        
        let RotationalSpeedFromUDP = Int(receivedMessage.suffix(3)) ?? 0 //最後から4文字目まで
        let formattedRotationalspeedFromUDP = fabs(Double(RotationalSpeedFromUDP - 90))
        
        let minValue = 0.0
        let maxValue = 4095.0
        
//        // 1:丸いやつの中心座標 <- なくす方向で、同じビューを再現できるかやってみる 5/17
//        let initialMeasureX = 263
//        let initialMeasureY = 270
        
        let bounds = UIScreen.main.bounds
        let centerWidth = Int(bounds.width)
        let centerHeight = Int(bounds.height)
        
        // 画面の中心座標
        let centerX = centerWidth / 2
        let centerY = (centerHeight / 2) - 125
  
        // 半径
        let displayRadius = sqrt(Double(pow(Double(263 - centerX), 2) + pow(Double(270 - centerY), 2)))
        
        let theta = ((rotate ? -heading : sensor.yaw) + 90 + res) * Double.pi / 180
        let cosData = Double(cos(-theta))
        let sinData = Double(sin(-theta))
        
        // 補正後の座標
        let measureX = centerX + Int(displayRadius * sinData)
        let measureY = centerY - Int(displayRadius * cosData)
        
    
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack{ // 上下にしないから消す
//                Text("gpsから取得: \(String(formattedHeading))")
//                    .foregroundColor(Color.white)
//                    .padding(.bottom, 10.0)
//                    .font(.largeTitle)
//                Text("udpからの速度: \(receivedMessage)")
//                    .foregroundColor(Color.white)
//                    .padding(.bottom, 10.0)
//                    .font(.largeTitle)
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
//                Text("内蔵センサから取得: \(String(formattedYaw))")
//                    .foregroundColor(Color.white)
//                    .font(.largeTitle)
                
//              if formattedspeedFromUDP
            
            
            if formattedPressureFromUDP > 1500{ //投げる前
                
// もどす！！！！
                ZStack {
                    //オレンジのやつ
                    Path { path in
                        path.move(to: CGPoint(x: measureX, y: measureY))
                        path.addArc(center: .init(x: measureX, y: measureY),
                                    radius: displayRadius,
                                    startAngle: Angle(degrees: 90.0),
//                                    endAngle: Angle(degrees: (formattedspeedFromUDP/10) * 360 + 90),
                                    endAngle: Angle(degrees: (10/10) * 360 + 90),
                                    clockwise: false)
                    }
                    .fill(Color.orange)
                    
                    VStack(spacing: 5){
                        HStack {
                            Text("m/s")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(.top, 32.0)
                            Text(String(formattedspeedFromUDP))
                                .font(.system(size: 64))
                                .foregroundColor(Color.white)
                        }
                        HStack {
                            Text("deg/s")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(.top, 32.0)
                            Text(String(formattedRotationalspeedFromUDP))
                                .font(.system(size: 64))
                                .foregroundColor(Color.white)

                        }
                        HStack{
                            Text("circle")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(.top, 32.0)
                            Text(String(formattedRpmFromUDP))
                                .font(.system(size: 64))
                                .foregroundColor(Color.white)
                        }
                    }
                    .scaleEffect(1.5)
                    .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + res))
                    .position(x: CGFloat(measureX), y: CGFloat(measureY))
                }
                .scaleEffect(0.9)
                
//                HStack{
//                    ZStack {
//
//                        Path { path in
//                            path.move(to: CGPoint(x: 263, y: 270))
//                            path.addArc(center: .init(x: 263, y: 270),
//                                        radius: 152,
//                                        startAngle: Angle(degrees: 90.0),
//                                        endAngle: Angle(degrees: (formattedspeedFromUDP/10) * 360 + 90),
//                                        clockwise: false)
//                        }
//                        .fill(Color.orange)
//
//                        VStack(spacing: 5){
//                            //                        HStack {
//                            //                            Text(String(Int(sensor.yaw)))
//                            //                                .font(.system(size: 40))
//                            //                                .foregroundColor(Color.white)
//                            //                        }
//                            HStack {
//                                Text(String(formattedspeedFromUDP))
//                                    .font(.system(size: 64))
//                                    .foregroundColor(Color.white)
//                                Text("m/s")
//                                    .foregroundColor(Color.white)
//                                    .fontWeight(.bold)
//                                    .padding(.top, 32.0)
//                            }
//                            HStack {
//                                Text(String(formattedRotationalspeedFromUDP))
//                                    .font(.system(size: 40))
//                                    .foregroundColor(Color.white)
//                                Text("deg/s")
//                                    .foregroundColor(Color.white)
//                                    .fontWeight(.bold)
//
//                            }
//                            HStack{
//                                Text(String(formattedRpmFromUDP))
//                                    .font(.system(size: 40))
//                                    .foregroundColor(Color.white)
//                                Text("circle")
//                                    .foregroundColor(Color.white)
//                                    .fontWeight(.bold)
//                            }
//                        }
                        
//                        Group {
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.red)
//                                .frame(width:12, height: 56)
//                                .padding(.top, 300.0)
//
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 18))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 36))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 54))
//                        }
//
//                        Group {
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:12, height: 56)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 72))
//
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 90))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 108))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 126))
//                        }
//
//                        Group {
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:12, height: 56)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 144))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 162))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 180))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 198))
//                        }
//
//                        Group {
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:12, height: 56)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 216))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 234))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 252))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 270))
//                        }
//
//                        Group {
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:12, height: 56)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 288))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 306))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 324))
//                            RoundedRectangle(cornerRadius: 30)
//                                .fill(Color.white)
//                                .frame(width:5, height: 25)
//                                .padding(.top, 300.0)
//                                .rotationEffect(Angle(degrees: 342))
//                        }
//                    }
//                    .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + res))
//                    .scaleEffect(1.2)
//                    .padding(.trailing, 500)
//    //                もどす！！！！！！！！
    //                .padding(.top, -200)
                
                
            // 投げたあとの２個
            }else{
                VStack(spacing: 100) {
//                    HStack {
//                        HStack {
//                            Text(String(formattedRotationalspeedFromUDP))
//                                .font(.system(size: 40))
//                                .foregroundColor(Color.white)
//                            Text("m/s")
//                                .foregroundColor(Color.white)
//                                .fontWeight(.bold)
//                                .padding(.top, 32.0)
//                        }
//                        .rotationEffect(Angle(degrees: -30))
//                        .padding(.leading, 80)
//                        
//                        Spacer()
//                        
//                        HStack{
//                            Text(String(formattedRpmFromUDP))
//                                .font(.system(size: 40))
//                                .foregroundColor(Color.white)
//                            Text("")
//                                .foregroundColor(Color.white)
//                                .fontWeight(.bold)
//                                .padding(.top, 32.0)
//                        }
//                        
//                        Spacer()
//                        
//                        HStack {
//                            Text(String(formattedRotationalspeedFromUDP))
//                                .font(.system(size: 40))
//                                .foregroundColor(Color.white)
//                            Text("m/s")
//                                .foregroundColor(Color.white)
//                                .fontWeight(.bold)
//                                .padding(.top, 32.0)
//                        }
//                        .rotationEffect(Angle(degrees: 30))
//                        .padding(.trailing, 80)
//                    }.padding(.top, 50)
                
                    Spacer()
                    
                    Group {
                        HStack{
                            // 左上の丸
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
//                                    path.move(to: CGPoint(x: 155, y: 179))
//                                    path.addArc(center: .init(x: 155, y: 179),
                                    path.move(to: CGPoint(x: 255, y: 240))
                                    path.addArc(center: .init(x: 255, y: 240),
                                                radius: 152,
                                                startAngle: Angle(degrees: 90.0),
                                                endAngle: Angle(degrees: (formattedspeedFromUDP/10) * 360 + 90),
                                                clockwise: false)
                                }
                                .fill(Color.orange)
                                
                                VStack(spacing: 5){
                                    HStack {
                                        Text(String(formattedspeedFromUDP))
                                            .font(.system(size: 64))
                                            .foregroundColor(Color.white)
                                        Text("m/s")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 32.0)
                                    }
                                    HStack {
                                        Text(String(formattedRotationalspeedFromUDP))
                                            .font(.system(size: 40))
                                            .foregroundColor(Color.white)
                                        Text("deg/s")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)

                                    }
                                    HStack{
                                        Text(String(formattedRpmFromUDP))
                                            .font(.system(size: 40))
                                            .foregroundColor(Color.white)
                                        Text("circle")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                    }
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
                            
                            // 右上の丸
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
                                    path.move(to: CGPoint(x: 255, y: 240))
                                    path.addArc(center: .init(x: 255, y: 240),
                                                radius: 152,
                                                startAngle: Angle(degrees: 90.0),
                                                endAngle: Angle(degrees: (formattedspeedFromUDP/10) * 360 + 90),
                                                clockwise: false)
                                }
                                .fill(Color.orange)
                                
                                VStack(spacing: 5){
                                    HStack {
                                        Text(String(formattedspeedFromUDP))
                                            .font(.system(size: 64))
                                            .foregroundColor(Color.white)
                                        Text("m/s")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 32.0)
                                    }
                                    HStack {
                                        Text(String(formattedRotationalspeedFromUDP))
                                            .font(.system(size: 40))
                                            .foregroundColor(Color.white)
                                        Text("deg/s")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)

                                    }
                                    HStack{
                                        Text(String(formattedRpmFromUDP))
                                            .font(.system(size: 40))
                                            .foregroundColor(Color.white)
                                        Text("circle")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                    }
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
                    }
                    .padding(.top, -50)
                }
            }
                
//                Text("Pressure　" + String(Int(formattedPressureFromUDP)))
//                    .foregroundColor(Color.white)
                
//                Gauge(value: formattedPressureFromUDP ,in: minValue...maxValue){
//                    Text("Gauge Label")
//                } currentValueLabel: {
//                    Text("\(Int(formattedPressureFromUDP))")
//                        .foregroundColor(Color.white)
//                } minimumValueLabel: {
//                    Text("\(Int(minValue))")
//                        .foregroundColor(Color.white)
//                } maximumValueLabel: {
//                    Text("\(Int(maxValue))")
//                        .foregroundColor(Color.white)
//                }
//                .frame(width:300)
//                .tint(.orange)
//                .padding(.leading, 500)
                
                // オンライン指導風
                HStack(spacing: 50){
                    VStack{
                        HStack(){
                            Image(systemName: "video.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                            Image(systemName: "mic.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(.trailing, 180)
                        }
                        
                        Image("Coach")
                            .resizable()                 // 画像をリサイズ可能にする
                            .scaledToFill()              // 枠に収まるようにスケーリングする（アスペクト比は維持）
                            .frame(width: 250, height: 150)  // 指定されたサイズの枠
                            .clipped()
                    }
                    
                    VStack{
                        HStack(){
                            Image(systemName: "video.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                            Image(systemName: "mic.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(.trailing, 180)
                        }
                        
                        Image("Player")
                            .resizable()                 // 画像をリサイズ可能にする
                            .scaledToFill()              // 枠に収まるようにスケーリングする（アスペクト比は維持）
                            .frame(width: 250, height: 150)  // 指定されたサイズの枠
                            .clipped()
                            .border(.yellow, width: 5)
                    }
                
//                // リンクマップ
//                HStack{
//                    ZStack {
//                        // 白い長方形
//                        Rectangle()
//                            .fill(Color.white)
//                            .frame(width: 800, height: 89)
//                        
//                        // ハウス
//                        HStack(spacing: 450){
//                            ZStack{
//                                // 青い丸
//                                Circle()
//                                    .fill(Color.blue)
//                                    .frame(width: 105, height: 105)
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 75, height: 75)
//                                Circle()
//                                    .fill(Color.red)
//                                    .frame(width: 45, height: 45)
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 15, height: 15)
//                            }
//                            .scaleEffect(0.7)
//                            
//                            ZStack{
//                                // 青い丸
//                                Circle()
//                                    .fill(Color.blue)
//                                    .frame(width: 105, height: 105)
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 75, height: 75)
//                                Circle()
//                                    .fill(Color.red)
//                                    .frame(width: 45, height: 45)
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 15, height: 15)
//                            }
//                            .scaleEffect(0.7)
//                        }
//                        
//                        Divider()
//                            .frame(width: 700)
//                            .background(.black)
//                        
//                        // 左から縦線
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.trailing, 630)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.trailing, 555)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.trailing, 350)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.leading, 350)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.leading, 555)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.leading, 630)
//                        
//                        // 現在地
//                        Circle()
//                            .fill(Color.black)
//                            .frame(width: 20, height: 20)
//                            .padding(.trailing, 100)
//                    }
                
//                // 軌道予測風
//                HStack{
//                    ZStack {
//                        // 白い長方形
//                        Rectangle()
//                            .fill(Color.white)
//                            .frame(width: 800, height: 89)
//                        
//                        // ハウス
//                        HStack(spacing: 450){
//                            ZStack{
//                                // 青い丸
//                                Circle()
//                                    .fill(Color.blue)
//                                    .frame(width: 105, height: 105)
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 75, height: 75)
//                                Circle()
//                                    .fill(Color.red)
//                                    .frame(width: 45, height: 45)
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 15, height: 15)
//                            }
//                            .scaleEffect(0.7)
//                            
//                            ZStack{
//                                // 青い丸
//                                Circle()
//                                    .fill(Color.blue)
//                                    .frame(width: 105, height: 105)
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 75, height: 75)
//                                Circle()
//                                    .fill(Color.red)
//                                    .frame(width: 45, height: 45)
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 15, height: 15)
//                            }
//                            .scaleEffect(0.7)
//                        }
//                        
//                        Divider()
//                            .frame(width: 700)
//                            .background(.black)
//                        
//                        // 左から縦線
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.trailing, 630)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.trailing, 555)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.trailing, 350)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.leading, 350)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.leading, 555)
//                        
//                        Divider()
//                            .frame(width: 89)
//                            .background(.black)
//                            .rotationEffect(.degrees(90))
//                            .padding(.leading, 630)
//                        
//                        // 現在地
//                        Circle()
//                            .fill(Color.black)
//                            .frame(width: 20, height: 20)
//                            .padding(.trailing, 100)
//                        
//                        Circle()
//                            .fill(Color.green)
//                            .frame(width: 15, height: 15)
//                            .padding(.trailing, 0)
//                        
//                        Circle()
//                            .fill(Color.green)
//                            .frame(width: 15, height: 15)
//                            .padding(.leading, 100)
//                        
//                        Circle()
//                            .fill(Color.green)
//                            .frame(width: 15, height: 15)
//                            .padding(.leading, 200)
//                        
//                        Circle()
//                            .fill(Color.green)
//                            .frame(width: 15, height: 15)
//                            .padding(.leading, 300)
//                            .padding(.top, 5)
//                        
//                        Circle()
//                            .fill(Color.green)
//                            .frame(width: 15, height: 15)
//                            .padding(.leading, 400)
//                            .padding(.top, 20)
//                        
//                        Circle()
//                            .fill(Color.green)
//                            .frame(width: 15, height: 15)
//                            .padding(.leading, 500)
//                            .padding(.top, 50)
//                    }
  
                
                    VStack{
                        Button(action: {
                            udpServer.startUDPServer(onPort: udpPort) { message in
                                DispatchQueue.main.async {
                                    receivedMessage = message
                                }
                            }
                        }) {
                            Text("Start UDP Server")
                                .frame(width: 200, height: 30)
                                .foregroundColor(Color.white)
                                .background(Color.gray)
                                .cornerRadius(20)
                        }
                        
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
                                            Button(action: {
                                                rotate = !rotate
                                                msg = rotate ? "回転を内蔵センサにする" : "回転をgpsにする"
                                            }) {
                                                Text(msg)
                                                    .frame(width: 300, height: 30)
                                                    .foregroundColor(Color.white)
                                                    .background(Color.gray)
                                                    .cornerRadius(20)
                                            }
                    }
                    //                もどす！！！！！！
                    //                .padding(.leading, 500)
                    .padding(.vertical, 55)
                    
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
