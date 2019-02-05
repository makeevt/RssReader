
import Foundation

extension Thread {
    class func do_onMainThread(block: @escaping ()->()) {
        if self.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
