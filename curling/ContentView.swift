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
    @State private var receivedMessage: String = "02800013610100300040" // 6 - 20 = -14 / 4.0 - 2.5 = 1.5
    
    private let udpServer = UDPServer()
    private let udpPort: UInt16 = 8888 // ポート番号をここで指定
    private let player = AVPlayer(url: Bundle.main.url(forResource: "coach_zoom", withExtension: "mp4")!)
    
    // 9/15 ユーザスタディ用
    let numbers = [15, 44, 71, 38, 89, 21, 50, 28, 75, 56]
    // 現在表示中のインデックスを保持する
    @State private var currentIndex = 0
    
    var body: some View {
        
        let heading = 0.0
        
        // 最初から3文字目までを小数点以降も整数として読み込む
        //        let speedFromUDP = Int(receivedMessage.prefix(3)) ?? 0
        let speedFromUDP = 0
        let formattedspeedFromUDP = Double(speedFromUDP / 100) + Double(speedFromUDP % 100) / 100
        
        //文字列の最初（１文字目）の"位置"を取得する
        let index1: String.Index = receivedMessage.startIndex
        //上記の「index1」を使用して文字列の最初から"圧力最初"までの"位置"を取得する
        let index2: String.Index = receivedMessage.index(index1, offsetBy: 3)
        //上記の「index1」を使用して文字列の最初から"圧力最後"までの"位置"を取得する
        let index3: String.Index = receivedMessage.index(index1, offsetBy: 6)
        //上記の「index2」「index3」を使用して、「圧力」を取得する
        let formattedPressureFromUDP = Double(receivedMessage[index2...index3]) ?? 0
        
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
//        let resultY = transformedY > 23.0 ? -(transformedY - 23.0) : transformedY - 23.0


//        let transformedY: CGFloat = linearTransformY(roundedYFromUDP, minY: -10, maxY: 10, minNew: 0, maxNew: 47)
        
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
                            
                            switch status {
                            case 1:
                                VideoPlayer(player: player)
                                    .scaleEffect(1.2)
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
                                .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
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
                                .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
                                .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))

                                
                            default:
                                VideoPlayer(player: player)
                                    .clipShape(Circle())
                                    .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) + 135 + res))
                                    .position(x: CGFloat((presen ? measureX2 : 255)), y: CGFloat((presen ? measureY2 : 240)))
                                    .onAppear {
                                        player.play()
                                    }
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
                                        .font(.system(size: 48))
                                        .foregroundColor(Color.white)
