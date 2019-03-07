import UIKit

struct ZipBuilder {
    static func build(_ vc: ZipViewController) {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = .numberPad
        textField.placeholder = "Zipcode"
        textField.borderStyle = .roundedRect
        vc.view.addSubview(textField)
        textField.constrainToCenter(to: vc.view)
        vc.textField = textField

        let button = UIButton(type: .system)
        button.setTitle("Get Weather", for: .normal)
        vc.view.addSubview(button)
        button.constrainToCenter(to: vc.view, yConstant: 40)
        button.addTarget(vc, action: #selector(vc.weatherTap), for: .touchUpInside)

        let favButton = UIButton(type: .system)
        favButton.setTitle("Favorites", for: .normal)
        vc.view.addSubview(favButton)
        favButton.constrainToCenter(to: vc.view, yConstant: 80)
        favButton.addTarget(vc, action: #selector(vc.favoritesTap(_:)), for: .touchUpInside)
    }
}

extension UIView {

    func constrainToCenter(to parent: UIView, xConstant: CGFloat = 0, yConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: xConstant).isActive = true
        centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: yConstant).isActive = true
    }

}
