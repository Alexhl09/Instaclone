//
//  PickerPhotoViewController.swift
//  Instaclone
//
//  Created by alexhl09 on 7/9/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

import UIKit
import YPImagePicker
import Vision
import MaterialComponents
import ActivityBar


class PickerPhotoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    let option = ["Tag people", "Add location", "Facebook", "Twitter", "Tumblr"]
    var activityBar: ActivityBar!

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = option[indexPath.row]
        return cell!
    }
    
  
    @IBOutlet weak var captionView: MDCIntrinsicHeightTextView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageToPost: UIImageView!

    
    
    override func viewDidAppear(_ animated: Bool) {
        
        

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    /**
     Here I prensent a view of a cocoa that is going to create filters and a great camera view
 
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        captionView.delegate = self
        self.activityBar = ActivityBar.addTo(viewController: self)
        self.activityBar.color = UIColor.green
     
        // Do any additional setup after loading the view.
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 3
        config.screens = [.library, .video, .photo]
        config.library.mediaType = .photo
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                self.tabBarController?.selectedIndex = 0;
            }
            for item in items {
                switch item {
                case .photo(let photo):
                    print(photo)
                    self.imageToPost.image = photo.image
                    
                case .video(let video):
                    self.imageToPost.image = video.thumbnail
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: {
                self.captionView.becomeFirstResponder()
            })
            
        }
        present(picker, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.captionView.resignFirstResponder()
    }
    
    /**
 If the user click on share Photo there is going to be an animation until the photo is posted
 */
    @IBAction func sharePhoto(_ sender: Any) {
        self.activityBar.start()
        Post.postUserImage(imageToPost.image, withCaption: captionView.text) { (bool, error) in
            if(error == nil)
            {
                let alert = UIAlertController(title: "Success", message: "Your photo has been uploaded", preferredStyle: .alert)
                let action = UIAlertAction(title: "Accept", style: .cancel, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion:
                    {
                       self.tabBarController?.selectedIndex = 0;
                       

                    
                })
          
            }else
            {
                let alert = UIAlertController(title: "Error", message: "There was an error uploading the photo", preferredStyle: .alert)
                let action = UIAlertAction(title: "Accept", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: {
       
                      self.tabBarController?.selectedIndex = 0;
                })
                
            }
             self.activityBar.stop()
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
