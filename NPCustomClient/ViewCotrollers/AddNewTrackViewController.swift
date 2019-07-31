//
//  AddNewTrackViewController.swift
//  NPCustomClient
//
//  Created by Denis Markov on 7/29/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "NewTrackTableViewCell"

protocol AddNewTrackViewControllerDelegate {
    func newTracksAppend()
}

class AddNewTrackViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backToPreviousScreen), for: .touchUpInside)
        }
    }
    @IBOutlet weak var screenTitleLabel: UILabel! {
        didSet {
            screenTitleLabel.text = "Отследить ЭН"
        }
    }
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        }
    }
    @IBOutlet weak var trackNumberLabel: UILabel!
    @IBOutlet weak var trackNumberTextField: UITextField! {
        didSet {
            trackNumberTextField.addTarget(self, action: #selector(textFieldTextDidChanged(_:)),
                                for: UIControl.Event.editingChanged)
            trackNumberTextField.addTarget(self, action: #selector(endEditing), for: .touchUpOutside)
        }
    }
    @IBOutlet weak var cancelEnteringButton: UIButton! {
        didSet {
            cancelEnteringButton.addTarget(self, action: #selector(cancelEnteringButtonDidTap), for: .touchUpInside)
        }
    }
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var trackingButton: UIButton! {
        didSet {
            trackingButton.addTarget(self, action: #selector(trackButtonDidTap), for: .touchUpInside)
        }
    }
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.text = "Такого номера не существует"
        }
    }
    
    let viewModel = AddNewTrackViewModel()
    
    var delegate: AddNewTrackViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tracksTableView.dataSource = self
        tracksTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        trackNumberTextField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        viewModel.trackListChanged = { [weak self] () in
            self?.trackListChanged()
        }
        viewModel.setSanitizeText = { [weak self] () in
            self?.setSanitizeText()
        }
        viewModel.setTrackInvalid = { [weak self] (isValid) in
            self?.setTrackInvalid(isValid: isValid)
        }
        viewModel.backToPreviousScreen = { [weak self] () in
            self?.backToPreviousScreen()
        }
        
    }
    
    func trackListChanged() {
        DispatchQueue.main.async {
            self.trackNumberTextField.text = ""
            self.tracksTableView.reloadData()
        }
    }
    
    func setSanitizeText() {
        DispatchQueue.main.async {
            self.trackNumberTextField.text = self.viewModel.sanitizeText(sourceText: self.trackNumberTextField.text)
        }
    }
    
    func setTrackInvalid(isValid: Bool) {
        DispatchQueue.main.async {
            self.trackNumberTextField.textColor = isValid ? .black : .red
            self.trackNumberTextField.tintColor = isValid ? .black : .red
            self.errorLabel.isHidden = isValid
        }
    }
    
    @objc func textFieldTextDidChanged(_ textField: UITextField) {
        viewModel.processUserInput(text: textField.text)
    }
    
    @objc func cancelEnteringButtonDidTap() {
        self.trackNumberTextField.text = ""
        self.trackNumberTextField.endEditing(false)
        setTrackInvalid(isValid: true)
    }
    
    @objc func clearButtonDidTap() {
        viewModel.clearAll()
    }
    
    @objc func trackButtonDidTap() {
        viewModel.addTracksToTrackingList()
    }
    
    @objc func backToPreviousScreen() {
        if viewModel.trackList.count > 0 {
            delegate?.newTracksAppend()
        }
        let vcs = self.navigationController?.viewControllers
        if ((vcs?.contains(self)) != nil) {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
        self.trackNumberTextField.endEditing(true)
    }
    

}

extension AddNewTrackViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NewTrackTableViewCell
        cell.setData(track: viewModel.dataForCell(indexPath: indexPath))
        cell.delegate = self
        return cell
    }
    
}

extension AddNewTrackViewController: NewTrackTableViewCellDelegate {
    func removeButtonDidTap(track: String) {
        viewModel.removeFromList(track: track)
    }
}

extension AddNewTrackViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= trackLength
    }
}



