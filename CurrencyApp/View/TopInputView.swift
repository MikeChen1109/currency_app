//
//  TopInputView.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import UIKit
import Combine
import CombineCocoa

class TopInputView: UIView {
    private let amountTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.textColor = .black
        textField.accessibilityIdentifier = "amountTextField"
        return textField
    }()
    
    private let currencyPickerField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.textAlignment = .left
        textField.textColor = .black
        textField.tintColor = .clear
        textField.text = DefaultCurrency
        textField.accessibilityIdentifier = "currencyPickerField"
        return textField
    }()
    
    var currencies = [DefaultCurrency]
    private let pickerView = UIPickerView()
    private let amountSubject = CurrentValueSubject<Double, Never>(.init(DefaultAmount))
    private let currencySubject = CurrentValueSubject<String, Never>(.init(DefaultCurrency))
    
    var amountPublisher: AnyPublisher<Double, Never> {
        return amountSubject.eraseToAnyPublisher()
    }
    
    var currencyPublisher: AnyPublisher<String, Never> {
        return currencySubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupInputView()
        setupPickerField()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInputView() {
        addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    private func setupPickerField() {
        addSubview(currencyPickerField)
        currencyPickerField.snp.makeConstraints { make in
            make.top.equalTo(self.amountTextField.snp.bottom).offset(15)
            make.width.equalTo(120)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(50)
        }
        pickerView.accessibilityIdentifier = "currencyPickerView"
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyPickerField.delegate = self
        currencyPickerField.inputView = pickerView
        let arrowImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        arrowImageView.tintColor = UIColor.black
        currencyPickerField.rightView = arrowImageView
        currencyPickerField.rightViewMode = .always
    }
    
    private func observe() {
        amountTextField.textPublisher
            .compactMap { $0?.doubleValue }
            .sink { [weak self] amount in
                self?.amountSubject.send(amount)
            }
            .store(in: &cancellables)
        
        currencyPickerField.textPublisher
            .sink { [weak self] currency in
                self?.currencySubject.send(currency ?? "USD")
            }
            .store(in: &cancellables)
    }
}

extension TopInputView: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyPickerField.text = currencies[row]
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Specify the number of components in the picker view
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count // Return the number of rows in the picker view
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerView.selectRow(0, inComponent: 0, animated: false) // Select the first row by default
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.reloadAllComponents() // Reload the picker view when the text field is tapped
        return true
    }
}


