import UIKit

protocol HeaderViewDelegate: class {
  func headerView(_ headerView: HeaderView, didPressDeleteButton deleteButton: UIButton)
  func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
}

open class HeaderView: UIView {
    private var title: String? = nil
    
    open fileprivate(set) lazy var titleLabel: UILabel = { [unowned self] in
        let title = NSAttributedString(
            string: self.title ?? "",
            attributes: LightboxConfig.CloseButton.textAttributes)
        
        let label = UILabel()
        label.attributedText = title
        label.sizeToFit()
        
        return label
        }()
    
  open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.CloseButton.text,
      attributes: LightboxConfig.CloseButton.textAttributes)

    let button = UIButton(type: .system)
    button.setAttributedTitle(title, for: UIControl.State())

    var topPadding: CGFloat = 0
    if #available(iOS 11, *) {
        topPadding = UIApplication.shared.keyWindow!.safeAreaInsets.top
    } else {
        topPadding = UIApplication.shared.statusBarFrame.height
    }
    
    if let size = LightboxConfig.CloseButton.size {
        button.frame.size = CGSize(width: size.width, height: size.height + topPadding)
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = LightboxConfig.CloseButton.image {
        button.setImage(image, for: UIControl.State())
//        button.setBackgroundImage(image, for: UIControl.State())
    }

    button.isHidden = !LightboxConfig.CloseButton.enabled

    return button
  }()

  open fileprivate(set) lazy var deleteButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.DeleteButton.text,
      attributes: LightboxConfig.DeleteButton.textAttributes)

    let button = UIButton(type: .system)
    button.setAttributedTitle(title, for: .normal)

    var topPadding: CGFloat = 0
    if #available(iOS 11, *) {
        topPadding = UIApplication.shared.keyWindow!.safeAreaInsets.top
    } else {
        topPadding = UIApplication.shared.statusBarFrame.height
    }
    
    if let size = LightboxConfig.DeleteButton.size {
      button.frame.size = CGSize(width: size.width, height: size.height + topPadding)
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(deleteButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = LightboxConfig.DeleteButton.image {
        button.setBackgroundImage(image, for: UIControl.State())
    }

    button.isHidden = !LightboxConfig.DeleteButton.enabled

    return button
  }()

  weak var delegate: HeaderViewDelegate?

  // MARK: - Initializers

  public init(title: String? = nil) {
    super.init(frame: CGRect.zero)
    self.title = title

    backgroundColor = UIColor.clear

    [titleLabel, closeButton, deleteButton].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func deleteButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressDeleteButton: button)
  }

  @objc func closeButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressCloseButton: button)
  }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {

  @objc public func configureLayout() {
    let topPadding: CGFloat

    if #available(iOS 11, *) {
      topPadding = safeAreaInsets.top
    } else {
      topPadding = 0
    }

    closeButton.frame.origin = CGPoint(
      x: 0,
      y: 0
    )

    deleteButton.frame.origin = CGPoint(
      x: bounds.width - closeButton.frame.width - 17,
      y: topPadding
    )
    
    titleLabel.center.x = center.x
    titleLabel.center.y = closeButton.center.y
  }
}
