//
//  SettingsViewController.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 14.04.2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var appThemeLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        modalView.layer.cornerRadius = 5
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let window = UIApplication.shared.connectedScenes.flatMap({($0 as? UIWindowScene)?.windows ?? []}).first { $0.isKeyWindow }
        if sender.selectedSegmentIndex == 0 {
            window?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        } else if sender.selectedSegmentIndex == 1 {
            window?.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        } else {
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    

}
