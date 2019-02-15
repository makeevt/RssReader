
import Foundation
import UIKit

protocol ImageTarget: class {
    func startImageLoading(urlPath: String)
    func stopImageLoading()
}
