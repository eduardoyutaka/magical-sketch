import UIKit
import CoreMotion

public class SketchViewController: UIViewController, DialControlDelegate {
    
    // 1. Properties
    let drawingImageView = UIImageView()
    var drawingImage: UIImage?
    let cursor = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: Consts.Context.lineWidth, height: Consts.Context.lineWidth))
    let leftDialControl = LeftDialControl(image: UIImage(named: "dial"))
    let rightDialControl = RightDialControl(image: UIImage(named: "dial"))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // 2. Initialize UI components in view and start shake detection
        // 2.1 - Set the background color
        view.backgroundColor = Consts.View.backgroundColor
        
        // 2.2 - Add title label and apply constraints to it
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SignPainter", size: CGFloat(100.0))
        titleLabel.text = "Magical Sketch"
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: Consts.Dial.diameter / 2).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: Consts.Dial.diameter).isActive = true
        
        // 2.3 - Add drawing area and apply constraints to it
        view.addSubview(drawingImageView)
        drawingImageView.backgroundColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(216.0/255.0), blue: CGFloat(216.0/255.0), alpha: CGFloat(1.0))
        drawingImageView.translatesAutoresizingMaskIntoConstraints = false
        drawingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Consts.Dial.diameter).isActive = true
        drawingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Consts.Dial.diameter).isActive = true
        drawingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Consts.Dial.diameter).isActive = true
        drawingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.Dial.diameter).isActive = true
        
        // 2.4 - Add left dial control and apply constraints to it
        view.addSubview(leftDialControl)
        leftDialControl.delegate = self
        leftDialControl.translatesAutoresizingMaskIntoConstraints = false
        leftDialControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        leftDialControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftDialControl.heightAnchor.constraint(equalToConstant: Consts.Dial.diameter).isActive = true
        leftDialControl.widthAnchor.constraint(equalToConstant: Consts.Dial.diameter).isActive = true
        
        // 2.5 - Add right dial control and apply constraints to it
        view.addSubview(rightDialControl)
        rightDialControl.delegate = self
        rightDialControl.translatesAutoresizingMaskIntoConstraints = false
        rightDialControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rightDialControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rightDialControl.heightAnchor.constraint(equalToConstant: Consts.Dial.diameter).isActive = true
        rightDialControl.widthAnchor.constraint(equalToConstant: Consts.Dial.diameter).isActive = true
        
        // 2.6 - Add cursor and set its color
        drawingImageView.addSubview(cursor)
        cursor.backgroundColor = Consts.Cursor.color
        
        // 2.7 - Start device motion updates
        startDeviceMotionUpdates()
    }
    
    // 3. Delegate methods for custom dial control
    // 3.1 - Update dial control state
    func dialControlTouched(_ sender: DialControl, _ atLocation: CGPoint) {
        sender.offsetAngle += calculateAngle(forLocation: atLocation, andDialCenter: Consts.Dial.center)
        sender.currentAngle = sender.offsetAngle
    }
    
    // 3.2 - Perform all view animations
    func dialControlChanged(_ sender: DialControl, _ toLocation: CGPoint) {
        // 3.2.1 - Calculate parameters
        let dialControlNewAngle = calculateAngle(forLocation: toLocation, andDialCenter: Consts.Dial.center)
        let moveDistance = calculateMoveDistance(fromDialAngle: sender.currentAngle, toDialAngle: dialControlNewAngle)
        
        // 3.2.2 - Animate dial control
        sender.backgroundImage?.transform = CGAffineTransform(rotationAngle: dialControlNewAngle - sender.offsetAngle)
        
        // 3.2.3 - Update dial control state
        sender.currentAngle = dialControlNewAngle
        
        // 3.2.4 - Draw line
        switch type(of: sender) {
        case let dialType where dialType == LeftDialControl.self:
            let newCursorLocation = CGPoint(x: cursor.frame.origin.x + moveDistance, y: cursor.frame.origin.y)
            guard CGRect(x: drawingImageView.bounds.origin.x, y: drawingImageView.bounds.origin.y, width: drawingImageView.bounds.width - Consts.Context.lineWidth, height: drawingImageView.bounds.height - Consts.Context.lineWidth).contains(newCursorLocation) else { return }
            drawLine(fromLocation: cursor.frame.origin, toLocation: newCursorLocation)
            cursor.frame.origin = newCursorLocation
        case let dialType where dialType == RightDialControl.self:
            let newCursorLocation = CGPoint(x: cursor.frame.origin.x, y: cursor.frame.origin.y + moveDistance)
            guard CGRect(x: drawingImageView.bounds.origin.x, y: drawingImageView.bounds.origin.y, width: drawingImageView.bounds.width - Consts.Context.lineWidth, height: drawingImageView.bounds.height - Consts.Context.lineWidth).contains(newCursorLocation) else { return }
            drawLine(fromLocation: cursor.frame.origin, toLocation: newCursorLocation)
            cursor.frame.origin = newCursorLocation
        default:
            break
        }
    }
    
    // 3.3 - Update dial control state
    func dialControlReleased(_ sender: DialControl, _ atLocation: CGPoint) {
        switch type(of: sender) {
        case let dialType where dialType == LeftDialControl.self:
            leftDialControl.offsetAngle -= sender.currentAngle
        case let dialType where dialType == RightDialControl.self:
            rightDialControl.offsetAngle -= sender.currentAngle
        default:
            break
        }
    }
    
    // 4. Helper Methods
    func calculateAngle(forLocation location: CGPoint, andDialCenter dialCenter: CGPoint) -> CGFloat {
        let locationFromDialCenter = CGPoint(x: location.x - dialCenter.x, y: location.y - dialCenter.y)
        var angle: CGFloat = atan(locationFromDialCenter.y / locationFromDialCenter.x)
        switch (locationFromDialCenter.x, locationFromDialCenter.y) {
        case let (x, y) where x < 0 && y != 0:
            angle += CGFloat.pi
        case let (x, y) where x > 0 && y < 0:
            angle += 2 *  CGFloat.pi
        case let (x , 0) where x < 0:
            angle += CGFloat.pi
        case let (0, y) where y < 0:
            angle += 2 * CGFloat.pi
        default:
            break
        }
        return angle
    }
    
    func calculateMoveDistance(fromDialAngle: CGFloat, toDialAngle: CGFloat) -> CGFloat {
        guard abs(toDialAngle - fromDialAngle) < CGFloat.pi else { return 0 }
        return CGFloat(10.0) * (toDialAngle - fromDialAngle)
    }
    
    func drawLine(fromLocation: CGPoint, toLocation: CGPoint) {
        UIGraphicsBeginImageContext(drawingImageView.frame.size)
        drawingImage?.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(Consts.Context.lineWidth)
        context?.setStrokeColor(Consts.Context.strokeColor.cgColor)
        context?.move(to: CGPoint(x: fromLocation.x + Consts.Context.lineWidth / 2, y: fromLocation.y + Consts.Context.lineWidth / 2))
        context?.addLine(to: CGPoint(x: toLocation.x + Consts.Context.lineWidth / 2, y: toLocation.y + Consts.Context.lineWidth / 2))
        context?.strokePath()
        drawingImage = UIGraphicsGetImageFromCurrentImageContext()
        drawingImageView.image = drawingImage
        UIGraphicsEndImageContext()
    }
    
    func startDeviceMotionUpdates() {
        if CMMotionManager.shared.isDeviceMotionAvailable {
            CMMotionManager.shared.startDeviceMotionUpdates(to: .main) { deviceMotion, error in
                guard error == nil, deviceMotion != nil else { return }
                let maxAcceleration = max(deviceMotion!.userAcceleration.x, deviceMotion!.userAcceleration.y, deviceMotion!.userAcceleration.z)
                if maxAcceleration > Consts.DeviceMotion.accelerationThreshold {
                    let alert = UIAlertController(title: "Erase Drawing", message: "Are you sure you want to erase the current drawing?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default, handler: { _ in
                        NSLog("The \"Cancel\" alert occured.")
                    }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Yes"), style: .default, handler: { _ in
                        NSLog("The \"Yes\" alert occured.")
                        self.eraseAll()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func eraseAll() {
        UIGraphicsBeginImageContext(drawingImageView.frame.size)
        drawingImage?.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()
        context?.clear(drawingImageView.bounds)
        drawingImage = UIGraphicsGetImageFromCurrentImageContext()
        drawingImageView.image = drawingImage
        UIGraphicsEndImageContext()
    }
    
    // 5. End of SketchViewController()
}
