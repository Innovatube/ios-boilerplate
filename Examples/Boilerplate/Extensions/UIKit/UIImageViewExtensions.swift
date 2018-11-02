import UIKit
import PINRemoteImage

public extension UIImageView {
    /// Make image view blurry
    public func blur(withStyle style: UIBlurEffect.Style = .light) {
		let blurEffect = UIBlurEffect(style: style)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(blurEffectView)
		clipsToBounds = true
	}

    /// Blurred version of an image view
    public func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
		let imgView = self
		imgView.blur(withStyle: style)
		return imgView
	}

    /// Async set image from url string
    public func pin_setImage(_ urlString: String?, placeholderImage: UIImage? = nil, completion: ((_ image: UIImage?) -> Void)? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            completion?(placeholderImage)

            return
        }

        pin_setImage(from: url, placeholderImage: placeholderImage, completion: { result in
            completion?(result.image)
        })

    }

    /*
     * thanks to:
     * https://stackoverflow.com/questions/34962103/how-to-set-uiimageview-with-rounded-corners-for-aspect-fit-mode
     */
    /// make imageview rounded cornder
    public func roundCornersForAspectFit(_ corners: UIRectCorner, radius: CGFloat) {

        guard let image = self.image else { return }

        let boundsScale = self.bounds.size.width / self.bounds.size.height
        let imageScale = image.size.width / image.size.height

        var drawingRect: CGRect = self.bounds

        if boundsScale > imageScale {
            drawingRect.size.width = drawingRect.size.height * imageScale
            drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
        } else {
            drawingRect.size.height = drawingRect.size.width / imageScale
            drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
        }

        let maskPath = UIBezierPath(
            roundedRect: drawingRect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        layer.masksToBounds = true
    }

    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.2
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }

    func imageFrame() -> CGRect {
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else { return CGRect.zero }
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height

        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        } else {
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }

}
