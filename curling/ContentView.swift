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
    @State private var receivedMessage: String = "02800015000100300040" // 6 - 20 = -14 / 4.0 - 2.5 = 1.5
    
    private let udpServer = UDPServer()
    private let udpPort: UInt16 = 8888 // ポート番号をここで指定
    private let player = AVPlayer(url: Bundle.main.url(forResource: "coach_zoom", withExtension: "mp4")!)
    
    // 9/15 ユーザスタディ用
    let numbers = [15, 44, 71, 38, 89, 21, 50, 28, 75, 56]
    
    // 10/11 ユーザスタディ用
    let numbers1 = [28, 45, 93, 74, 51, 62, 87, 39, 96, 53, 41, 82, 68, 22, 64, 77, 95, 35, 88, 47] //絶対位置
    let numbers2 = [76, 52, 94, 84, 67, 29, 55, 81, 43, 31, 69, 26, 83, 44, 92, 66, 32, 78, 97, 50] //回転方向
    let numbers3 = [54, 61, 33, 71, 40, 25, 85, 49, 73, 91, 57, 37, 80, 99, 65, 30, 46, 89, 72, 98] //無回転
    
    // 現在表示中のインデックスを保持する
    @State private var currentIndex = 0
    
    var body: some View {
        
        let heading = 0.0
        
        let speedFromUDP = extractValue(from: receivedMessage, start: 0, length: 3)
        let formattedspeedFromUDP = speedFromUDP / 100.0
        
        // 文字列の圧力の範囲を指定して抜き出す
        let formattedPressureFromUDP = extractValue(from: receivedMessage, start: 3, length: 4)

        // 文字列の回転角度の範囲を指定して抜き出す
        let RpmFromUDP = Int(extractValue(from: receivedMessage, start: 7, length: 4)) ?? 0
        // マイナス角度の差分
        let formattedRpmFromUDP = abs((RpmFromUDP - 3600) / 360)
        
        // 文字列の回転速度の範囲を指定して抜き出す
        let RotationalSpeedFromUDP = Int(extractValue(from: receivedMessage, start: 11, length: 3)) ?? 0
        // 回転速度の処理
        let formattedRotationalspeedFromUDP = fabs(Double(RotationalSpeedFromUDP - 90))

        // 文字列のX座標の範囲を指定して抜き出す
        let XFromUDP = Int(extractValue(from: receivedMessage, start: 14, length: 3)) ?? 0
        // マイナス座標の差分
        let formattedXFromUDP = (Double(XFromUDP / 10) + Double(XFromUDP % 10) / 10) - 20
        let roundedXFromUDP = round(formattedXFromUDP * 10) / 10
        
        // 文字列のY座標の範囲を指定して抜き出す（最後から3文字）
        let YFromUDP = Int(extractValue(from: receivedMessage, start: receivedMessage.count - 3, length: 3)) ?? 0
        // マイナス座標の差分
        let formattedYFromUDP = (Double(YFromUDP / 10) + Double(YFromUDP % 10) / 10) - 2.5
        let roundedYFromUDP = round(formattedYFromUDP * 10) / 10
        
        //機能についての箇所
        let minValue = 0.0
        let maxValue = 1.0
        
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
        
        // 現在地
        let transformedX: CGFloat = (((roundedXFromUDP + 20) * 1050) / 42)
        let resultX = roundedXFromUDP >= 0 ? transformedX - 525.0 - 250.0 : transformedX - 525.0 + 250.0
        
        let transformedY: CGFloat = (((roundedYFromUDP + 2.5) * 118) / 5)
        let resultY = transformedY - 59.0
        
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack{
                if formattedPressureFromUDP == 0{ //投げる前
                    ZStack {
                        //オレンジのやつ
                        Path { path in
                            path.move(to: CGPoint(x: (presen ? measureX : 263), y: (presen ? measureY : 270))) //
                            path.addArc(center: .init(x: (presen ? measureX : 263), y: (presen ? measureY : 270)), //
                                        radius: displayRadius,
                                        startAngle: Angle(degrees: 90.0),
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
                        .position(x: CGFloat((presen ? measureX : 263)), y: CGFloat((presen ? measureY : 270)))
                    }
                    .scaleEffect(0.9)
                    
                    
                    // 投げたあとの２個
                }else{
                    ZStack {
                        Group{
                            //オレンジのやつ
                            Path { path in
                                path.move(to: CGPoint(x: (presen ? measureX2 : 255), y: (presen ? measureY2 : 240)))
                                path.addArc(center: .init(x: (presen ? measureX2 : 255), y: (presen ? measureY2 : 240)),
                                            radius: displayRadius2,
                                            startAngle: Angle(degrees: 90.0),
                                            endAngle: Angle(degrees: 450),
                                            clockwise: false)
                            }
                            .fill(Color.orange)
                            
                            switch status {
                            case 1:
                                VideoPlayer(player: player)
                                    .scaleEffect(1.2)
                                    .scaledToFill()
                                    .frame(height: displayRadius2 * 2)
                                    .clipShape(Circle())
                                    .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 45 + res))
                                    .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))
                                    .onAppear {
                                        player.play()
                                    }
                            case 2:
                                
                                ZStack{
                                    MapView()
                                        .scaleEffect(0.25)
                                        .offset(x: 0, y: roundedXFromUDP >= 0 ? -250 : 250)
                                    // 現在地
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 20, height: 20)
                                        .offset(x: resultY, y: resultX)
                                }
                                .frame(width: displayRadius2 * 2, height: displayRadius2 * 2)
                                .clipShape(Circle())
                                .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 45 + res))
                                .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))
                                
                            case 3:
                                VStack(spacing: 5){
                                    HStack {
                                        Text("m/s")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 32.0)
                                        Text(String(formattedspeedFromUDP))
                                            .font(.system(size: 48))
                                            .foregroundColor(Color.white)
                                    }
                                    HStack {
                                        Text("deg/s")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 32.0)
                                        Text(String(formattedRotationalspeedFromUDP))
                                            .font(.system(size: 48))
                                            .foregroundColor(Color.white)
                                        
                                    }
                                    HStack{
                                        Text("circle")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 32.0)
                                        Text(String(formattedRpmFromUDP))
                                            .font(.system(size: 48))
                                            .foregroundColor(Color.white)
                                    }
                                    HStack{
                                        Text("X ")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 16.0)
                                        Text(String(roundedXFromUDP))
                                            .font(.system(size: 32))
                                            .foregroundColor(Color.white)
                                            .padding(.trailing, 15.0)
                                        Text("Y ")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 16.0)
                                        Text(String(roundedYFromUDP))
                                            .font(.system(size: 32))
                                            .foregroundColor(Color.white)
                                    }
                                    .padding(.top, 15)
                                }
                                .scaleEffect(1.5)
                                .frame(height: displayRadius2 * 2)
                                .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 45 + res))
                                .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))

                                
                            default:
                                VStack(spacing: 5){
                                    HStack {
                                        Text("m/s")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 32.0)
                                        Text(String(formattedspeedFromUDP))
                                            .font(.system(size: 48))
                                            .foregroundColor(Color.white)
                                    }
                                    HStack {
                                        Text("deg/s")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 32.0)
                                        Text(String(formattedRotationalspeedFromUDP))
                                            .font(.system(size: 48))
                                            .foregroundColor(Color.white)
                                        
                                    }
                                    HStack{
                                        Text("circle")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 32.0)
                                        Text(String(formattedRpmFromUDP))
                                            .font(.system(size: 48))
                                            .foregroundColor(Color.white)
                                    }
                                    HStack{
                                        Text("X ")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 16.0)
                                        Text(String(roundedXFromUDP))
                                            .font(.system(size: 32))
                                            .foregroundColor(Color.white)
                                            .padding(.trailing, 15.0)
                                        Text("Y ")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 16.0)
                                        Text(String(roundedYFromUDP))
                                            .font(.system(size: 32))
                                            .foregroundColor(Color.white)
                                    }
                                    .padding(.top, 15)
                                }
                                .scaleEffect(1.5)
                                .frame(height: displayRadius2 * 2)
                                .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 45 + res))
                                .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))

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
                                        .font(.system(size: 48))
                                        .foregroundColor(Color.white)
