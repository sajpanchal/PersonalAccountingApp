//
//  DailyExpensesViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-29.
//

import UIKit
import CoreData
class DailyExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dateString: String?
    var item: Expense?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Expense]?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyExpenseTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
           
        }
        // Do any additional setup after loading the view.
    }
    //this method loads whenever our view is about to be appear.

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [self] in
            fetchData()
            self.dateLabel.text = self.dateString ?? ""
           
            self.totalAmountLabel.text = "Day's Total: $" + String(format: "%.2f",(self.item?.totalAmount ?? 0.0))
            self.dailyExpenseTableView.delegate = self
            self.dailyExpenseTableView.dataSource = self
            self.dailyExpenseTableView.rowHeight = 70
            self.dailyExpenseTableView.reloadData()
        }
        
    }
    
    func fetchData() {
        //this method will call fetchRequest() of our Person Entity and will return all Person objects back.
        do {
            print("hello from daily expenses")
            var request = NSFetchRequest<NSFetchRequestResult>()
            request = Expense.fetchRequest()
            request.returnsObjectsAsFaults = false
            self.items = try context.fetch(request) as! [Expense]
            
        }
        catch {
            print("error")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addExpenses = segue.destination as! AddExpensesVIewController
        addExpenses.dateString = dateString
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        item?.descriptions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyExpense", for: indexPath) as! DailyExpenseTableViewCell
        cell.descriptionLabel.text = item!.descriptions![indexPath.row]
        cell.amountLabel.text = "$"+String(item!.amounts![indexPath.row])
        return cell
    }
    //delete a given row from table view.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self]_,_,_ in
        
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            for i in 0..<(self.items?.count)! {
                if formatter.string(from: (self.items?[i].date)!) == dateString {
                    if self.items?[i].descriptions != nil {
                        if self.items?[i].descriptions![indexPath.row] == self.item?.descriptions![indexPath.row] && self.items?[i].amounts![indexPath.row] == self.item?.amounts![indexPath.row] {
                            self.items?[i].totalAmount -= (self.items?[i].amounts![indexPath.row])!
                            self.items?[i].descriptions?.remove(at: indexPath.row)
                            self.items?[i].amounts?.remove(at: indexPath.row)
                            DispatchQueue.main.async {
                                self.totalAmountLabel.text = "Day's Total: $" + String(format: "%.2f",(self.items?[i].totalAmount ?? 0.0))
                            }
                       
                        }
                    }
                }
                else {
                    continue
                }
                
                
                
                
            }
            do {
            try self.context.save()
            }
            catch{
                
            }
            self.fetchData()
          
            self.dailyExpenseTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
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
