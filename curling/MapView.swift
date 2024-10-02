//
//  MapView.swift
//  curling
//
//  Created by 森遥菜 on 2024/08/13.
//

import SwiftUI
import Foundation

struct MapView: View {
    var currentX: CGFloat = 0.0
    var currentY: CGFloat = 0.0
//    private let mapWidth: CGFloat = 1000.0
//    private let mapHeight: CGFloat = 4750.0
    private let rinkWidth: CGFloat = 475.0
    private let rinkHeight: CGFloat = 4200.0

//    // 入力値 x の範囲を定義
//    let minX: Double = -20
//    let maxX: Double = 20
//    
//    // 入力値 y の範囲を定義
//    let minY: Double = -10
//    let maxY: Double = 10
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: rinkWidth, height: rinkHeight)
            
            VStack(spacing: 3114){
                ZStack{
                    // 青い丸
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 366, height: 366)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 244, height: 244)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 122, height: 122)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 30, height: 30)
                }
                
                ZStack{
                    // 青い丸
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 366, height: 366)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 244, height: 244)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 122, height: 122)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 30, height: 30)
                }
            }
            
            // center line
            Divider()
                .frame(width: 4200)
                .background(.black)
                .rotationEffect(.degrees(90))
            
            // back line
            VStack(spacing: 3840){
                // 下から縦線
                Divider()
                    .frame(width: 475)
                    .background(.black)
                
                // 下から縦線
                Divider()
                    .frame(width: 475)
                    .background(.black)
            }
            
            // tee line
            VStack(spacing: 3475){
                // 下から縦線
                Divider()
                    .frame(width: 475)
                    .background(.red)
                
                // 下から縦線
                Divider()
                    .frame(width: 475)
                    .background(.red)
            }
            
            // hog line
            VStack(spacing: 2200){
                // 下から縦線
                Divider()
                    .frame(width: 475)
                    .background(.black)
                
                // 下から縦線
                Divider()
                    .frame(width: 475)
                    .background(.black)
            }
            
//            Divider()
//                .frame(width: 475)
//                .background(.black)
//                .padding(.bottom, 3638)
//            
//            Divider()
//                .frame(width: 475)
//                .background(.black)
//                .padding(.bottom, 2358)
//            
//            Divider()
//                .frame(width: 475)
//                .background(.black)
//                .padding(.top, 4004)
//            
//            Divider()
//                .frame(width: 475)
//                .background(.black)
//                .padding(.top, 3638)
//            
//            Divider()
//                .frame(width: 475)
//                .background(.black)
//                .padding(.top, 2358)
            
            // 本当は消す0位置線
            Divider()
                .frame(width: 475)
                .background(.black)
            
        }
//        .frame(width: mapWidth, height: mapHeight)
//        .background(Color.gray)
//        .offset(x: -currentX, y: -currentY)
    }
    
//    // 線形変換を行う関数
//    func linearTransform(t: Double, minT: Double, maxT: Double, minNew: Double, maxNew: Double) -> Double {
//        return ((t - minT) * (maxNew - minNew) / (maxT - minT)) + minNew
//    }


}

