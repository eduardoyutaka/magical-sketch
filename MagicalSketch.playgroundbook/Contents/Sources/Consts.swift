import UIKit

public struct Consts {
    public struct Context {
        public static var lineWidth: CGFloat = 5.0
        public static var strokeColor: UIColor = .gray
    }
    public struct Cursor {
        public static var color: UIColor = .green
    }
    public struct DeviceMotion {
        public static var accelerationThreshold: Double = 1.0
    }
    public struct Dial {
        public static var center = CGPoint(x: diameter / 2, y : diameter / 2)
        public static var diameter: CGFloat = 132.0
    }
    public struct View {
        public static var backgroundColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(1.0))
    }
}
