import Foundation

struct Utility {

    static func mainThread(block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }

    static func backgroundThread(block: @escaping () -> Void) {
        DispatchQueue.global().async {
            block()
        }
    }

    static func delay(_ delay: TimeInterval, mainThread: Bool = true, block: @escaping () -> Void) {
        let queue: DispatchQueue
        if mainThread {
            queue = DispatchQueue.main
        } else {
            queue = DispatchQueue.global()
        }
        queue.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }

}
