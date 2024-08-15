//
//  MapView.swift
//  curling
//
//  Created by 森遥菜 on 2024/08/13.
//

import SwiftUI
import Foundation

struct MapView: View {
    var currentX: CGFloat
    var currentY: CGFloat
    private let mapWidth: CGFloat = 1000.0
    private let mapHeight: CGFloat = 4750.0
    private let rinkWidth: CGFloat = 475.0
    private let rinkHeight: CGFloat = 4450.0
    
    // 入力値 x の範囲を定義
    let minX: Double = -20
    let maxX: Double = 20
    
//    @Binding var roundedXFromUDP: Double
//    @Binding var roundedYFromUDP: Double
    
    var body: some View {
        
//        let outputX: Double = ((roundedXFromUDP - minX) * (rinkHeight - 0) / (maxX - minX)) + 0
        
        
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: rinkWidth, height: rinkHeight)
            //                .offset(x: -currentX, y: -currentY)
            
            VStack(spacing: 3272){
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
            
            Divider()
                .frame(width: 4370)
                .background(.black)
                .rotationEffect(.degrees(90))
            
            // 下から縦線
            Divider()
                .frame(width: 475)
                .background(.black)
                .padding(.bottom, 4004)
            
            Divider()
                .frame(width: 475)
                .background(.black)
                .padding(.bottom, 3638)
            
            Divider()
                .frame(width: 475)
                .background(.black)
                .padding(.bottom, 2358)
            
            Divider()
                .frame(width: 475)
                .background(.black)
                .padding(.top, 4004)
            
            Divider()
                .frame(width: 475)
                .background(.black)
                .padding(.top, 3638)
            
            Divider()
                .frame(width: 475)
                .background(.black)
                .padding(.top, 2358)
            
        }
        .frame(width: mapWidth, height: mapHeight)
        .background(Color.gray)
//        .offset(x: currentX, y: currentY)
    }
    
}

