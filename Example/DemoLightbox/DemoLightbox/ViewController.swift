import UIKit
import Lightbox

class ViewController: UIViewController {
  
  lazy var showButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(showLightbox), for: .touchUpInside)
    button.setTitle("Show me the lightbox", for: UIControl.State())
    button.setTitleColor(UIColor(red:0.47, green:0.6, blue:0.13, alpha:1), for: UIControl.State())
    button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 30)
    button.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 100)
    button.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
    
    return button
  }()

  lazy var presentButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(presentViewController), for: .touchUpInside)
    button.setTitle("Present view controller", for: UIControl.State())
    button.setTitleColor(UIColor(red:58/255, green:52/255, blue:235/255, alpha:1), for: UIControl.State())
    button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 30)
    button.frame = CGRect(x: 0, y: 160, width: UIScreen.main.bounds.width, height: 100)
    button.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]

    return button
  }()
    
  lazy var dismissButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    button.setTitle("Dismiss view controller", for: UIControl.State())
    button.setTitleColor(UIColor(red:235/255, green:73/255, blue:52/255, alpha:1), for: UIControl.State())
    button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 30)
    button.frame = CGRect(x: 0, y: 280, width: UIScreen.main.bounds.width, height: 100)
    button.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
    button.isHidden = !self.isBeingPresented
    return button
  }()
    
  var images: [LightboxImage] = [
    LightboxImage(imageURL: URL(string: "https://static.remove.bg/sample-gallery/graphics/bird-thumbnail.jpg")!),
    LightboxImage(
      image: UIImage(named: "photo1")!,
      text: "Photography is the science, art, application and practice of creating durable images by recording light or other electromagnetic radiation, either electronically by means of an image sensor, or chemically by means of a light-sensitive material such as photographic film"
    ),
    LightboxImage(
      image: UIImage(named: "photo2")!,
      text: "Emoji 😍 (/ɪˈmoʊdʒi/; singular emoji, plural emoji or emojis;[4] from the Japanese 絵文字えもじ, pronounced [emodʑi]) are ideograms and smileys used in electronic messages and web pages. Emoji are used much like emoticons and exist in various genres, including facial expressions, common objects, places and types of weather 🌅☔️💦, and animals 🐶🐱",
      videoURL: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
    ),
    LightboxImage(
      image: UIImage(named: "photo3")!,
      text: "A lightbox is a translucent surface illuminated from behind, used for situations where a shape laid upon the surface needs to be seen with high contrast."
    )
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
    view.backgroundColor = UIColor.white
    view.addSubview(showButton)
    view.addSubview(presentButton)
    view.addSubview(dismissButton)
  }
  
  // MARK: - Action methods

  @objc func presentViewController() {
    let controller = ViewController()
    self.present(controller, animated: true, completion: nil)
  }
    
  @objc func dismissViewController() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func showLightbox() {
    LightboxConfig.isEnableEditInfo = true
    LightboxConfig.DeleteButton.enabled = true
    
    let controller = LightboxController(images: images)
    controller.imageActionDelegate = self
    controller.dynamicBackground = true
    
    present(controller, animated: true, completion: nil)
  }
}

extension ViewController: LightboxControllerActionDelegate {
  func lightboxController(_ controller: LightboxController, didTouch image: LightboxImage, at index: Int) {
    print("Touch image at index", index)
  }

  func lightboxController(_ controller: LightboxController, didDelete image: LightboxImage, at index: Int) {
    self.images.remove(at: index)
  }
    
  func lightboxController(_ controller: LightboxController, didSaveChanged images: [LightboxImage]) {
    self.images = images
  }
}
