//
//  SlideViewController.swift
//  Swirl
//
//  Created by shani herskowitz on 4/25/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController {
    
    
    @IBOutlet weak var ExitButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setButtonCol(color: UIColor) {
        ExitButton.tintColor = color
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Action
    @IBAction func Exit(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInSettingsMode = presentingViewController is UINavigationController
        if isPresentingInSettingsMode {
            _ = navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The SlideViewController is not inside a navigation controller.")
        }
    }

    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
            
    }*/
    

}
