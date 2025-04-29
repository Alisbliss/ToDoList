//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 25.03.2025.
//

import UIKit
//TODO: - Move to separate protocols class

/* NewTaskDelegate links the NewTaskVewController and the NewTaskModalView. It helps the NewTaskViewController know when to dismiss when x button tapped on the NewTaskModalView and to present an error alert when a user enters invalid input  */
protocol NewTaskDelegate: AnyObject {
    /// Dismiss the NewTaskViewController. Called when x button tapped on NewTaskModalVew
    func closeView()
    /* This presents an error allert when the user enters invalid input.
     - Parameters:
       - title. This is the title of the error alert
       - message. The short description of what went wrong.
     */
    func presentErrorAlert(title: String, message: String)
}

/// This class is responsible for creating or editing a task
class NewTaskViewController: UIViewController {
    lazy var modalView: NewTaskModalView = {
        let modalWidth = view.frame.width - CGFloat(30)
        let modalHeight: CGFloat = 430
        let frame = CGRect(x: 15, y: view.center.y - (modalWidth / 2), width: modalWidth, height: modalHeight)
        let modalView = NewTaskModalView(frame: frame, task: task)
        modalView.delegate = self
        return modalView
    }()
    
    private var task: Task?
    /* This creates the NewTaskViewController
    - Parameters:
      - task. If the task being edditing, task should be passed. If a new task is being created, task should be nil.
    - Reterns: NewTaskViewController with a NewTaskModalView for the user to edit or create a task.
     
     
     */
    init(task: Task? = nil) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        modalView.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.addSubview(modalView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: [.curveEaseOut]) {
            self.modalView.transform = CGAffineTransform.identity
        }
    }

   
  
}

// MARK: - Conformance to New Task Delegate
extension NewTaskViewController: NewTaskDelegate {
    func closeView() {
        dismiss(animated: true)
    }
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
