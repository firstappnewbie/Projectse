//
//  homevc.swift
//
//  Created by 3arthzneiz on 5/6/2559 BE.
//  Copyright © 2559 3arthzneiz. All rights reserved.
//

import UIKit
import Parse

class homevc: UICollectionViewController {

    var refresher : UIRefreshControl!
    
    var page : Int = 10
    
    var picArray = [PFFile]()
    var uuidArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .whiteColor()
       
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString

        //pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        loadPost()
    }
    func refresh()
    {
        collectionView?.reloadData()
    }
   func loadPost(){
      let query = PFUser.query()
        query?.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query?.limit = page
        query?.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
        
        if error == nil{
            
            for object in objects!{
                self.uuidArray.append(object.valueForKey("username") as! String)
                self.picArray.append(object.valueForKey("ava1") as! PFFile)
            }
            self.collectionView?.reloadData()
        }
        
        })
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count * 6
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! cellpic
        
        picArray[0].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            if error == nil{
                cell.picImg.image = UIImage(data: data!)
                
            }
            else{
                print(error!.localizedDescription)
            }
        }
        return cell
    }
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath ) as! headervc
        
        header.Fullname.text = (PFUser.currentUser()?.objectForKey("fullname") as? String)?.uppercaseString
        header.webtxt.text = PFUser.currentUser()?.objectForKey("Contact") as? String
        header.webtxt.sizeToFit()
        
        let avaQuery = PFUser.currentUser()?.objectForKey("ava")    as! PFFile
        avaQuery.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            header.avaImg.image = UIImage(data: data!)
            
            
        }
        header.button.setTitle("edit profile", forState: UIControlState.Normal)
        
        let posts = PFUser.query()
        posts?.whereKey("posts", equalTo: PFUser.currentUser()!.username!)
        posts?.countObjectsInBackgroundWithBlock({ (count:Int32, error:NSError?) -> Void in
            if error == nil{
                header.posts.text = "\(count+5)"
            }
        })
        
        let pictures = PFUser.query()
        pictures?.whereKey("pictures", equalTo: PFUser.currentUser()!.username!)
        pictures?.countObjectsInBackgroundWithBlock({ (count:Int32, error:NSError?) -> Void in
            if error == nil{
                header.pictures.text = "\(count+3)"
            }
        })
        
        let followings = PFUser.query()
        followings?.whereKey("followings", equalTo: PFUser.currentUser()!.username!)
        followings?.countObjectsInBackgroundWithBlock({ (count:Int32, error:NSError?) -> Void in
            if error == nil{
                header.followings.text = "\(count+2)"
            }
        })
        return header

    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
