import UIKit

protocol DialControlDelegate: class {
    func dialControlTouched(_ sender: DialControl, _ atLocation: CGPoint)
    func dialControlChanged(_ sender: DialControl, _ toLocation: CGPoint)
    func dialControlReleased(_ sender: DialControl, _ atLocation: CGPoint)
}

class DialControl: UIControl {
    var offsetAngle: CGFloat = 0.0
    var currentAngle: CGFloat = 0.0
    var backgroundImage: UIImageView!
    weak var delegate: DialControlDelegate?
    
    convenience init(image: UIImage?) {
        self.init()
        self.backgroundImage = UIImageView(image: image)
        self.addSubview(backgroundImage)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            delegate?.dialControlTouched(self, location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            delegate?.dialControlChanged(self, location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            delegate?.dialControlReleased(self, location)
        }
    }
}

class LeftDialControl: DialControl {
    
}

class RightDialControl: DialControl {
    
}