//                                    Text("\(numbers1[currentIndex])")
//                                        .foregroundColor(Color.white)
//                                        .font(.system(size: 48))
//                                        .onAppear(perform: startTimer)
                                }
                                HStack {
                                    Text("deg/s")
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                        .padding(.top, 32.0)
                                    Text(String(formattedRotationalspeedFromUDP))
                                        .font(.system(size: 48))
                                        .foregroundColor(Color.white)
                                    
                                }
                                HStack{
                                    Text("circle")
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                        .padding(.top, 32.0)
                                    Text(String(formattedRpmFromUDP))
                                        .font(.system(size: 48))
                                        .foregroundColor(Color.white)
                                }
                                HStack{
                                    Text("X ")
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                        .padding(.top, 16.0)
                                    Text(String(roundedXFromUDP))
                                        .font(.system(size: 32))
                                        .foregroundColor(Color.white)
                                        .padding(.trailing, 15.0)
                                    Text("Y ")
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                        .padding(.top, 16.0)
                                    Text(String(roundedYFromUDP))
                                        .font(.system(size: 32))
                                        .foregroundColor(Color.white)
                                }
                                .padding(.top, 15)
                            }
                            .scaleEffect(1.5)
                            .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) - 45 + res))
                            .position(x: CGFloat((presen ? measureX3 : 769)), y: CGFloat((presen ? measureY3 : 240)))
                        }
                    }
                    .scaleEffect(0.7)
                }
                                
                VStack{
                    Button(action: {
                        status = (status % 3) + 1 // 1, 2, 3の間でステータスを変更
                    }) {
                        Text("Change Status")
                            .font(.system(size: 12)) // フォントサイズを小さく
                            .foregroundColor(Color.white) // 文字色を黒に
                    }
                    .background(Color.black) // 背景色を黒に
                    
                    HStack{
                        Button(action: {
                            udpServer.startUDPServer(onPort: udpPort) { message in
                                DispatchQueue.main.async {
                                    receivedMessage = message
                                }
                            }
                        }) {
                            Text("UDP")
                                .font(.system(size: 16)) // フォントサイズを小さく
                                .foregroundColor(Color.white)
                        }
                        .background(Color.black)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        Button(action: {
                            print(forYawReset)
                            res = heading
                            if (forYawReset) {
                                sensor.res = sensor.yaw_origin - heading
                            }
                        }) {
                            Text("Reset")
                                .foregroundColor(Color.white)
                                .frame(width: 50, height: 50)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                    
                    HStack{
                        Button(action: {
                            rotate = !rotate
                            msg = rotate ? "OFF" : "ON"
                        }) {
                            Text(msg)
                                .font(.system(size: 16))
                                .foregroundColor(Color.white)
                        }
                        .background(Color.black)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        Button(action: {
                            presen = !presen
                            msg2 = presen ? "回転固定あり 位置固定あり" : "回転固定あり 位置固定なし"
                        }) {
                            Text(presen ? "絶対位置" : "回転方向")
                                .foregroundColor(Color.white)
                                .frame(width: 50, height: 50)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.trailing, 800) // 寄せる
                .padding(.vertical, 50) // 縦方向のパディング
                
                
            }
        }
    }
    
    // 3秒ごとに配列のインデックスを更新するタイマー
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            currentIndex = (currentIndex + 1) % numbers1.count // 配列の範囲を超えないようにインデックスを更新
        }
    }
    
    // Stringで受け取った値を、指定範囲だけ抜き出してDoubleに変換する
    func extractValue(from message: String, start: Int, length: Int) -> Double {
        guard start >= 0, length > 0, start + length <= message.count else { return 0.0 }
        let startIndex = message.index(message.startIndex, offsetBy: start)
        let endIndex = message.index(startIndex, offsetBy: length)
        return Double(message[startIndex..<endIndex]) ?? 0.0
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