//                                    Text("\(numbers[currentIndex])")
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
                            .rotationEffect(Angle(degrees: (rotate ? -heading : -sensor.yaw) - 135 + res))
                            .position(x: CGFloat((presen ? measureX3 : 769)), y: CGFloat((presen ? measureY3 : 240)))
                        }
                    }
                    .scaleEffect(0.7)
                }
                
                //                // リンクマップ
                //                HStack{
                //                    VStack{
                //                        HStack{
                //                            roundedXFromUDP = round(formattedXFromUDP * 10) / 10
                //                            roundedYFromUDP = round(formattedYFromUDP * 10) / 10
                //
                //                            Text("X")
                //                                .foregroundColor(Color.white)
                //                                .fontWeight(.bold)
                //                                .padding(.top, 20.0)
                //                            Text(String(roundedXFromUDP))
                //                                .font(.system(size: 32))
                //                                .foregroundColor(Color.white)
                //                            Text("Y")
                //                                .foregroundColor(Color.white)
                //                                .fontWeight(.bold)
                //                                .padding(.top, 16.0)
                //                            Text(String(roundedYFromUDP))
                //                                .font(.system(size: 32))
                //                                .foregroundColor(Color.white)
                //                        }
                //                        ZStack {
                //                            // 白い長方形
                //                            Rectangle()
                //                                .fill(Color.white)
                //                                .frame(width: 800, height: 89)
                //
                //                            // ハウス
                //                            HStack(spacing: 450){
                //                                ZStack{
                //                                    // 青い丸
                //                                    Circle()
                //                                        .fill(Color.blue)
                //                                        .frame(width: 105, height: 105)
                //                                    Circle()
                //                                        .fill(Color.white)
                //                                        .frame(width: 75, height: 75)
                //                                    Circle()
                //                                        .fill(Color.red)
                //                                        .frame(width: 45, height: 45)
                //                                    Circle()
                //                                        .fill(Color.white)
                //                                        .frame(width: 15, height: 15)
                //                                }
                //                                .scaleEffect(0.7)
                //
                //                                ZStack{
                //                                    // 青い丸
                //                                    Circle()
                //                                        .fill(Color.blue)
                //                                        .frame(width: 105, height: 105)
                //                                    Circle()
                //                                        .fill(Color.white)
                //                                        .frame(width: 75, height: 75)
                //                                    Circle()
                //                                        .fill(Color.red)
                //                                        .frame(width: 45, height: 45)
                //                                    Circle()
                //                                        .fill(Color.white)
                //                                        .frame(width: 15, height: 15)
                //                                }
                //                                .scaleEffect(0.7)
                //                            }
                //
                //                            Divider()
                //                                .frame(width: 700)
                //                                .background(.black)
                //
                //                            // 左から縦線
                //                            Divider()
                //                                .frame(width: 89)
                //                                .background(.black)
                //                                .rotationEffect(.degrees(90))
                //                                .padding(.trailing, 630)
                //
                //                            Divider()
                //                                .frame(width: 89)
                //                                .background(.black)
                //                                .rotationEffect(.degrees(90))
                //                                .padding(.trailing, 555)
                //
                //                            Divider()
                //                                .frame(width: 89)
                //                                .background(.black)
                //                                .rotationEffect(.degrees(90))
                //                                .padding(.trailing, 350)
                //
                //                            Divider()
                //                                .frame(width: 89)
                //                                .background(.black)
                //                                .rotationEffect(.degrees(90))
                //                                .padding(.leading, 350)
                //
                //                            Divider()
                //                                .frame(width: 89)
                //                                .background(.black)
                //                                .rotationEffect(.degrees(90))
                //                                .padding(.leading, 555)
                //
                //                            Divider()
                //                                .frame(width: 89)
                //                                .background(.black)
                //                                .rotationEffect(.degrees(90))
                //                                .padding(.leading, 630)
                //
                //                            // 現在地1c7b54875e855
                //                            Circle()
                //                                .fill(Color.black)
                //                                .frame(width: 20, height: 20)
                //                                .padding(.trailing, 100)
                //                        }
                //                        .scaleEffect(0.8)
                //                    }
                
                VStack{
                    Button(action: {
                        status = (status % 3) + 1 // 1, 2, 3の間でステータスを変更
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
                        }) {
                            Image("Reset") // ここに画像の名前を指定
                                .resizable()
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
                                .bold()
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
                            Image(presen ? "position" : "direction") // ここに画像の名前を指定
                                .resizable()
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
    
    // 3秒ごとに配列のインデックスを更新するタイマー
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            currentIndex = (currentIndex + 1) % numbers.count // 配列の範囲を超えないようにインデックスを更新
        }
    }
    
//    // 線形変換を行う関数
//    func linearTransformX(x: CGFloat) -> CGFloat {
//        let newPosition: CGFloat = (((x + 20) * 445) / 40)
//        if (newPosition >= 222){
//            return CGFloat(newPosition - 222)
//        } else {
//            return CGFloat(-(newPosition - 222))
//        }
//    }
    
    
//    // 線形変換を行う関数
//    func linearTransformY(y: Double, minY: Double, maxY: Double, minNew: Double, maxNew: Double) -> CGFloat {
//        let newPosition = ((y - minY) * (maxNew - minNew) / (maxY - minY)) + minNew
//        if (newPosition >= 23){
//            return CGFloat(newPosition - 23)
//        } else {
//            return CGFloat(-(newPosition - 23))
//        }
//    }
    

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
