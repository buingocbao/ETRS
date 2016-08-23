//
//  ProfileTableViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/28/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    let currentUser = User.currentUser()
    
    @IBOutlet weak var avatarImageView: PFImageView!
    
    private let kTableHeaderHeight: CGFloat = 300
    var headerView: UIView!
    
    private let kTableHeaderCutAway:CGFloat = 80
    var headerMaskLayer:CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        //configAvatarButton()
        configAvatarView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func configTableView() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.MKColor.Blue
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        
        updateHeaderView()
    }
    
    func configAvatarView() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.image = UIImage(named: "Avatar")
        avatarImageView.file = currentUser!.Avatar
        avatarImageView.loadInBackground { (image, error) -> Void in
            if error == nil {
                print("Image downloaded successfully")
                self.avatarImageView.image = image
            }
        }
        avatarImageView.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("avatarTapped"))
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func avatarTapped() {
        print("Image Tapped")
    }
    
    func updateHeaderView() {
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + kTableHeaderCutAway/2
        }
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height-kTableHeaderCutAway))
        headerMaskLayer?.path = path.CGPath
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileTableViewCell

        // Configure the cell...
        cell.backgroundColor = UIColor.MKColor.Blue
        cell.titleLB.textColor = UIColor.MKColor.Yellow
        cell.detailLB.textColor = UIColor.whiteColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.userInteractionEnabled = false
        switch indexPath.row {
        case 0:
            cell.titleLB.text = checkLanguage("account")
            cell.detailLB.text = currentUser?.username
            cell.imageIcon.image = UIImage(named: "Account")
        case 1:
            cell.titleLB.text = checkLanguage("fullname")
            cell.detailLB.text = currentUser!.FirstName + " " + currentUser!.LastName
            cell.imageIcon.image = UIImage(named: "Name")
        case 2:
            cell.titleLB.text = checkLanguage("group")
            cell.detailLB.text = currentUser?.Group
            cell.imageIcon.image = UIImage(named: "Group")
        case 3:
            cell.titleLB.text = checkLanguage("supervisor")
            cell.detailLB.text = "..."
            if let supervisorObject = currentUser?.Supervisor {
                print(supervisorObject)
                let query = User.query()
                query?.getObjectInBackgroundWithId(supervisorObject.objectId!, block: { (object, error) -> Void in
                    if error == nil {
                        let supervisor = object as? User
                        cell.detailLB.text = supervisor!.FirstName + " " + supervisor!.LastName
                    }
                })
            }
            cell.imageIcon.image = UIImage(named: "Supervisor")
        case 4:
            cell.titleLB.text = checkLanguage("email_verified")
            cell.detailLB.text = String(currentUser!.emailVerified).uppercaseString
            cell.imageIcon.image = UIImage(named: "EmailVerified")
        case 5:
            cell.titleLB.text = checkLanguage("password")
            cell.detailLB.text = checkLanguage("swipe_left_to_change") + " " + checkLanguage("password")
            cell.imageIcon.image = UIImage(named: "Password")
            cell.userInteractionEnabled = true
        case 6:
            cell.titleLB.text = checkLanguage("log_out")
            cell.detailLB.text = checkLanguage("swipe_left_to") + " " + checkLanguage("log_out")
            cell.imageIcon.image = UIImage(named: "Logout")
            cell.userInteractionEnabled = true
        case 7:
            cell.userInteractionEnabled = true
            cell.titleLB.text = checkLanguage("language")
            cell.imageIcon.image = UIImage(named: "Language")
            let defaults = NSUserDefaults.standardUserDefaults()
            if let lg = defaults.stringForKey("Language"){
                switch lg {
                case "vi":
                    cell.detailLB.text = "Tiếng Việt"
                case "ja":
                    cell.detailLB.text = "日本語"
                case "en":
                    cell.detailLB.text = "English"
                default:
                    break
                }
            }
        case 8:
            cell.titleLB.text = ""
            cell.detailLB.text = ""
        default:
            cell.titleLB.text = "User name"
            cell.detailLB.text = currentUser?.username
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100
        case 5:
            return 100
        default:
            return 70
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        switch indexPath.row {
        case 5:
            let editAction = UITableViewRowAction(style: .Default, title: checkLanguage("edit")) { (action, indexPath) -> Void in
                print("Edit password Touched")
                self.showPopupWithTransitionStyle(STPopupTransitionStyle.SlideVertical, rootViewController: ChangePasswordViewController(nibName: nil, bundle: nil))
            }
            editAction.backgroundColor = UIColor.MKColor.Grey
            
            return [editAction]
        case 6:
            let logoutAction = UITableViewRowAction(style: .Default, title: checkLanguage("log_out")) { (action, indexPath) -> Void in
                print("Log out Touched")
                self.view.userInteractionEnabled = false
                let activityTypes: NVActivityIndicatorType = .BallTrianglePath
                let frame = self.view.frame
                let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                    type: activityTypes)
                activityIndicatorView.center = self.view.center
                self.view.addSubview(activityIndicatorView)
                activityIndicatorView.startAnimation()
                PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
                    if error == nil {
                        activityIndicatorView.removeFromSuperview()
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                        self.presentViewController(loginVC, animated: true, completion: nil)
                    }
                })
            }
            logoutAction.backgroundColor = UIColor.MKColor.Red
            
            return [logoutAction]
        case 7:
            let editAction = UITableViewRowAction(style: .Default, title: checkLanguage("edit")) { (action, indexPath) -> Void in
                print("Edit language Touched")
                self.showPopupWithTransitionStyle(STPopupTransitionStyle.SlideVertical, rootViewController: ChangeLanguageViewController(nibName: nil, bundle: nil))
            }
            editAction.backgroundColor = UIColor.MKColor.Grey
            
            return [editAction]
        default:
            return .None
        }
    }
    
    func showPopupWithTransitionStyle(transitionStyle: STPopupTransitionStyle, rootViewController: UIViewController) {
        let popupController = STPopupController(rootViewController: rootViewController)
        popupController.cornerRadius = 4
        popupController.transitionStyle = transitionStyle
        popupController.presentInViewController(self)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Other methods
    func checkLanguage(key: String) -> String {
        //Get language setting
        let defaults = NSUserDefaults.standardUserDefaults()
        var language = "en"
        if let lg = defaults.stringForKey("Language"){
            language = lg
        }
        let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
        let bundle = NSBundle(path: path!)
        let string = bundle?.localizedStringForKey(key, value: nil, table: nil)
        return string!
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension ProfileTableViewController  {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
}
