//
//  BodyPropertiesPreview.swift
//  FoodVision
//
//  Created by Nikita Efimov on 3/4/25.
//

import SwiftUI

struct BodyPropertiesPreview: View {
    @Binding var selectedGender: String?
    @State var height: CGFloat = 178
    @State var weight: CGFloat = 70
    
    var figure: Image {
        Image(systemName: selectedGender == "Male" ? "figure.stand" : "figure.stand.dress")
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                HStack {
                    Text("\(Int(height)) cm")
                        .font(.title)
                        .fontWeight(.bold)
                    figure
                        .resizable()
                        .scaledToFit()
                        .opacity(1)
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("\(Int(weight)) kg")
                                        .font(.title)
                                        .fontWeight(.bold)
                }
                
            }
        }
        .frame(width: 200, height: 200)
        
    }
}

struct BodyPropertiesPreview_Previews: PreviewProvider {
    static var previews: some View {
        BodyPropertiesPreview(selectedGender: .constant("Male"), height: 178, weight: 70)
    }
}
