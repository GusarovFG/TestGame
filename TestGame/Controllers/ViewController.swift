//
//  ViewController.swift
//  TestGame
//
//  Created by Фаддей Гусаров on 01.04.2022.
//
import SnapKit
import UIKit

class ViewController: UIViewController {
    
    var drinks:[Drink]?
    var buttons: [GradientButton] = []
    var textField = UITextField()
    var buttonGrid = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        
        let offset: CGFloat = 8
        
        self.view.addSubview(self.buttonGrid)
        self.buttonGrid.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(50)
            make.bottom.equalTo(250)
        }
        
        self.textField = self.createTextField()
        self.view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(200)
            make.size.equalTo(CGSize(width: 300, height: 30))
        }
        
        NetworkManager.shared.getDrinks { response in
            
            self.drinks = response.drinks
            
            for i in 0..<(self.drinks?.count ?? 1) {
                
                let button = self.createButton(button: self.drinks?[i].strDrink ?? "")
                
                if self.buttonGrid.subviews.isEmpty {
                    button.setTitle(self.drinks?[i].strDrink, for: .normal)
                    self.buttonGrid.addSubview(button)
                    
                    button.snp.makeConstraints { make in
                        make.left.equalToSuperview().inset(offset)
                        make.top.equalToSuperview().inset(offset)
                    }
                } else {
                    self.buttonGrid.addSubview(button)
                    
                    button.setTitle(self.drinks?[i].strDrink, for: .normal)
                    button.snp.makeConstraints { make in
                        make.top.equalToSuperview().inset(offset)
                        make.left.equalTo(self.buttons[i - 1].snp_rightMargin).offset(offset * 2)
                    }
                }
            }
        }
    }
    
    private func createButton(button text: String) -> UIButton {
        
        let button = GradientButton(type: .system)
        
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 39, height: 200))
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.minimumScaleFactor = 1
        button.titleLabel?.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        self.buttons.append(button)
        
        return button
    }
    
    @objc func buttonTapped(_ sender: GradientButton) {
        print(sender.layer.sublayers?.count)
        sender.changeColor()
        sender.removeGradient()
        print(sender.layer.sublayers?.count)
    }
    
    private func createTextField() -> UITextField {
        let textField = UITextField()
        
        textField.placeholder = "Coctail name"
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = false
        textField.layer.shadowOffset = CGSize(width: 0, height: 5)
        textField.layer.shadowRadius = 10
        textField.layer.shadowOpacity = 0.5
        textField.backgroundColor = .systemGray5
        textField.textAlignment = .center
        
        textField.addTarget(self, action: #selector(findSimilarCoctails), for: .editingChanged)
        
        return textField
    }
    
    @objc func findSimilarCoctails(_ sender: UITextField) {
        for i in self.buttons {
            if ((sender.text?.isEmpty) != nil) {
                i.removeGradient()
            }
            guard let str = i.titleLabel?.text else { return }
            if str.contains(sender.text ?? "") && ((sender.text?.isEmpty) != nil) {
                i.changeColor()
            } else {
                i.removeGradient()
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue.height
        
        textField.snp.updateConstraints { make in
            make.left.equalToSuperview()
            make.right.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(keyboardFrame)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        textField.snp.updateConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(200)
            make.size.equalTo(CGSize(width: 300, height: 30))
        }
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
}
