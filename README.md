# WWDC22 Swift Student Challenge
This app was inspired by my experience developing SwiftUI curriculum for the Swift Accelerator Programme and Infocomm Clubs in Singapore. The idea of a flag raising app started as a joke in 2021 while thinking of ways to engage a virtual class and we incorporated it into the curriculum. This app is designed to be a fun and engaging way to learn SwiftUI.

---

Part 1: Design a Flag

Learn about views and modifiers in SwiftUI by designing a flag with a drag and drop SwiftUI editor. Customize specific Views by selecting it and using the floating Attributes Inspector to add modifiers and parameters. Drag the indicator in the center to make the editor or preview full screen and collapse the Attributes Inspector by pushing it into the edge. When done, select the Continue button.

Part 2: Raise the Flag

Learn about @State variables and the .offset modifier to raise the flag. Fill in the blanks to complete the code and make the flag raise. When all errors have been resolved, the Raise button will be enabled.

Part 3: Success

Tapping on the raise button will raise the flag to the top. When the flag reaches the top, another tap will launch a 3D view of the flag. This will show an animation of the flag spinning while the camera pans around it. At this stage, the user can choose to save the flag to their Photos or view the flag in AR. The user will be able to place the flag in AR and see what the flag will look like on their desk.

---

Technologies used

SwiftUI is used for the majority of the interface, from the drag and drop editor to the animations across the views and even the flag renderer.

UIKit is used to supplement the SwiftUI views and is primarily used within the AR view.

SceneKit is used to create the 3D view when the user raises the flag successfully. 

ARKit is used to convert the 3D flag from the SceneKit view to an AR one, allowing the user to view one on their desk.
