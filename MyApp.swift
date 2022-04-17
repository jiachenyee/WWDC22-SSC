import SwiftUI

@main
struct MyApp: App {
    
    @State var stage: Stage = .flagCreator
    @State var flagWidth: CGFloat = 0
    
    @StateObject var codingViewModel = CodingViewModel()
    
    @Namespace var namespace
    
    var body: some Scene {
        WindowGroup {
            switch stage {
            case .flagCreator:
                ContentView(stage: $stage, flagWidth: $flagWidth, namespace: namespace, codingViewModel: codingViewModel)
            case .flagPreview:
                FlagRaisingPreviewView(stage: $stage, namespace: namespace, code: codingViewModel.code, flagWidth: flagWidth)
            case .raiseFlag:
                FlagRaisingView(namespace: namespace, code: codingViewModel.code, flagWidth: flagWidth)
            }
        }
    }
}

enum Stage {
    case flagCreator
    case flagPreview
    case raiseFlag
}
