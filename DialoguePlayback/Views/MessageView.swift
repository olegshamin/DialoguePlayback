//
//  MessageView.swift
//  DialoguePlayback
//
//  Created by Oleg Shamin on 18.09.2020.
//

import SwiftUI

struct MessageView: View {
    
    // MARK: - Internal properties
    
    let text: String
    
    // MARK: - Private properties
    
    @State private var opacity = 0.0
    private let maxWidthRatio: CGFloat = 0.75
    private let color = Color(hex: "FDFDFE")
    private let offsetX: CGFloat = 20
    private let textXOffset: CGFloat = 10
    
    // MARK: - Body
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(text)
                .font(Font.custom("SFProText-Light", size: 17))
                .foregroundColor(.black)
                .background(color)
                .padding(
                    EdgeInsets(
                        top: textXOffset,
                        leading: 31 + textXOffset,
                        bottom: textXOffset,
                        trailing: (1 - maxWidthRatio) * UIScreen.main.bounds.width - offsetX + textXOffset
                    )
                )
            
        }
        .background(color)
        .clipShape(Bubble(maxWidthRatio: maxWidthRatio))
        .shadow(color: Color(white: 0.5), radius: 5, x: 1, y: 1)
        .background(
            Bubble(maxWidthRatio: maxWidthRatio)
                .foregroundColor(.clear)
                .blur(radius: 4)
        )
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .opacity(opacity)
        .onAppear {
            withAnimation(.linear(duration: 0.5)) {
                opacity = 1.0
            }
        }
    }
    
}

struct Bubble: Shape {
    
    // MARK: - Internal properties
    
    let maxWidthRatio: CGFloat
    
    // MARK: -
    
    func path(in rect: CGRect) -> Path {
        
        let offsetX: CGFloat = 20
        let radius: CGFloat = 5
        var path = Path()
        
        path.addArc(
            center: CGPoint(
                x: rect.width * maxWidthRatio + offsetX - radius,
                y: rect.height - radius
            ),
            radius: radius,
            startAngle: Angle(radians: 0),
            endAngle: Angle(radians: .pi / 2),
            clockwise: false
        )
        
        path.addArc(
            center: CGPoint(
                x: offsetX + radius,
                y: rect.height - radius + 3
            ),
            radius: 3,
            startAngle: Angle(radians: .pi / 2),
            endAngle: Angle(radians: .pi),
            clockwise: false
        )
        
        path.addLine(
            to: CGPoint(
                x: offsetX + 10,
                y: rect.height - 15 - radius
            )
        )
        
        path.addArc(
            center: CGPoint(
                x: offsetX + 15,
                y: 5
            ),
            radius: radius,
            startAngle: Angle(radians: .pi),
            endAngle: Angle(radians: 3 * .pi / 2),
            clockwise: false
        )
        
        path.addArc(
            center: CGPoint(
                x: rect.width * maxWidthRatio + offsetX - radius,
                y: 5
            ),
            radius: radius,
            startAngle: Angle(radians: 3 * .pi / 2),
            endAngle: Angle(radians: 2 * .pi),
            clockwise: false
        )
        return path
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageView(text: "Text message")
        }
    }
}
