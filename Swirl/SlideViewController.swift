//
//  SlideViewController.swift
//  Swirl
//
//  Created by shani herskowitz on 4/25/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit
import MediaPlayer
class SlideViewController: UIViewController {
    
    
    @IBOutlet weak var ExitButton: UIBarButtonItem!
    @IBOutlet weak var ImageView: UIImageView!
    var images = [Image]()
    var song =  MPMediaItem()
    let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = loadImages()!
        DispatchQueue.global(qos: .background).async {
            self.slideImages(imageView: self.ImageView)
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setButtonCol(color: UIColor) {
        ExitButton.tintColor = color
    }
    func slideImages(imageView: UIImageView) {
        while myMediaPlayer.nowPlayingItem != nil {
            
            for image in images {
                DispatchQueue.main.async {
                    UIView.transition(with: imageView,
                                      duration:0.5,
                                      options: .transitionCrossDissolve,
                                      animations: { imageView.image = image.photo },
                                      completion: nil)

                }
                sleep(3)
            
            }
        }
        
    }
    func setSong(song: MPMediaItem) {
        myMediaPlayer.setQueue(with: MPMediaItemCollection.init(items: [song]))
        myMediaPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Action
    @IBAction func Exit(_ sender: UIBarButtonItem) {
        myMediaPlayer.stop()
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
    
    private func loadImages() -> [Image]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Image.ArchiveURL.path) as? [Image]
    }

    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
            
    }*/
    

}
