import Foundation

func getSymbolsFromFile() -> [String] {
    let fileURL = Bundle.main.url(forResource: "SF Symbols", withExtension: "txt")!
    let contents = try! String(contentsOf: fileURL)
    
    return contents.split(separator: "\n").map {
        String($0)
    }
}
