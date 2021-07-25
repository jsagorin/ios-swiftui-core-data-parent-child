//
//  AddEditChildItemView.swift
//  ParentChildExample
//
//  Created by Jonny Sagorin on 24/7/21.
//

import SwiftUI

struct AddEditChildItemView: View {
    
    @State var title = ""
    @State var subTitle = ""
    
    let onComplete: (Bool, String, String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Child Item title", text: $title)
                }
                Section(header: Text("Sub-title")) {
                    TextField("Child Item sub-title", text: $subTitle)
                }
                
                Section {
                }
            }
            .navigationBarTitle(Text("Add/Edit Child Item"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onComplete(
                            true,
                            self.title,
                            self.subTitle
                        )
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        onComplete(
                            false,
                            self.title,
                            self.subTitle
                        )
                    }
                }
                
            }
            
        }
    }
}
