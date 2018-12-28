import UIKit

extension UIButton {

	typealias UIButtonTargetClosure = (UIButton) -> ()

	class ClosureWrapper: NSObject {
		let closure: UIButtonTargetClosure
		init(_ closure: @escaping UIButtonTargetClosure) {
			self.closure = closure
		}
	}

    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
	func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
		addTarget(self, action: #selector(closureAction), for: .touchUpInside)
    }
    
	@objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}

extension Button {

	typealias ButtonTargetClosure = (Button) -> ()

	class ClosureWrapper: NSObject {
		let closure: ButtonTargetClosure
		init(_ closure: @escaping ButtonTargetClosure) {
			self.closure = closure
		}
	}

	private struct AssociatedKeys {
		static var targetClosure = "targetClosure"
	}

	private var targetClosure: ButtonTargetClosure? {
		get {
			guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
			return closureWrapper.closure
		}
		set(newValue) {
			guard let newValue = newValue else { return }
			objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	func addTargetClosure(closure: @escaping ButtonTargetClosure) {
		targetClosure = closure
		addClick(self, action: #selector(closureAction))
	}

	@objc func closureAction() {
		guard let targetClosure = targetClosure else { return }
		targetClosure(self)
	}
}

extension UITapGestureRecognizer {

	typealias UITapGestureRecognizerTargetClosure = (UITapGestureRecognizer) -> ()

	class ClosureWrapper: NSObject {
		let closure: UITapGestureRecognizerTargetClosure
		init(_ closure: @escaping UITapGestureRecognizerTargetClosure) {
			self.closure = closure
		}
	}

	private struct AssociatedKeys {
		static var targetClosure = "targetClosure"
	}

	private var targetClosure: UITapGestureRecognizerTargetClosure? {
		get {
			guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
			return closureWrapper.closure
		}
		set(newValue) {
			guard let newValue = newValue else { return }
			objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	func addTargetClosure(closure: @escaping UITapGestureRecognizerTargetClosure) {
		targetClosure = closure
		addTarget(self, action: #selector(closureAction))
	}

	@objc func closureAction() {
		guard let targetClosure = targetClosure else { return }
		targetClosure(self)
	}
}
