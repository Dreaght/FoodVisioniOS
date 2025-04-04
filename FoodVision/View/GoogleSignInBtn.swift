import SwiftUI

struct GoogleSignInBtn: View {
    var action: () -> Void
    
    var body: some View {
           Button {
               action()
           } label: {
               ZStack{
                   RoundedRectangle(cornerRadius: 10)
                       .foregroundColor(.white)
                       .frame(width: 250, height: 50)
                       .shadow(color: .gray, radius: 4, x: 0, y: 2)
                   HStack{
                       Image("googleLogo")
                           .resizable()
                           .scaledToFit()
                           .frame(width: 30, height: 30)
                           .padding(8)
                           .mask(Circle())
                       Spacer()
                       Text("Sign in with Google")
                           .foregroundColor(.black)
                           .fontWeight(.medium)
                           .frame(maxWidth: .infinity, alignment: .center)
                   }.padding(.horizontal)
            
               }
               
           }
           .frame(width: 250, height: 50)
       }
   }

#Preview {
    GoogleSignInBtn(action: {
        print("button pressed")
    })
}
