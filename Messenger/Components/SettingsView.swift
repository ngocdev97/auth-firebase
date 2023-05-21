//
//  SettingsView.swift
//  Messenger
//
//  Created by Ngọc Lê on 01/05/2023.
//

import SwiftUI

struct SettingsView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}
