import UIKit

protocol HeaderViewDelegate: AnyObject {
  func headerView(_ headerView: HeaderView, didPressSaveButton saveButton: UIButton)
  func headerView(_ headerView: HeaderView, didPressDeleteButton deleteButton: UIButton)
  func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
}

open class HeaderView: UIView {
  open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.CloseButton.text,
      attributes: LightboxConfig.CloseButton.textAttributes)

    let button = UIButton(type: .system)

    button.setAttributedTitle(title, for: UIControl.State())

    if let size = LightboxConfig.CloseButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = LightboxConfig.CloseButton.image {
        button.setBackgroundImage(image, for: UIControl.State())
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

    if let size = LightboxConfig.DeleteButton.size {
      button.frame.size = size
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
    
  open fileprivate(set) lazy var saveButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.SaveButton.text,
      attributes: LightboxConfig.SaveButton.textAttributes)

    let button = UIButton(type: .system)
    button.setAttributedTitle(title, for: .normal)

    var topPadding: CGFloat = 0
    if #available(iOS 11, *) {
        topPadding = UIApplication.shared.keyWindow!.safeAreaInsets.top
    } else {
        topPadding = UIApplication.shared.statusBarFrame.height
    }
      
    if let size = LightboxConfig.SaveButton.size {
        button.frame.size = CGSize(width: size.width, height: size.height + topPadding)
    } else {
        button.sizeToFit()
    }

    button.addTarget(self, action: #selector(saveButtonDidPress(_:)),
                     for: .touchUpInside)

    if let image = LightboxConfig.SaveButton.image {
        button.setBackgroundImage(image, for: UIControl.State())
    }

    button.isHidden = !LightboxConfig.isEnableEditInfo

    return button
  }()

  weak var delegate: HeaderViewDelegate?

  // MARK: - Initializers

  public init() {
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear

    [closeButton, deleteButton, saveButton].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func saveButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressSaveButton: button)
  }
    
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
      x: 17,
      y: topPadding
    )

    deleteButton.frame.origin = CGPoint(
      x: bounds.width - deleteButton.frame.width - 17 - (LightboxConfig.isEnableEditInfo ? saveButton.frame.width + 17 : 0),
      y: topPadding
    )
    
    saveButton.frame.origin = CGPoint(
      x: bounds.width - saveButton.frame.width - 17,
      y: topPadding
    )
  }
}
