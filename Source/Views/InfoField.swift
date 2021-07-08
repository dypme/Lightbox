// Reference KMPlaceholderTextView
// Source: https://github.com/MoZhouqi/KMPlaceholderTextView

import UIKit

public protocol InfoFieldDelegate: class {

  func infoFieldDidChange(_ infoField: InfoField)
}

open class InfoField: UITextView {

    weak var infoDelegate: InfoFieldDelegate?
    
    static let defaultiOSPlaceholderColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .systemGray3
        }
        
        return UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    }()
    
    public let placeholderLabel: UILabel = UILabel()
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    open var placeholder: String = "Add a caption..." {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    open override var text: String! {
        didSet {
            textDidChange()
            configureLayout()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    public init(text: String) {
        super.init(frame: .zero, textContainer: nil)
        
        self.text = text
        self.backgroundColor = .clear
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 14)
        self.returnKeyType = .done
        self.delegate = self
        
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let notificationName = UITextView.textDidChangeNotification
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: notificationName,
                                               object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = InfoField.defaultiOSPlaceholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
                                                            options: [],
                                                            metrics: nil,
                                                            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
                                                         options: [],
                                                         metrics: nil,
                                                         views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .greaterThanOrEqual,
            toItem: placeholderLabel,
            attribute: .height,
            multiplier: 1.0,
            constant: textContainerInset.top + textContainerInset.bottom
        ))
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
        
        infoDelegate?.infoFieldDidChange(self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        let notificationName = UITextView.textDidChangeNotification
        NotificationCenter.default.removeObserver(self,
                                                  name: notificationName,
                                                  object: nil)
    }
    
}

// MARK: - LayoutConfigurable

extension InfoField: LayoutConfigurable {
    func configureLayout() {
        self.frame.size.height = self.contentSize.height
    }
}

extension InfoField: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
