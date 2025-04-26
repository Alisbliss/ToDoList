//
//  NewTaskModalView.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 26.03.2025.
//

import UIKit

class NewTaskModalView: UIView {

    
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var catagoryPickerView: UIPickerView!
    
    @IBOutlet weak var submitButton: ShadowButton!
    @IBOutlet private var contentView: UIView!
   
    weak var delegate: NewTaskDelegate?
    private var task: Task?
    
    var caption: String {
        get { return descriptionTextView.text}
        set { descriptionTextView.text = newValue }
    }
    init(frame: CGRect, task: Task?) {
        super.init(frame: frame)
        self.task = task
        initSubviews()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initSubviews()
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "NewTaskModalView", bundle: nil)
        nib.instantiate(withOwner: self)
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8
        
        descriptionTextView.delegate = self
        catagoryPickerView.dataSource = self
        catagoryPickerView.delegate = self
        
        if let task = task {
            descriptionTextView.text = task.caption
            descriptionTextView.textColor = .label
            if let rowIndex = Catagory.allCases.firstIndex(of: task.catagory) {
                catagoryPickerView.selectRow(rowIndex, inComponent: 0, animated: false)
            }
        } else {
            descriptionTextView.text = "Add caption"
            descriptionTextView.textColor = .placeholderText
            catagoryPickerView.selectRow(1, inComponent: 0, animated: false)
        }
        
        contentView.frame = bounds
        addSubview(contentView)
    }

    override func layoutSubviews() {
        contentView.layer.cornerRadius = 5
        submitButton.layer.cornerRadius = 5
    }
//    The awakeFronmNib doesn't work because nib's top level object is connected to the File Owner
//    override func awakeFromNib() {
//        super.awakeFromNib()
//       
//    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let caption = descriptionTextView.text, caption.count >= 4 else {
         return
        }
        let selectedRow = catagoryPickerView.selectedRow(inComponent: 0)
        let category = Catagory.allCases[selectedRow]
        if let task = task {
            let task = Task(id: task.id, catagory: category, caption: caption, createdData: task.createdData, isComplited: task.isComplited)
            let userInfo: [String:Task] = ["updateTask":task]
            NotificationCenter.default.post(name: NSNotification.Name("com.fullstacktuts.editTask"), object: nil, userInfo: userInfo)
        } else {
            let taskId = UUID().uuidString
            let task = Task(id: taskId, catagory: category, caption: caption, createdData: Date(), isComplited: false)
            let userInfo: [String:Task] = ["newTask":task]
            NotificationCenter.default.post(name: NSNotification.Name("com.fullstacktuts.createTask"), object: nil, userInfo: userInfo)
        }
        
        delegate?.closeView()
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.closeView()
    }
    
}

extension NewTaskModalView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add caption..."
            textView.textColor = .placeholderText
        }
    }
    
}

extension NewTaskModalView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Catagory.allCases.count
    }
}

extension NewTaskModalView: UIPickerViewDelegate {
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return Catagory.allCases[row].rawValue
//    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            pickerLabel?.textAlignment = .center
        }
        let catagory = Catagory.allCases[row]
        pickerLabel?.text = catagory.rawValue
        return pickerLabel!
    }
}


