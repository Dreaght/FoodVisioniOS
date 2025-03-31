import Foundation
import UIKit

extension UIImage {    
    func toData(compressionQuality: CGFloat = 1.0) -> Data? {
        return self.jpegData(compressionQuality: compressionQuality)
    }
    
    func toPNGData() -> Data? {
        return self.pngData()
    }
}
