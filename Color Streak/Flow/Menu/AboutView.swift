//
//  AboutView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    
    let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    let mailSupport = URL(string: "mailto:dv.denstr@gmail.com")
    let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any]
    
    let site = URL(string: "https://dendmitriev.github.io/ColorStreak/")
    let privatePolicy = URL(string: "https://dendmitriev.github.io/ColorStreak/privacy_policy/")
    let termsOfService = URL(string: "https://dendmitriev.github.io/ColorStreak/termsofservice/")
    
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    AppIcon()
                        .aspectRatio(1.0, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading) {
                        Text(appName ?? "Color Streak")
                            .font(.title)
                        Text("Version \(appVersion ?? "Empty") (Build \(appBuild ?? "Empty"))")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Link(destination: site!, label: {
                    Text("Site")
                })
                
                Link(destination: privatePolicy!, label: {
                    Text("Private Policy")
                })
                
                Link(destination: termsOfService!, label: {
                    Text("Terms of Service")
                })
            }
            
            Section {
                Link("Email Support", destination: mailSupport!)
                
                Button("Review in App Store") {
                    requestReview()
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(.appBackground)
        .foregroundStyle(.primary)
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
