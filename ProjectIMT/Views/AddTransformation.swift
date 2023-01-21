//
//  AddCustomerView.swift
//  ProjectIMT
//
//  Created by Maël Trouillet on 08/01/2022.
//

import SwiftUI

struct AddTransformation: View {
    @State var showAddTransformationAlert: Bool = true
    @State var transformationNameToAdd: String? = ""
    
    var body: some View {
        HStack {
            Text(transformationNameToAdd!)
        }
        .textFieldAlert(isPresented: $showAddTransformationAlert) { () -> TextFieldAlert in
                            TextFieldAlert(title: "Alert Title", message: "Alert Message", text: $transformationNameToAdd)
        }
    }
}



struct AddCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransformation().environmentObject(CustomerData())
    }
}
