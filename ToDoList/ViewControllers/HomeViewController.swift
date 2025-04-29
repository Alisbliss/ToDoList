//
//  ViewController.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 20.03.2025.
//

import UIKit
import os
import RealmSwift
/// The first screen you see when the app lounches. This is when you see all tasks. And this is the starting point for adding or editing a task. Tasks can only be delated from here.
class HomeViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = []
    let realm = try! Realm()
    
    // We create the button programmatically because we cannot add the batton as a subview of a table view in the interface builder.
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.link
        button.tintColor = UIColor.white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        // We change the scale of the image view to make the size of the plus image bigger.
        button.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotifications()
        let localTasks = realm.objects(LocalTask.self)
        for localTask in localTasks {
            let task = Task(id: localTask._id, catagory: localTask.catagory, caption: localTask.caption, createdData: localTask.createdDate, isComplited: localTask.isComplited)
            tasks.append(task)
        }
        tableView.reloadData()
    }
    
    private func setupView() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 24
        titleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(addButton)
    }
    
    /// We setup observars to watch the notifications when a new task is created and when the task is edited.
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(createTask(_:)), name: NSNotification.Name("com.fullstacktuts.createTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editTask(_:)), name: NSNotification.Name("com.fullstacktuts.editTask"), object: nil)
    }
    /* This responds to a task that has been edited from the NewTaskViewController. The notification object holds a userInfo object with the task that needs to be apdated
     - Parameters:
         - notification. Notification object from the 'com.fullstacktuts.editTask" notofication.
     */
    @objc func editTask(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let updatedTask = userInfo["updateTask"] as? Task else {
            return
        }
        let taskIndex = tasks.firstIndex { task in
            task.id == updatedTask.id
        }
        guard let taskIndex = taskIndex else {
            return
        }
        tasks[taskIndex] = updatedTask
        tableView.reloadData()
        if let localTaskToEdit = realm.object(ofType: LocalTask.self, forPrimaryKey: updatedTask.id) {
            do {
                try realm.write {
                    localTaskToEdit.caption = updatedTask.caption
                    localTaskToEdit.catagory = updatedTask.catagory
                    localTaskToEdit.isComplited = updatedTask.isComplited
                
                }
            } catch let error as NSError {
                let errorText = error.localizedDescription
                os_log("%@", type: .error, errorText)
        }
        }
    }
    
    /* This responds to a task that has been created from the NewTaskViewController. The notification object holds a userInfo object with the task that needs to be created
     - Parameters:
         - notification. Notification object from the "com.fullstacktuts.createTask" notofication.
     */    @objc func createTask(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let task = userInfo["newTask"] as? Task else {
            return
        }
         
        tasks.append(task)
        tableView.reloadData()
        let localTask = LocalTask()
         localTask._id = task.id
         localTask.caption = task.caption
         localTask.createdDate = task.createdData
         localTask.catagory = task.catagory
         localTask.isComplited = task.isComplited
         
         do {
             try realm.write {
                 realm.add(localTask)
             }
             } catch let error as NSError {
                 let errorText = error.localizedDescription
                 os_log("%@", type: .error, errorText)
         }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaBottom = view.safeAreaInsets.bottom
        let width: CGFloat = 60
        let height: CGFloat = 60
        let XPos = view.frame.width / 2 - width / 2
        let YPos = view.frame.height - height - safeAreaBottom
        addButton.frame = CGRect(x: XPos, y: YPos, width: width, height: height)
        addButton.layer.cornerRadius = width / 2
    }
    
    @objc func addButtonTapped() {
        let newTaskViewController = NewTaskViewController()
        present(newTaskViewController, animated: true)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        os_log("Everything is working fine", type: .info)
        performSegue(withIdentifier: "SettingsSegue", sender: nil)
    }
    

}

//MARK: Methods conforming to UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifire, for: indexPath) as! TaskTableViewCell
        cell.configure(with: task, delegate: self)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            if let localTaskToDelete = realm.object(ofType: LocalTask.self, forPrimaryKey: taskToDelete.id) {
                do { try realm.write {
                    realm.delete(localTaskToDelete)
                }
                    
                } catch let error as NSError {
                    let errorText = error.localizedDescription
                    os_log("%@", type: .error, errorText)
            }
            }
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
extension HomeViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let task = tasks[indexPath.row]
//        let newTaskViewController = NewTaskViewController(task: task)
//        present(newTaskViewController, animated: true)    }
}

//MARK: Methods conforming to TaskTableViewCellDelegate
extension HomeViewController: TaskTableViewCellDelegate {
    func editTask(id: String) {
        let task = tasks.first
        {task in task.id == id
        }
        guard let task = task else {
            return
        }
        let newTaskViewController = NewTaskViewController(task: task)
        present(newTaskViewController, animated: true)
    }
    
    func compliteTask(id: String, complite: Bool) {
        let taskIndex = tasks.firstIndex
        {task in task.id == id
        }
        guard let taskIndex = taskIndex else {
            return
        }
        tasks[taskIndex].isComplited = complite
        tableView.reloadData()
        
    }
    
    
}
