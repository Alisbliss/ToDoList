//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 20.03.2025.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func editTask(id: String)
    func compliteTask(id: String, complite: Bool)
}

class TaskTableViewCell: UITableViewCell {
    
    static let identifire = "TaskTableViewCell"
    @IBOutlet weak var catagoryContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isCompliteImageView: UIImageView!
    @IBOutlet weak var stripView: UIView!
    
    private weak var delegate: TaskTableViewCellDelegate?
    private var task: Task!
    
    private var dateFormater: DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        return dateFormater
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        catagoryContainerView.layer.cornerRadius = catagoryContainerView.frame.height / 2
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }
    func configure(with task: Task, delegate: TaskTableViewCellDelegate?) {
        stripView.backgroundColor = task.catagory.color
        categoryLabel.textColor = task.catagory.color
        catagoryContainerView.backgroundColor = task.catagory.secondaryColor
        categoryLabel.text = task.catagory.rawValue
        captionLabel.text = task.caption
        isCompliteImageView.image = task.isComplited ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        dateLabel.text = dateFormater.string(from: task.createdData)
        selectionStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleComplition))
        isCompliteImageView.addGestureRecognizer(tap)
        isCompliteImageView.isUserInteractionEnabled = true
        self.task = task
        self.delegate = delegate
    }
    
    @objc func toggleComplition() {
        task.isComplited.toggle()
        delegate?.compliteTask(id: task.id, complite: task.isComplited)
    }
    

    @IBAction func editTaskButtonTapped(_ sender: Any) {
        delegate?.editTask(id: task.id)
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
