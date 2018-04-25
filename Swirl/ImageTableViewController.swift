//
//  ImageTableViewController.swift
//  Swirl
//
//  Created by shani herskowitz on 4/15/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit
import os.log
class ImageTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var images = [Image]()
    var backgroundCol = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    var buttonCol = #colorLiteral(red: 0.678948597, green: 0.5924711366, blue: 1, alpha: 1)
    
    @IBOutlet weak var menuButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedImages = loadImages() {
            images += savedImages
        } else {
            // Load the sample data.
            loadSampleImages()
        }
        self.editButtonItem.tintColor = buttonCol
        menuButtonItem.tintColor = buttonCol
        addButtonItem.tintColor = buttonCol

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: Autoroate configuration
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ImageViewController, let image = sourceViewController.image {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing image.
                images[selectedIndexPath.row] = image
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new image.
                let newIndexPath = IndexPath(row: images.count, section: 0)
                
                images.append(image)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the images.
            saveImages()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ImageTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ImageTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let image = images[indexPath.row]
        
        cell.ImageLabel.text = image.name
        cell.photoImageView.image = image.photo
        cell.RatingsControl.rating = image.rating
        
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            images.remove(at: indexPath.row)
            saveImages()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        self.editButtonItem.tintColor = buttonCol
        
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

   /* @IBAction func BackToMenu(_ sender: UIBarButtonItem) {
            // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
            let isPresentingInImageTableMode = presentingViewController is UINavigationController
            if isPresentingInImageTableMode {
                dismiss(animated: true, completion: nil)
            } else if let owningNavigationController = navigationController {
                owningNavigationController.popViewController(animated: true)
            } else {
                fatalError("The ImageTableViewController is not inside a navigation controller.")
            }
        
    }*/
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            let vc = segue.destination as! UINavigationController
            let nextViewController = vc.viewControllers[0] as! ImageViewController
            nextViewController.view.backgroundColor = backgroundCol
            nextViewController.setButtonColors(buttonCol: buttonCol)
            
            os_log("Adding a new Image.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let ImageDetailViewController = segue.destination as? ImageViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? ImageTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedImage = images[indexPath.row]
            ImageDetailViewController.image = selectedImage
            ImageDetailViewController.view.backgroundColor = backgroundCol
            ImageDetailViewController.setButtonColors(buttonCol: buttonCol)
        
        case "Menu":
            os_log("Going back to main menu.", log: OSLog.default, type: .debug)
            
        case "Settings":
            os_log("Going to settings.", log: OSLog.default, type: .debug)
            
        default:
            guard let button = sender as? UIBarButtonItem, button === menuButtonItem else {
                os_log("The menu button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }
            //fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Private Methods
    
    private func saveImages() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(images, toFile: Image.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Images successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Images...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSampleImages() {
        let photo1 = UIImage(named: "meal")
        let photo2 = UIImage(named: "dog")
        let photo3 = UIImage(named: "beach")
        
        guard let meal = Image(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let dog = Image(name: "beach doggy", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let beach = Image(name: "beach pic", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        images += [meal, dog, beach]

    }
    
    private func loadImages() -> [Image]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Image.ArchiveURL.path) as? [Image]
    }
    
    
    
    

}
