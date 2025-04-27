//
//  ViewController.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 20.03.2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = []
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.link
        button.tintColor = UIColor.white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        NotificationCenter.default.addObserver(self, selector: #selector(createTask(_:)), name: NSNotification.Name("com.fullstacktuts.createTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editTask(_:)), name: NSNotification.Name("com.fullstacktuts.editTask"), object: nil)
    }
    
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
    }
    
    @objc func createTask(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let task = userInfo["newTask"] as? Task else {
            return
        }
        tasks.append(task)
        tableView.reloadData()
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
        performSegue(withIdentifier: "SettingsSegue", sender: nil)
    }
    

}

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
