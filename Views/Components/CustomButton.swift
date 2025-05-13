import SwiftUI

struct CustomButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.background)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Save Changes")
            .padding()
    }
}


