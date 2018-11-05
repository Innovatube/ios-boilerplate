import UIKit

public extension UILabel {

    public var isTruncated: Bool {

        guard let labelText = text else {
            return false
        }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }

    public func numberOflines(fitWidth: CGFloat, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> Int {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]

        guard let text = text else { return 0 }

        let fitSize = CGSize(width: fitWidth, height: CGFloat(MAXFLOAT))
        let rect = (text as NSString).boundingRect(with: fitSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let lines = rect.height / font.lineHeight

        return Int(lines.rounded(.up))
    }
}

//set tap gesture
public extension UITapGestureRecognizer {

    public func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString(string: ""))

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let xTextContenter = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
        let yTextContenter = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let textContainerOffset = CGPoint(x: xTextContenter, y: yTextContenter)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
