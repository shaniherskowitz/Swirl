//
//  SlideViewController.swift
//  Swirl
//
//  Created by shani herskowitz on 4/25/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit
import MediaPlayer

struct vars2 {
    static var isOpen = true
}
class SlideViewController: UIViewController {
    
    
    @IBOutlet weak var PhotoRating: RatingControl!
    @IBOutlet weak var PhotoName: UILabel!
    @IBOutlet weak var ExitButton: UIBarButtonItem!
    @IBOutlet weak var ImageView: UIImageView!
    var images = [Image]()
    var song =  MPMediaItem()
    var rating = 0
    let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            self.slideImages(imageView: self.ImageView)
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
            
        }
        vars2.isOpen = true
        
        // Do any additional setup after loading the view.
    }
    
    func setImages(pics: [Image]) {
        images = pics
    }
    func setButtonCol(color: UIColor) {
        ExitButton.tintColor = color
    }
    func slideImages(imageView: UIImageView) {
        images = loadImages()!
        if images.isEmpty {return}
        var run = true
        var tran = 0
        while run {
            DispatchQueue.main.async {
                if vars2.isOpen == false {run = false}
            }
            for image in images {
                if image.rating <= rating {
                    DispatchQueue.main.async {
                        if vars2.isOpen == false {run = false}
                        tran = self.photoTransition(num: tran, image: image)
                        UIView.transition(with: self.PhotoName, duration:1, options: .transitionCrossDissolve,
                                          animations: { self.PhotoName.text = image.name }, completion: nil)
                        UIView.transition(with: self.PhotoRating, duration:1, options: .transitionCrossDissolve,
                                          animations: { self.PhotoRating.rating = image.rating }, completion: nil)
                    }
                    if !run {break}
                    sleep(3)
                }
            }
        }
        images.removeAll()
        
        
    }
    func photoTransition(num: Int, image: Image) -> Int  {
        var res = num
        if res == 4 {res = 0}
        switch res {
        case 0:
            UIView.transition(with: self.ImageView, duration:1, options: .transitionFlipFromLeft,
                              animations: { self.ImageView.image = image.photo }, completion: nil)
        case 1:
            UIView.transition(with: self.ImageView, duration:1, options: .transitionFlipFromTop,
                              animations: { self.ImageView.image = image.photo }, completion: nil)
        case 2:
            UIView.transition(with: self.ImageView, duration:1, options: .transitionFlipFromRight,
                              animations: { self.ImageView.image = image.photo }, completion: nil)
        case 3:
            UIView.transition(with: self.ImageView, duration:1, options: .transitionFlipFromBottom,
                              animations: { self.ImageView.image = image.photo }, completion: nil)
        default:
            print("error in transition")
        }
        res = res + 1
        return res
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
        vars2.isOpen = false
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
    // MARK: Autoroate configuration
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
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
