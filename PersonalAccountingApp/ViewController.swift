//
//  ViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITabBarControllerDelegate {
    let dateFormatter: DateFormatter = DateFormatter() // date formater object
    static var showActivtyIndicator = true
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addExpenseBtn: UIButton!
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [Expense] = Expense.fetchRecords()
    
    var activityView = UIActivityIndicatorView(style: .medium)
    var strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 46))
    var effectView = UIVisualEffectView(effect: UIBlurEffect())
    @IBAction func dateUpdated(_ sender: Any) {
        self.items = Expense.fetchRecords()
        dateFormatter.dateFormat = "MMM d, yyyy" //date formatter string
    }
    func activityIndicator(_ title: String) {
        strLabel.removeFromSuperview()
        activityView.removeFromSuperview()
        effectView.removeFromSuperview()
        effectView.alpha = 1.0
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2, width: 250, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        activityView = UIActivityIndicatorView(style: .medium)
        activityView.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityView.startAnimating()
        effectView.contentView.addSubview(activityView)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CKContainer.default().fetchUserRecordID(completionHandler: {
            (recordID, error) in
            if let name = recordID?.recordName {
                print("iCloud ID: ", name)
            }
            else if let error = error {
                print(error.localizedDescription)
            }
        })
       // activityView.center = self.view.center
        if let arrayOfTabBarItems = tabBarController?.tabBar.items {
            for item in arrayOfTabBarItems {
                item.isEnabled = false
            }
        }
       // self.view.addSubview(activityView)
        if Self.showActivtyIndicator {
          //  self.activityView.startAnimating()
            selectedDate.alpha = 0.2
            titleLabel.alpha = 0.2
            addExpenseBtn.alpha = 0.2
            activityIndicator("Syncing data with iCloud...")
            self.view.isUserInteractionEnabled = false
            print("Timer started")
            Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { _ in
                print("Timer stopped")
                self.effectView.removeFromSuperview()
                //self.view.alpha = 1
                self.selectedDate.alpha = 1.0
                self.titleLabel.alpha = 1.0
                self.addExpenseBtn.alpha = 1.0
                self.activityView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                if let arrayOfTabBarItems = self.tabBarController?.tabBar.items {
                    for item in arrayOfTabBarItems {
                        item.isEnabled = true
                    }
                }
            }
        }
       

        tabBarController?.delegate = self
        
        self.items = Expense.fetchRecords()
        for item in self.items {
            print(item.date!)
        }
        dateFormatter.dateFormat = "MMM d, yyyy" //date formatter string
        
        // Do any additional setup after loading the view.
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.items = Expense.fetchRecords()
        
        
       
        if viewController is AddExpensesVIewController{
          
            let addExpenses = viewController as! AddExpensesVIewController
            addExpenses.dateString = dateFormatter.string(from: selectedDate.date)
            addExpenses.date = selectedDate.date
        }
        else if viewController is HistoryViewController {
            
            let history = viewController as! HistoryViewController
            history.expenses = self.items
        }
        else if viewController is DailyExpensesViewController{
          
            let dailyView = viewController as! DailyExpensesViewController
            dailyView.item = nil
            dailyView.dateString = dateFormatter.string(from: selectedDate.date)
            for entry in items {
                let entryDate = dailyView.dateString
                if entryDate == dateFormatter.string(from: entry.date!) {
                    dailyView.item = entry
                    break
                }
                else {
                    
                }
            }
        }
        else {
            
        }
    }
    
   /* func fetchData() {
        //this method will call fetchRequest() of our Person Entity and will return all Person objects back.
        do {
            let request: NSFetchRequest<Expense> = Expense.fetchRequest()
            request.returnsObjectsAsFaults = false
          //  self.items = try context.fetch(request) as! [Expense]
            self.items = try AppDelegate.viewContext.fetch(request)
            
        }
        catch {
            print("error")
        }
        
    }*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this will set the segue's destination prop as a AddExpensesVIewController
        let addExpenses = segue.destination as! AddExpensesVIewController
       
        //storing the date string from this viewcontroller to addExpensesVC's string property.
        //it will then be stored in it and on load of the view of this VC, it will transfer it to Date label.
        addExpenses.dateString = dateFormatter.string(from: selectedDate.date)
        addExpenses.date = selectedDate.date
        if segue.identifier == "tabBarAddExpense" {
            print ("tab bar add expense")
        }
    }
   

}

