//
//  UIImageViewExtensions.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit

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
}

#if canImport(PINRemoteImage)
import PINRemoteImage

extension UIImageView {
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
}

#endif
