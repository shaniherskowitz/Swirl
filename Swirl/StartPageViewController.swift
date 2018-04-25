//
//  StartPageViewController.swift
//  Swirl
//
//  Created by shani herskowitz on 4/19/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit
import MediaPlayer
struct vars {
    static var backgroundColor = #colorLiteral(red: 0.8374265085, green: 0.7951553631, blue: 1, alpha: 1)
    static var buttonColor = #colorLiteral(red: 0.8374265085, green: 0.7951553631, blue: 1, alpha: 1).darker()
}

class StartPageViewController: UIViewController {
    
    @IBOutlet var collection:[UIButton]!
    
    var ratingsForSlide = 0
    var song = MPMediaItem()
    
    @IBOutlet weak var MenuLabel: UILabel!
    // MARK: - Actions
    
    @IBAction func ImagesButton(_ sender: UIButton) {
        
    }
    @IBAction func SlideButton(_ sender: UIButton) {
        //updateButtonText()
        let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
        myMediaPlayer.setQueue(with: MPMediaItemCollection.init(items: [song]))
        myMediaPlayer.play()
    }
    
    @IBAction func SettingsButton(_ sender: UIButton) {
       
    }
    @IBAction func unwindToStartPage(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SettingsViewController {
            let backgroundColor = sourceViewController.col
            vars.buttonColor = sourceViewController.buttonCol
            self.view.backgroundColor = backgroundColor
            vars.backgroundColor = backgroundColor
            ratingsForSlide = sourceViewController.StarRating.rating
            song = sourceViewController.song
        }
        updateButtonText()
        MenuLabel.textColor = vars.backgroundColor.darker()
           
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonText()
        MenuLabel.textColor = vars.backgroundColor.darker()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateButtonText() {
        for button in collection {
            button.backgroundColor = vars.backgroundColor.lighter()
            //button.titleLabel?.textColor =  vars.buttonColor
            button.setTitleColor(vars.buttonColor, for: UIControlState.normal)
        }
    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowDetail") {
            let vc = segue.destination as! UINavigationController
            let nextViewController = vc.viewControllers[0] as! ImageTableViewController
            nextViewController.backgroundCol = vars.backgroundColor
            nextViewController.buttonCol = vars.buttonColor!
        }
       
        
    }
    
    // MARK: Autoroate configuration
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    

}
