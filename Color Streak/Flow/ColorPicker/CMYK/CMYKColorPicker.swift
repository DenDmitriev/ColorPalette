//
//  CMYKColorPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct CMYKColorPicker: View {
    @Binding var color: Color
    @Binding var colorSpace: DeviceColorSpace
    @Binding var controller: PalettePickView.ColorController
    
    @State private var cyan: Double
    @State private var magenta: Double
    @State private var yellow: Double
    @State private var key: Double
    
    private let cyanInitial: Double?
    private let magentaInitial: Double?
    private let yellowInitial: Double?
    private let keyInitial: Double?
    
    init(color: Binding<Color>, initial: Color?, colorSpace: Binding<DeviceColorSpace>, controller: Binding<PalettePickView.ColorController>) {
        self._color = color
        self._colorSpace = colorSpace
        let cmyk = color.wrappedValue.cmyk
        self.cyan = cmyk.cyan
        self.magenta = cmyk.magenta
        self.yellow = cmyk.yellow
        self.key = cmyk.key
        self._controller = controller
        let cmykInitial = initial?.cmyk
        self.cyanInitial = cmykInitial?.cyan
        self.magentaInitial = cmykInitial?.magenta
        self.yellowInitial = cmykInitial?.yellow
        self.keyInitial = cmykInitial?.key
    }
    
    var body: some View {
        VStack(spacing: 14) {
            CMYKCyanPicker(cyan: $cyan, color: $color, initial: cyanInitial)
            CMYKMagentaPicker(magenta: $magenta, color: $color, initial: magentaInitial)
            CMYKYellowPicker(yellow: $yellow, color: $color, initial: yellowInitial)
            CMYKKeyPicker(key: $key, color: $color, initial: keyInitial)
        }
        .onChange(of: color) { _, newColor in
            guard controller != .slider else { return }
            let cmyk = color.cmyk
            self.cyan = cmyk.cyan
            self.magenta = cmyk.magenta
            self.yellow = cmyk.yellow
            self.key = cmyk.key
        }
        .onChange(of: [cyan, magenta, yellow, key]) { _, newValue in
            controller = .slider
            let cyan = newValue[0]
            let magenta = newValue[1]
            let yellow = newValue[2]
            let key = newValue[3]
            
            let cmyk = CMYK(cyan: cyan, magenta: magenta, yellow: yellow, black: key)
            
            color = Color(cmyk: cmyk)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var color: Color = Color(.red)
        @State var controller: PalettePickView.ColorController = .slider
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(color)
                
                CMYKColorPicker(color: $color, initial: color, colorSpace: .constant(.displayP3), controller: $controller)
                    
            }
        }
    }
    return PreviewWrapper()
        .padding()
}
