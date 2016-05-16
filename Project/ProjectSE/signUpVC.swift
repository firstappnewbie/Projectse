//
//  signUpVC.swift
//
//  Created by 3arthzneiz on 3/26/2559 BE.
//  Copyright © 2559 3arthzneiz. All rights reserved.
//
import Parse
import UIKit

class signUpVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatTxt: UITextField!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var braTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
  
    
    //default size
    var scrollViewHeight : CGFloat = 0
    //keyboard framesize
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        scrollView.contentSize.height = self.view.frame.height
        
        scrollViewHeight  = scrollView.frame.size.height

        //print(self.keyboard.height)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        //print(self.keyboard.height)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        print(self.keyboard.height)
        print(self.scrollViewHeight)
        
        
        let hidetap = UITapGestureRecognizer(target: self, action: "hidekeyboardtap:")
        hidetap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hidetap)
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        let avatap = UITapGestureRecognizer(target: self, action: "loadImg:")
        avatap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(avatap)
        
    }
    func loadImg(recognizer:UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func showKeyboard(notification:NSNotification){
       
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!      ////print("asdasd")
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
        
    }
    func hideKeyboard(notification:NSNotification){
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        }
        
    }
    func hidekeyboardtap(recognizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    @IBAction func signUpBtn(sender: AnyObject) {
        print("sign up press")
        //dissmiss keyboard
        self.view.endEditing(true)
        
        
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatTxt.text!.isEmpty ||
            emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || braTxt.text!.isEmpty){
                let alert = UIAlertController(title: "Please", message: "fill all field", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
        }
        if passwordTxt.text != repeatTxt.text {
            let alert = UIAlertController(title: "PASSWORD", message: "do not match", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil )
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let user = PFUser()
        user.username = usernameTxt.text?.lowercaseString
        user.email = emailTxt.text?.lowercaseString
        user.password = passwordTxt.text?.lowercaseString
        user["fullname"] = fullnameTxt.text?.lowercaseString
        user["Contact"] = braTxt.text?.lowercaseString
        user["followings"] = braTxt.text?.lowercaseString

        user["posts"] = braTxt.text?.lowercaseString
        user["pictures"] = braTxt.text?.lowercaseString

       
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaData1 = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        
        let ava1 = PFFile (name: "rcfAEh.gif", data:avaData1!)
        user["ava1"] = ava1
        
        let avafile = PFFile (name: "Screen Shot 2559-03-20 at 20.07.53.png", data:avaData!)
        user["ava"] = avafile
        

        
        
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                print("registered")
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                //call login func
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
                
            }
            else{
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated:true,completion: nil)
            }
        }
        
        
    }
    
    @IBAction func cancelBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
}
