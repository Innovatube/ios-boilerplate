import Foundation
import UIKit

extension UIView {

    enum BorderLine: Int {
        case top, bottom, left, right
    }

    func addInnerBorder(to: BorderLine, thickness: CGFloat, color: UIColor) {
        let border = CALayer()
        var rect: CGRect
        switch to {
        case .top:
            rect = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
        case .bottom:
            rect = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
        case .left:
            rect = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
        case .right:
            rect = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
        }

        border.frame = rect
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }

    // thanks to: https://qiita.com/Hakota/items/8266d0efa7ba6cda25bc
    enum DashedLineType {
        case all, top, bottom, left, right
    }

    func drawDashedLine(color: UIColor, lineWidth: CGFloat, lineSize: NSNumber, spaceSize: NSNumber, type: DashedLineType) {

        let dashedLineLayer: CAShapeLayer = CAShapeLayer()
        dashedLineLayer.frame = self.bounds
        dashedLineLayer.strokeColor = color.cgColor
        dashedLineLayer.lineWidth = lineWidth
        dashedLineLayer.lineDashPattern = [lineSize, spaceSize]
        let path: CGMutablePath = CGMutablePath()

        switch type {

        case .all:
            dashedLineLayer.fillColor = nil
            dashedLineLayer.path = UIBezierPath(rect: dashedLineLayer.frame).cgPath
        case .top:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
            dashedLineLayer.path = path
        case .bottom:
            path.move(to: CGPoint(x: 0, y: self.frame.size.height))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            dashedLineLayer.path = path
        case .right:
            path.move(to: CGPoint(x: self.frame.size.width, y: 0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            dashedLineLayer.path = path
        case .left:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
            dashedLineLayer.path = path
        }
        self.layer.addSublayer(dashedLineLayer)
    }
}
