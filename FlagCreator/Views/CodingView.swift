import SwiftUI
import UniformTypeIdentifiers

struct CodingView: View {
    
    @State var selectedOption: Int = 0
    
    @ObservedObject var codingViewModel: CodingViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("""
**Use SwiftUI to design a flag**
Tap the \(Image(systemName: "plus")) button in the navigation bar to add elements. Drag the indicator in the centre to show the editor or preview in full screen and customize `View`s with the floating *Attributes Inspector*.

**Layout with Stacks**
In SwiftUI, our UI is reflected directly in our code. This means the first thing on the screen is often the first thing shown, at the top, then going down.

What if we want to lay things out horizontally, or back-to-front? Introducing three different stacks:
    - \(Image(systemName: "square.split.1x2")) `VStack`, for vertical stacking
    - \(Image(systemName: "square.split.2x1")) `HStack`, for horizontal stacking
    - \(Image(systemName: "square.stack")) `ZStack`, for back-to-front (z-axis) stacking
These stacks can be customized with parameters to change properties such as their `alignment` and `spacing`.

**Customizing Views**
Make use of the *Attributes Inspector* (the floating window), to customize your Views.

To make our individual Views look better, we can add View Modifiers (or just modifiers). These are additional pieces of formatting and functionality “tacked on” to each View. To add modifiers into your code, select the View to edit and in the *Attributes Inspector*, select the \(Image(systemName: "paintbrush")).
""")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    Divider()
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach($codingViewModel.code) { $code in
                                HStack {
                                    CodeView(selectedCode: $codingViewModel.selectedCode,
                                             code: $code, codingViewModel: codingViewModel)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding(4)
                        .padding()
                    }
                }
            }
            .navigationTitle("Design a Flag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NewCodeBlockMenuView { codeBlock in
                        let newCode = Code(codeBlock: codeBlock)
                        
                        withAnimation {
                            codingViewModel.code[0].closure?.append(newCode)
                            codingViewModel.selectedCode = newCode
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct CodingView_Previews: PreviewProvider {
    static var previews: some View {
        CodingView(codingViewModel: CodingViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
