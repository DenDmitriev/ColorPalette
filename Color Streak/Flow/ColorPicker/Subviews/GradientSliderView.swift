//
//  GradientSliderView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 25.05.2024.
//

import SwiftUI

struct GradientSliderView: View {
    let text: String
    @Binding var color: Color
    @Binding var level: Double
    let initial: Double?
    @Binding var gradient: LinearGradient
    @State var coordinate: ColorCoordinate
    let showControl = true
    
    @State private var size: CGSize = .zero
    @State private var position: CGPoint = .zero
    
    @State private var isDragging = false
    
    @Environment(\.isEnabled) private var isEnabled
    
    @State private var triggerVibration: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if !text.isEmpty {
                    Text(text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.secondary)
                        .font(.system(size: 12, weight: .semibold))
                }
                
                if showControl {
                    StepperView(level: $level, formatter: $coordinate)
                }
            }
            .padding(.horizontal, 12)
            
            ZStack {
                Capsule()
                    .fill(gradient.opacity(isEnabled ? 1 : 0.5))
                    .frame(height: 8)
                    .gesture(DragGesture()
                        .onChanged { value in
                            isDragging = true
                            let x = max(min(value.location.x, size.width), 0)
                            let midY = (size.height - 1) / 2
                            position = CGPoint(x: x, y: midY)
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                    )
                    .onTapGesture { location in
                        let midY = (size.height - 1) / 2
                        position = CGPoint(x: location.x, y: midY)
                        updateLevel(position: position)
                    }
                
                KnobView(color: $color)
                    .position(position)
                
                if let initial {
                    initialCircle(initial)
                }
            }
            .readSize { size in
                self.size = size
            }
            .overlay(content: {
                Text(coordinate.text(value: level))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background {
                        Capsule()
                            .fill(.ultraThinMaterial)
                    }
                    .padding(.top, -80)
                    .position(position)
                    .opacity(isDragging ? 1 : 0)
            })
            .onAppear {
                updatePosition(level: level)
            }
            .frame(height: 24)
            .padding(.horizontal, 12)
            .onChange(of: level) { _, newLevel in
                guard !isDragging else { return }
                updatePosition(level: newLevel)
            }
            .onChange(of: position) { _, newPosition in
                guard isDragging else { return }
                updateLevel(position: newPosition)
            }
            .sensoryFeedback(.selection, trigger: triggerVibration)
        }
    }
    
    private func updateLevel(position: CGPoint) {
        let newLevel = max(min(position.x / size.width, size.width), 0)
        
        if let initial, newLevel.isEqual(value: initial, accuracy: 0.009) {
            level = initial
            updatePosition(level: level)
            triggerVibration.toggle()
        } else if level != newLevel {
            level = newLevel
        }
    }
    
    private func updatePosition(level: Double) {
        let x = max(min(level * size.width, size.width), 0)
        let y = size.height / 2
        let newPosition = CGPoint(x: x, y: y)
        
        if newPosition != position {
            position = newPosition
        }
    }
    
    private func initialCircle(_ initial: Double) -> some View {
        let midY = (size.height - 1) / 2
        let initialX = max(min(initial * size.width, size.width), 0)
        return Circle()
            .fill(.regularMaterial)
            .frame(height: 5)
            .position(x: initialX, y: midY)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var color: Color = .gray
        @State private var level: Double = 0.5
        @State private var gradient: LinearGradient = .linearGradient(colors: [Color.white, Color.black], startPoint: .leading, endPoint: .trailing)
        
        var body: some View {
            GradientSliderView(
                text: "Label",
                color: $color,
                level: $level, 
                initial: level,
                gradient: $gradient,
                coordinate: .normal)
        }
    }
    
    return PreviewWrapper()
}
