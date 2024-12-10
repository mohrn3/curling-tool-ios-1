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

    private let rinkWidth: CGFloat = 475.0
    private let rinkHeight: CGFloat = 4200.0
    
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
            
            // 本当は消す0位置線
            Divider()
                .frame(width: 475)
                .background(.black)
            
        }
    }
}

