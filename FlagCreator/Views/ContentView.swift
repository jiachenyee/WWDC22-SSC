import SwiftUI

struct ContentView: View {
    
    @Binding var stage: Stage
    @Binding var flagWidth: CGFloat
    
    var namespace: Namespace.ID
    
    @ObservedObject var codingViewModel: CodingViewModel
    
    @State private var isDragging = false
    @State private var separatorTranslation = CGSize.zero
    
    @State private var windowingState: WindowingState = .splitScreen
    @State private var windowControlHidden = false
    
    @State private var windowOverlayOpacity = 1.0
    
    var body: some View {
        GeometryReader { context in
            ZStack {
                HStack(spacing: 0) {
                    if windowingState != .previewFullScreen {
                        ZStack(alignment: .bottomTrailing) {
                            CodingView(codingViewModel: codingViewModel)
                                .frame(maxWidth: .infinity)
                            
                            if windowingState == .editorFullScreen {
                                Button {
                                    withAnimation {
                                        windowingState = .splitScreen
                                        separatorTranslation = .zero
                                        windowControlHidden = false
                                    }
                                } label: {
                                    Label("Show Preview", systemImage: "rectangle.lefthalf.inset.filled.arrow.left")
                                        .padding()
                                        .padding(.horizontal)
                                        .background(Color(UIColor.systemGray5))
                                        .cornerRadius(.infinity)
                                }
                                .padding()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                        .edgesIgnoringSafeArea(.vertical)
                    
                    if windowingState != .editorFullScreen {
                        ZStack(alignment: .bottomLeading) {
                            FlagPreviewView(stage: $stage, namespace: namespace, code: codingViewModel.code, flagWidth: context.size.width / 2 - 32)
                                .onAppear {
                                    flagWidth = context.size.width / 2 - 32
                                }
                            
                            if windowingState == .previewFullScreen {
                                Button {
                                    withAnimation {
                                        windowingState = .splitScreen
                                        separatorTranslation = .zero
                                        windowControlHidden = false
                                    }
                                } label: {
                                    Label("Show Editor", systemImage: "rectangle.righthalf.inset.filled.arrow.right")
                                        .padding()
                                        .padding(.horizontal)
                                        .background(Color(UIColor.systemGray5))
                                        .cornerRadius(.infinity)
                                }
                                .padding()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                InspectorView(codingViewModel: codingViewModel)
                
                if isDragging {
                    WindowManagerOverlayView(separatorTranslation: separatorTranslation)
                        .opacity(windowOverlayOpacity)
                }
                
                if !windowControlHidden {
                    Button {} label: {
                        ZStack {
                            Color.clear
                            if isDragging {
                                Rectangle()
                                    .fill(Color.accentColor)
                                    .frame(width: 1)
                                    .edgesIgnoringSafeArea(.vertical)
                            }
                            
                            RoundedRectangle(cornerRadius: .infinity)
                                .fill(Color(.systemGray6))
                                .frame(width: 4, height: 32)
                            
                            RoundedRectangle(cornerRadius: .infinity)
                                .stroke(.black, lineWidth: 0.2)
                                .frame(width: 4, height: 32)
                        }
                    }
                    .frame(width: 16)
                    .offset(separatorTranslation)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { value in
                                separatorTranslation = .init(width: value.translation.width, height: 0)
                                if !isDragging {
                                    withAnimation {
                                        isDragging = true
                                    }
                                }
                            }
                            .onEnded { value in
                                let endWidth = value.predictedEndTranslation.width
                                
                                withAnimation {
                                    windowOverlayOpacity = 0
                                    if abs(endWidth) < context.size.width / 4 {
                                        separatorTranslation = .zero
                                        windowingState = .splitScreen
                                    } else if endWidth > 0 {
                                        windowingState = .editorFullScreen
                                        separatorTranslation = .init(width: context.size.width / 2, height: 0)
                                    } else {
                                        windowingState = .previewFullScreen
                                        separatorTranslation = .init(width: -context.size.width / 2, height: 0)
                                    }
                                }
                                
                                withAnimation(.default.delay(0.5)) {
                                    if !(abs(endWidth) < context.size.width / 4) {
                                        windowControlHidden = true
                                    }
                                }
                                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                    isDragging = false
                                    windowOverlayOpacity = 1
                                }
                            }
                    )
                }
            }
        }
    }
}
