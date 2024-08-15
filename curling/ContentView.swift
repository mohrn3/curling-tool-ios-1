//
//  ContentView.swift
//  curling
//
//  Created by 武藤 颯汰 on 2023/02/15.
//

import SwiftUI
import MapKit
import Foundation
import AVKit


struct ContentView: View {
    
    @ObservedObject var manager = LocationManager()
    @ObservedObject var sensor = MotionSensor()
    @State var res = 0.0
    @State var forYawReset = true
    @State var msg = "ON"
    @State var rotate = false
    @State var msg2 = "回転固定あり 位置固定あり"
    @State var presen = true
    @State var status: Int = 1 //１：動画　２：リンクマップ
    
    //    @State private var receivedMessage: String = "00000000000000000000"
    //デバッグ用
    @State private var receivedMessage: String = "02800013610100255089"
    
//    @State var roundedXFromUDP: Double = 0.0
//    @State var roundedYFromUDP: Double = 0.0
    
    private let udpServer = UDPServer()
    private let udpPort: UInt16 = 8888 // ポート番号をここで指定
    private let player = AVPlayer(url: Bundle.main.url(forResource: "demo", withExtension: "mov")!)
    
    var body: some View {
//        MapView(roundedXFromUDP: $roundedXFromUDP, roundedYFromUDP: $roundedYFromUDP)
        
        //        let heading = $manager.heading.wrappedValue
        let heading = 0.0
        let speedFromLocation = $manager.speed.wrappedValue
        let formattedSpeed = round(speedFromLocation*10)/10
        let formattedHeading = round(heading*10)/10
        let formattedYaw = round(sensor.yaw*10)/10
        
        let msg_double = Double(receivedMessage)
        if let value = msg_double {
            let formattedFromUDP = round(value * 10) / 10
        } else {
            // msg_doubleがnilの場合の処理
            let formattedFromUDP = 0.0
        }
        
        let speedFromUDP = Int(receivedMessage.prefix(3)) ?? 0 //最初から3文字目までを小数点以降も整数として読み込む
        let formattedspeedFromUDP = Double(speedFromUDP / 100) + Double(speedFromUDP % 100) / 100
        
        //文字列の最初（１文字目）の"位置"を取得する
        let index1: String.Index = receivedMessage.startIndex
        //上記の「index1」を使用して文字列の最初から"圧力最初"までの"位置"を取得する
        let index2: String.Index = receivedMessage.index(index1, offsetBy: 3)
        //上記の「index1」を使用して文字列の最初から"圧力最後"までの"位置"を取得する
        let index3: String.Index = receivedMessage.index(index1, offsetBy: 6)
        //上記の「index2」「index3」を使用して、「圧力」を取得する
        let formattedPressureFromUDP = Double(receivedMessage[index2...index3]) ?? 0
        
        //デバック用
        //        let formattedspeedFromUDP = 10.0
        //        let formattedPressureFromUDP = 4095.0
        
        //上記の「index1」を使用して文字列の最初から"回転角度最初"までの"位置"を取得する
        let index4: String.Index = receivedMessage.index(index1, offsetBy: 7)
        //上記の「index1」を使用して文字列の最初から"回転角度最後"までの"位置"を取得する
        let index5: String.Index = receivedMessage.index(index1, offsetBy: 10)
        //上記の「index2」「index3」を使用して、「回転角度」を取得する
        let RpmFromUDP = Int(receivedMessage[index4...index5]) ?? 0
        //マイナス角度の差分
        let formattedRpmFromUDP = abs((RpmFromUDP - 3600)/360)
        
        //上記の「index1」を使用して文字列の最初から"回転角度最初"までの"位置"を取得する
        let index6: String.Index = receivedMessage.index(index1, offsetBy: 11)
        //上記の「index1」を使用して文字列の最初から"回転角度最後"までの"位置"を取得する
        let index7: String.Index = receivedMessage.index(index1, offsetBy: 13)
        //上記の「index2」「index3」を使用して、「回転角度」を取得する
        let RotationalSpeedFromUDP = Int(receivedMessage[index6...index7]) ?? 0
        //        let RotationalSpeedFromUDP = Int(receivedMessage.suffix(3)) ?? 0 //最後から4文字目まで
        let formattedRotationalspeedFromUDP = fabs(Double(RotationalSpeedFromUDP - 90))
        
        //上記の「index1」を使用して文字列の最初から"回転角度最初"までの"位置"を取得する
        let index8: String.Index = receivedMessage.index(index1, offsetBy: 14)
        //上記の「index1」を使用して文字列の最初から"回転角度最後"までの"位置"を取得する
        let index9: String.Index = receivedMessage.index(index1, offsetBy: 16)
        //上記の「index2」「index3」を使用して、「回転角度」を取得する
        let XFromUDP = Int(receivedMessage[index8...index9]) ?? 0
        //マイナス座標の差分
        let formattedXFromUDP = (Double(XFromUDP / 10) + Double(XFromUDP % 10) / 10) - 20
        let roundedXFromUDP = round(formattedXFromUDP * 10) / 10
        
        let YFromUDP = Int(receivedMessage.suffix(3)) ?? 0 //最後から3文字目まで
        //マイナス座標の差分
        let formattedYFromUDP = (Double(YFromUDP / 10) + Double(YFromUDP % 10) / 10) - 10
        let roundedYFromUDP = round(formattedYFromUDP * 10) / 10
        
        //機能についての箇所
        let minValue = 0.0
        let maxValue = 1.0
        
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
        let displayRadius2 = sqrt(Double(pow(Double(255 - centerX), 2) + pow(Double(240 - centerY), 2)))
        let displayRadius3 = sqrt(Double(pow(Double(255 - centerX), 2) + pow(Double(240 - centerY), 2)))
        
        let theta = ((rotate ? -heading : sensor.yaw) + 90 + res) * Double.pi / 180
        let theta2 = ((rotate ? -heading : sensor.yaw) + 90 + res) * Double.pi / 180
        let theta3 = ((rotate ? -heading : sensor.yaw) - 90 + res) * Double.pi / 180
        let cosData = Double(cos(-theta))
        let sinData = Double(sin(-theta))
        let cosData2 = Double(cos(-theta2))
        let sinData2 = Double(sin(-theta2))
        let cosData3 = Double(cos(-theta3))
        let sinData3 = Double(sin(-theta3))
        
        
        // 補正後の座標
        let measureX = centerX + Int(displayRadius * sinData)
        let measureY = centerY - Int(displayRadius * cosData)
        let measureX2 = centerX + Int(displayRadius2 * sinData2)
        let measureY2 = centerY - Int(displayRadius2 * cosData2)
        let measureX3 = centerX + Int(displayRadius3 * sinData3)
        let measureY3 = centerY - Int(displayRadius3 * cosData3)
        
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack{ // 上下にしないから消す
                //                Text("gpsから取得: \(String(formattedHeading))")
                //                    .foregroundColor(Color.white)
                //                    .padding(.bottom, 10.0)
                //                   . font(.largeTitle)
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
                
                
                if formattedPressureFromUDP == 0{ //投げる前
                    // もどす！！！！
                    ZStack {
                        //オレンジのやつ
                        Path { path in
                            path.move(to: CGPoint(x: (presen ? measureX : 263), y: (presen ? measureY : 270))) //
                            path.addArc(center: .init(x: (presen ? measureX : 263), y: (presen ? measureY : 270)), //
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
                        //                        .position(x: CGFloat(measureX), y: CGFloat(measureY))
                        .position(x: CGFloat((presen ? measureX : 263)), y: CGFloat((presen ? measureY : 270))) //
                    }
                    .scaleEffect(0.9)
                    
                    
                    // 投げたあとの２個
                }else{
                    
                    //                    Group {
                    //                        HStack{
                    ZStack {
                        Group{
                            //オレンジのやつ
                            Path { path in
                                path.move(to: CGPoint(x: (presen ? measureX2 : 255), y: (presen ? measureY2 : 240)))
                                path.addArc(center: .init(x: (presen ? measureX2 : 255), y: (presen ? measureY2 : 240)),
                                            radius: displayRadius2,
                                            startAngle: Angle(degrees: 90.0),
                                            //                                    endAngle: Angle(degrees: (formattedspeedFromUDP/10) * 360 + 90),
                                            endAngle: Angle(degrees: (10/10) * 360 + 90),
                                            clockwise: false)
                            }
                            .fill(Color.orange)
                            
                            //                            VStack(spacing: 5){
                            //                                HStack {
                            //                                    Text("m/s")
                            //                                        .foregroundColor(Color.white)
                            //                                        .fontWeight(.bold)
                            //                                        .padding(.top, 32.0)
                            //                                    Text(String(formattedspeedFromUDP))
                            //                                        .font(.system(size: 64))
                            //                                        .foregroundColor(Color.white)
                            //                                }
                            //                                HStack {
                            //                                    Text("deg/s")
                            //                                        .foregroundColor(Color.white)
                            //                                        .fontWeight(.bold)
                            //                                        .padding(.top, 32.0)
                            //                                    Text(String(formattedRotationalspeedFromUDP))
                            //                                        .font(.system(size: 64))
                            //                                        .foregroundColor(Color.white)
                            //
                            //                                }
                            //                                HStack{
                            //                                    Text("circle")
                            //                                        .foregroundColor(Color.white)
                            //                                        .fontWeight(.bold)
                            //                                        .padding(.top, 32.0)
                            //                                    Text(String(formattedRpmFromUDP))
                            //                                        .font(.system(size: 64))
                            //                                        .foregroundColor(Color.white)
                            //                                }
                            //                            }
                            
                            //                            Image("Coach")
                            //                                .resizable()                 // 画像をリサイズ可能にする
                            //                                .scaledToFill()              // 枠に収まるようにスケーリングする（アスペクト比は維持）
                            //                                .frame(width: 250, height: 150)  // 指定されたサイズの枠
                            //                                .clipped()
                            //                                .scaleEffect(1.5)
                            //                                .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
                            //                            //                            .position(x: CGFloat(measureX2), y: CGFloat(measureY2))
                            //                                .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240))) //
                            
                            //                            VStack{
                            //                                Button("Play") {
                            //                                    player.play()
                            //                                }
                            
                            switch status {
                            case 1:
                                VideoPlayer(player: player)
                                //                                                                    .scaleEffect(0.7)
                                    .scaledToFill()
                                    .frame(height: displayRadius2 * 2)
                                    .clipShape(Circle())
                                    .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
                                    .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))
                                    .onAppear {
                                        player.play()
                                    }
                                //                            }
                            case 2:
                                ZStack{
//                                    MapView(currentX: CGFloat((presen ? measureX2 : 255)), currentY: CGFloat((presen ? measureY2 : 240)))
                                    //                                        .scaleEffect(0.2)
                                    // 現在地
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 30, height: 30)
                                    //                                        .padding(.trailing, 100)
                                }
                                .frame(height: displayRadius2 * 2)
                                //                                .clipShape(Circle())
                                .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
                                .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))
                                //                                ZStack {
                                //                                    // 白い長方形
                                //                                    Rectangle()
                                //                                        .fill(Color.white)
                                //                                        .frame(width: 800, height: 89)
                                //
                                //                                    // ハウス
                                //                                    HStack(spacing: 450){
                                //                                        ZStack{
                                //                                            // 青い丸
                                //                                            Circle()
                                //                                                .fill(Color.blue)
                                //                                                .frame(width: 105, height: 105)
                                //                                            Circle()
                                //                                                .fill(Color.white)
                                //                                                .frame(width: 75, height: 75)
                                //                                            Circle()
                                //                                                .fill(Color.red)
                                //                                                .frame(width: 45, height: 45)
                                //                                            Circle()
                                //                                                .fill(Color.white)
                                //                                                .frame(width: 15, height: 15)
                                //                                        }
                                //                                        .scaleEffect(0.7)
                                //
                                //                                        ZStack{
                                //                                            // 青い丸
                                //                                            Circle()
                                //                                                .fill(Color.blue)
                                //                                                .frame(width: 105, height: 105)
                                //                                            Circle()
                                //                                                .fill(Color.white)
                                //                                                .frame(width: 75, height: 75)
                                //                                            Circle()
                                //                                                .fill(Color.red)
                                //                                                .frame(width: 45, height: 45)
                                //                                            Circle()
                                //                                                .fill(Color.white)
                                //                                                .frame(width: 15, height: 15)
                                //                                        }
                                //                                        .scaleEffect(0.7)
                                //                                    }
                                //
                                //                                    Divider()
                                //                                        .frame(width: 700)
                                //                                        .background(.black)
                                //
                                //                                    // 左から縦線
                                //                                    Divider()
                                //                                        .frame(width: 89)
                                //                                        .background(.black)
                                //                                        .rotationEffect(.degrees(90))
                                //                                        .padding(.trailing, 630)
                                //
                                //                                    Divider()
                                //                                        .frame(width: 89)
                                //                                        .background(.black)
                                //                                        .rotationEffect(.degrees(90))
                                //                                        .padding(.trailing, 555)
                                //
                                //                                    Divider()
                                //                                        .frame(width: 89)
                                //                                        .background(.black)
                                //                                        .rotationEffect(.degrees(90))
                                //                                        .padding(.trailing, 350)
                                //
                                //                                    Divider()
                                //                                        .frame(width: 89)
                                //                                        .background(.black)
                                //                                        .rotationEffect(.degrees(90))
                                //                                        .padding(.leading, 350)
                                //
                                //                                    Divider()
                                //                                        .frame(width: 89)
                                //                                        .background(.black)
                                //                                        .rotationEffect(.degrees(90))
                                //                                        .padding(.leading, 555)
                                //
                                //                                    Divider()
                                //                                        .frame(width: 89)
                                //                                        .background(.black)
                                //                                        .rotationEffect(.degrees(90))
                                //                                        .padding(.leading, 630)
                                //
                                //                                    // 現在地
                                //                                    Circle()
                                //                                        .fill(Color.black)
                                //                                        .frame(width: 20, height: 20)
                                //                                        .padding(.trailing, 100)
                                //                                }
                                //                                .frame(height: displayRadius2 * 2)
                                //                                .clipShape(Circle())
                                //                                .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
                                //                                .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))
                            default:
                                VideoPlayer(player: player)
                                //                                    .scaleEffect(0.7)
                                    .clipShape(Circle())
                                    .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
                                    .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))
                                    .onAppear {
                                        player.play()
                                    }
                                //                            }
                            }
                        }
                        .padding(.trailing, 50)
                        
                        //ZStack {
                        Group{
                            //オレンジのやつ
                            Path { path in
                                path.move(to: CGPoint(x: (presen ? measureX3 : 769), y: (presen ? measureY3 : 240)))
                                path.addArc(center: .init(x: (presen ? measureX3 : 769), y: (presen ? measureY3 : 240)),
                                            radius: displayRadius3,
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
                            .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) - 135 + res))
                            //                            .position(x: CGFloat(measureX3), y: CGFloat(measureY3))
                            .position(x: CGFloat((presen ? measureX3 : 769)), y: CGFloat((presen ? measureY3 : 240))) //
                        }
                    }
                    .scaleEffect(0.7)
                    //
                    //                    }
                    //                    .padding(.top, -50)
                }
                //            }
                
                //                圧力センサ
                //                Text("Pressure　" + String(Int(formattedPressureFromUDP)))
                //                    .foregroundColor(Color.white)
                //
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
                
                //                // オンライン指導風
                //                HStack(spacing: 50){
                //                    VStack{
                //                        HStack(){
                //                            Image(systemName: "video.fill")
                //                                .font(.system(size: 20))
                //                                .foregroundColor(.white)
                //
                //                            Image(systemName: "mic.fill")
                //                                .font(.system(size: 20))
                //                                .foregroundColor(.white)
                //                                .padding(.trailing, 180)
                //                        }
                //
                //                        Image("Coach")
                //                            .resizable()                 // 画像をリサイズ可能にする
                //                            .scaledToFill()              // 枠に収まるようにスケーリングする（アスペクト比は維持）
                //                            .frame(width: 250, height: 150)  // 指定されたサイズの枠
                //                            .clipped()
                //                    }
                //
                //                    VStack{
                //                        HStack(){
                //                            Image(systemName: "video.fill")
                //                                .font(.system(size: 20))
                //                                .foregroundColor(.white)
                //
                //                            Image(systemName: "mic.fill")
                //                                .font(.system(size: 20))
                //                                .foregroundColor(.white)
                //                                .padding(.trailing, 180)
                //                        }
                //
                //                        Image("Player")
                //                            .resizable()                 // 画像をリサイズ可能にする
                //                            .scaledToFill()              // 枠に収まるようにスケーリングする（アスペクト比は維持）
                //                            .frame(width: 250, height: 150)  // 指定されたサイズの枠
                //                            .clipped()
                //                            .border(.yellow, width: 5)
                //                    }
                
                // リンクマップ
                HStack{
                    VStack{
                        HStack{
                            roundedXFromUDP = round(formattedXFromUDP * 10) / 10
                            roundedYFromUDP = round(formattedYFromUDP * 10) / 10
                            
                            Text("X")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(.top, 20.0)
                            Text(String(roundedXFromUDP))
                                .font(.system(size: 32))
                                .foregroundColor(Color.white)
                            Text("Y")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(.top, 16.0)
                            Text(String(roundedYFromUDP))
                                .font(.system(size: 32))
                                .foregroundColor(Color.white)
                        }
                        ZStack {
                            // 白い長方形
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 800, height: 89)
                            
                            // ハウス
                            HStack(spacing: 450){
                                ZStack{
                                    // 青い丸
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 105, height: 105)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 75, height: 75)
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 45, height: 45)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 15, height: 15)
                                }
                                .scaleEffect(0.7)
                                
                                ZStack{
                                    // 青い丸
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 105, height: 105)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 75, height: 75)
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 45, height: 45)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 15, height: 15)
                                }
                                .scaleEffect(0.7)
                            }
                            
                            Divider()
                                .frame(width: 700)
                                .background(.black)
                            
                            // 左から縦線
                            Divider()
                                .frame(width: 89)
                                .background(.black)
                                .rotationEffect(.degrees(90))
                                .padding(.trailing, 630)
                            
                            Divider()
                                .frame(width: 89)
                                .background(.black)
                                .rotationEffect(.degrees(90))
                                .padding(.trailing, 555)
                            
                            Divider()
                                .frame(width: 89)
                                .background(.black)
                                .rotationEffect(.degrees(90))
                                .padding(.trailing, 350)
                            
                            Divider()
                                .frame(width: 89)
                                .background(.black)
                                .rotationEffect(.degrees(90))
                                .padding(.leading, 350)
                            
                            Divider()
                                .frame(width: 89)
                                .background(.black)
                                .rotationEffect(.degrees(90))
                                .padding(.leading, 555)
                            
                            Divider()
                                .frame(width: 89)
                                .background(.black)
                                .rotationEffect(.degrees(90))
                                .padding(.leading, 630)
                            
                            // 現在地1c7b54875e855
                            Circle()
                                .fill(Color.black)
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 100)
                        }
                        .scaleEffect(0.8)
                    }
                    
                    
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
                            status = (status % 2) + 1 // 1, 2, 3の間でステータスを変更
                        }) {
                            Text("Change Status")
                        }
                        
                        HStack{
                            Button(action: {
                                udpServer.startUDPServer(onPort: udpPort) { message in
                                    DispatchQueue.main.async {
                                        receivedMessage = message
                                    }
                                }
                            }) {
                                //                            Text("Start UDP Server")
                                //                                .frame(width: 250, height: 30)
                                //                                .foregroundColor(Color.white)
                                //                                .background(Color.gray)
                                //                                .cornerRadius(20)
                                Image(systemName: "wave.3.right") // ここに画像の名前を指定
                                //                                    .padding(10)
                                    .frame(width: 100, height: 100)
                                    .font(.system(size: 32))
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 20)
                            
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
                                //                            Text("Reset")
                                //                                .frame(width: 250, height: 30)
                                //                                .foregroundColor(Color.white)
                                //                                .background(Color.gray)
                                //                                .cornerRadius(20)
                                Image("Reset") // ここに画像の名前を指定
                                    .resizable()
                                //                                    .scaledToFit()
                                //                                    .frame(width: 50, height: 50)
                                    .padding(12)
                                    .frame(width: 100, height: 100)
                                    .imageScale(.large)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.bottom, 20)
                        
                        HStack{
                            Button(action: {
                                rotate = !rotate
                                msg = rotate ? "OFF" : "ON"
                            }) {
                                Text(msg)
                                //                                .frame(width: 250, height: 30)
                                //                                .foregroundColor(Color.white)
                                //                                .background(Color.gray)
                                //                                .cornerRadius(20)
                                    .bold()
                                //                                    .padding(10)
                                    .frame(width: 100, height: 100)
                                    .font(.system(size: 32))
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 20)
                            
                            Button(action: {
                                presen = !presen
                                msg2 = presen ? "回転固定あり 位置固定あり" : "回転固定あり 位置固定なし"
                            }) {
                                //                                Text(msg2)
                                //                                    .frame(width: 250, height: 30)
                                //                                    .foregroundColor(Color.white)
                                //                                    .background(Color.gray)
                                //                                    .cornerRadius(20)
                                Image(presen ? "position" : "direction") // ここに画像の名前を指定
                                    .resizable()
                                //                                    .scaledToFit()
                                //                                    .frame(width: 50, height: 50)
                                //                                    .padding(5)
                                    .frame(width: 100, height: 100)
                                    .imageScale(.large)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    //                もどす！！！！！！
                    .padding(.leading, -60)
                    .padding(.vertical, 50)
                    
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
