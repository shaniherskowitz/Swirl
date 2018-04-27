//
//  SettingsViewController.swift
//  Swirl
//
//  Created by shani herskowitz on 4/21/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit
import os.log
import MediaPlayer
struct MyVars {
    static var color = #colorLiteral(red: 0.8876394629, green: 0.8746395111, blue: 0.932209909, alpha: 1)
    static var place = 0.5
    static var buttonColor = #colorLiteral(red: 0.7460694505, green: 0.7181759783, blue: 0.8385317326, alpha: 1)
    static var buttonPlace = 0.5
    static var defStars = 5
    static var songName = "Pick Song"
    static var song = MPMediaItem()
}
class SettingsViewController: UIViewController, MPMediaPickerControllerDelegate {

    // MARK: - Properties
    @IBOutlet var collection:[UIView]!
    @IBOutlet weak var StackColors: UIStackView!
    @IBOutlet weak var Picker: UISlider!
    @IBOutlet weak var ButtonPicker: UISlider!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var SyncButton: UIButton!
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    @IBOutlet weak var StarRating: RatingControl!
    @IBOutlet weak var SongButton: UIButton!
    
    var song = MyVars.song
    var col = MyVars.color
    var buttonCol = MyVars.buttonColor
    var sync = false
    let colorArray = [#colorLiteral(red: 0.67848593, green: 0.5901497602, blue: 0.9901251197, alpha: 1), #colorLiteral(red: 0.9645789266, green: 0.8025702834, blue: 0.994476974, alpha: 1), #colorLiteral(red: 0.9998914599, green: 0.8554207683, blue: 0.9163454175, alpha: 1), #colorLiteral(red: 0.8716116548, green: 0.9851936698, blue: 0.9872644544, alpha: 1), #colorLiteral(red: 0.8496355414, green: 0.9836058021, blue: 0.9109491706, alpha: 1), #colorLiteral(red: 0.9052079916, green: 0.9809301496, blue: 0.8580376506, alpha: 1), #colorLiteral(red: 0.9764305949, green: 0.9857117534, blue: 0.8770399094, alpha: 1), #colorLiteral(red: 0.9866647124, green: 0.9405094981, blue: 0.8692091107, alpha: 1), #colorLiteral(red: 0.9872114062, green: 0.884912312, blue: 0.8421584964, alpha: 1), #colorLiteral(red: 0.9887855649, green: 0.8703537583, blue: 0.8981595635, alpha: 1)]
    let buttonColArray = [#colorLiteral(red: 0.4879775047, green: 0.4232813418, blue: 0.7206217051, alpha: 1), #colorLiteral(red: 0.698769033, green: 0.5876532197, blue: 0.7277633548, alpha: 1), #colorLiteral(red: 0.830937922, green: 0.7101039886, blue: 0.7636486888, alpha: 1), #colorLiteral(red: 0.7348586917, green: 0.838427484, blue: 0.8380393386, alpha: 1), #colorLiteral(red: 0.7202938199, green: 0.8385317326, blue: 0.777898252, alpha: 1), #colorLiteral(red: 0.7741094232, green: 0.8386674523, blue: 0.7384451032, alpha: 1), #colorLiteral(red: 0.8025484681, green: 0.8211108446, blue: 0.7348414063, alpha: 1), #colorLiteral(red: 0.8866294026, green: 0.849240005, blue: 0.7920871377, alpha: 1), #colorLiteral(red: 0.8308131099, green: 0.7535746694, blue: 0.7131528258, alpha: 1), #colorLiteral(red: 0.7742635608, green: 0.691902101, blue: 0.7095698118, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyVars.color
        Picker.thumbTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ButtonPicker.thumbTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        for box in collection {
            box.layer.borderWidth = 0.5
            box.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        Picker.value = Float(MyVars.place)
        ButtonPicker.value = Float(MyVars.buttonPlace)
        SaveButton.tintColor = MyVars.buttonColor
        CancelButton.tintColor = MyVars.buttonColor
        StarRating.rating = MyVars.defStars
        SongButton.setTitle(MyVars.songName, for: UIControlState.normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Actions
    @IBAction func ChooseSongFromLibrary(_ sender: UIButton) {
        let myMediaPickerVC = MPMediaPickerController(mediaTypes: MPMediaType.music)
        myMediaPickerVC.allowsPickingMultipleItems = false
        myMediaPickerVC.popoverPresentationController?.sourceView = sender
        myMediaPickerVC.delegate = self
        self.present(myMediaPickerVC, animated: true, completion: nil)
        
    }
    
    @IBAction func ColorPicker(_ sender: UISlider) {
        if sync {ButtonPicker.value = Picker.value}
        let x = Int(Picker.value*10)
        if x < 10 {
            Picker.thumbTintColor = colorArray[x]
            
        }
        
    }
    @IBAction func ButtonColorPicker(_ sender: UISlider) {
        if sync {Picker.value = ButtonPicker.value}
        let x = Int(ButtonPicker.value*10)
        if x < 10 {
            ButtonPicker.thumbTintColor = buttonColArray[x]
            SaveButton.tintColor = buttonColArray[x].darker(by: 23)
            CancelButton.tintColor = buttonColArray[x].darker(by: 23)
        }
        
    }
    @IBAction func SyncSlidersButton(_ sender: UIButton) {
        if(!sync) {
            SyncButton.setTitle("Unsync Sliders",for: .normal)
            Picker.value = ButtonPicker.value
            sync = true
        } else {
            SyncButton.setTitle("Sync Sliders",for: .normal)
            sync = false
        }
        
    }
    // Mark: - Media
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // Instantiate a new music player
        let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
        myMediaPlayer.setQueue(with: mediaItemCollection)
        
        SongButton.setTitle(mediaItemCollection.items[0].title, for: UIControlState.normal)
        MyVars.songName = mediaItemCollection.items[0].title!
        mediaPicker.dismiss(animated: true, completion: nil)
        song = mediaItemCollection.items[0]
        //myMediaPlayer.play()
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === SaveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        Save();
    }
    
    private func Save() {
        if Picker.value >= 1 {
            Picker.value = 0.99999
        }
        MyVars.color = colorArray[Int(Picker.value*10)]
        MyVars.place = Double(Picker.value)
        col = MyVars.color
        if ButtonPicker.value >= 1 {
            ButtonPicker.value = 0.99999
        }
        MyVars.buttonColor = buttonColArray[Int(ButtonPicker.value*10)]
        MyVars.buttonPlace = Double(ButtonPicker.value)
        buttonCol = MyVars.buttonColor
        MyVars.defStars = StarRating.rating
        MyVars.song = song
        
    }
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInSettingsMode = presentingViewController is UINavigationController
        if isPresentingInSettingsMode {
            _ = navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The SettingsViewController is not inside a navigation controller.")
        }
    }
    
    // MARK: Autoroate configuration
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
}
