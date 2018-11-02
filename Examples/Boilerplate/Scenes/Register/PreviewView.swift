import UIKit
import AVFoundation

class PreviewView: UIView, UIGestureRecognizerDelegate {
    private enum ControlCorner {
        case none
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.opacity = 0.6
        layer.addSublayer(maskLayer)
        regionOfInterestOutline.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).cgPath
        regionOfInterestOutline.fillColor = UIColor.clear.cgColor
        regionOfInterestOutline.strokeColor = UIColor.primary?.cgColor
        layer.addSublayer(regionOfInterestOutline)
    }

    // MARK: AV capture properties
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }

        return layer
    }

    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }

        set {
            videoPreviewLayer.session = newValue
        }
    }

    // MARK: Region of Interest

    private let regionOfInterestCornerTouchThreshold: CGFloat = 50

    /**
     The minimum region of interest's size cannot be smaller than the corner
     touch threshold as to avoid control selection conflicts when a user tries
     to resize the region of interest.
     */
    private var minimumRegionOfInterestSize: CGFloat {
        return regionOfInterestCornerTouchThreshold
    }

    private let regionOfInterestControlDiameter: CGFloat = 12.0

    private var regionOfInterestControlRadius: CGFloat {
        return regionOfInterestControlDiameter / 2.0
    }

    private let maskLayer = CAShapeLayer()

    private let regionOfInterestOutline = CAShapeLayer()

    /**
     Saves a reference to the control corner that the user is using to resize
     the region of interest in `resizeRegionOfInterestWithGestureRecognizer()`.
     */
    private var currentControlCorner: ControlCorner = .none

    /**
     This property is set only in `setRegionOfInterestWithProposedRegionOfInterest()`.
     When a user is resizing the region of interest in `resizeRegionOfInterestWithGestureRecognizer()`,
     the KVO notification will be triggered when the resizing is finished.
     */
    @objc private(set) var regionOfInterest = CGRect.null

    /**
     Updates the region of interest with a proposed region of interest ensuring
     the new region of interest is within the bounds of the video preview. When
     a new region of interest is set, the region of interest is redrawn.
     */
    func setRegionOfInterestWithProposedRegionOfInterest(_ proposedRegionOfInterest: CGRect) {
        // We standardize to ensure we have positive widths and heights with an origin at the top left.
        let videoPreviewRect = videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: CGRect(x: 0, y: 0, width: 1, height: 1)).standardized

        /*
         Intersect the video preview view with the view's frame to only get
         the visible portions of the video preview view.
         */
        let visibleVideoPreviewRect = videoPreviewRect.intersection(frame)
        let oldRegionOfInterest = regionOfInterest
        var newRegionOfInterest = proposedRegionOfInterest.standardized

        // Move the region of interest in bounds.
        if currentControlCorner == .none {
            var xOffset: CGFloat = 0
            var yOffset: CGFloat = 0

            if !visibleVideoPreviewRect.contains(newRegionOfInterest.origin) {
                xOffset = max(visibleVideoPreviewRect.minX - newRegionOfInterest.minX, CGFloat(0))
                yOffset = max(visibleVideoPreviewRect.minY - newRegionOfInterest.minY, CGFloat(0))
            }

            if !visibleVideoPreviewRect.contains(CGPoint(x: visibleVideoPreviewRect.maxX, y: visibleVideoPreviewRect.maxY)) {
                xOffset = min(visibleVideoPreviewRect.maxX - newRegionOfInterest.maxX, xOffset)
                yOffset = min(visibleVideoPreviewRect.maxY - newRegionOfInterest.maxY, yOffset)
            }

            newRegionOfInterest = newRegionOfInterest.offsetBy(dx: xOffset, dy: yOffset)
        }

        // Clamp the size when the region of interest is being resized.
        newRegionOfInterest = visibleVideoPreviewRect.intersection(newRegionOfInterest)

        // Fix a minimum width of the region of interest.
        if proposedRegionOfInterest.size.width < minimumRegionOfInterestSize {
            switch currentControlCorner {
            case .topLeft, .bottomLeft:
                newRegionOfInterest.origin.x = oldRegionOfInterest.origin.x + oldRegionOfInterest.size.width - minimumRegionOfInterestSize
                newRegionOfInterest.size.width = minimumRegionOfInterestSize

            case .topRight:
                newRegionOfInterest.origin.x = oldRegionOfInterest.origin.x
                newRegionOfInterest.size.width = minimumRegionOfInterestSize

            default:
                newRegionOfInterest.origin = oldRegionOfInterest.origin
                newRegionOfInterest.size.width = minimumRegionOfInterestSize
            }
        }

        // Fix a minimum height of the region of interest.
        if proposedRegionOfInterest.size.height < minimumRegionOfInterestSize {
            switch currentControlCorner {
            case .topLeft, .topRight:
                newRegionOfInterest.origin.y = oldRegionOfInterest.origin.y + oldRegionOfInterest.size.height - minimumRegionOfInterestSize
                newRegionOfInterest.size.height = minimumRegionOfInterestSize

            case .bottomLeft:
                newRegionOfInterest.origin.y = oldRegionOfInterest.origin.y
                newRegionOfInterest.size.height = minimumRegionOfInterestSize

            default:
                newRegionOfInterest.origin = oldRegionOfInterest.origin
                newRegionOfInterest.size.height = minimumRegionOfInterestSize
            }
        }

        regionOfInterest = newRegionOfInterest
        setNeedsLayout()
    }

    // MARK: UIView
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Disable CoreAnimation actions so that the positions of the sublayers immediately move to their new position.
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        // Create the path for the mask layer. We use the even odd fill rule so that the region of interest does not have a fill color.
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        path.append(UIBezierPath(rect: regionOfInterest))
        path.usesEvenOddFillRule = true
        maskLayer.path = path.cgPath

        regionOfInterestOutline.path = CGPath(rect: regionOfInterest, transform: nil)

        CATransaction.commit()
    }
}
