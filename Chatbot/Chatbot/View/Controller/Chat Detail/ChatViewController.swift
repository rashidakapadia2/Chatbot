//
//  ChatViewController.swift
//  Chatbot
//
//  Created by neosoft on 12/04/22.
//

import UIKit
import CoreData

var botName : String = "Raj"
var rowcount = 0
var isKeyBoardExpanded: Bool = false
class ChatViewController: UIViewController {
    
    lazy var viewModel : ChatDetailViewModel = ChatDetailViewModel()
    
<<<<<<< HEAD
    @IBOutlet weak var MessageTextField: UITextView!
    @IBOutlet weak var chatview: UIView!
=======
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatViewBottom: NSLayoutConstraint!
    @IBOutlet weak var chatTable: UITableView!
>>>>>>> 240dbf77762c549ee388e05910e5403bc2927e07
    
    
    static func loadFromNib(_ botname: String) -> UIViewController{
        botName = botname
        return ChatViewController(nibName: "ChatViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        NavBarSetUp()
        TableData()
        BindData()
        MessageTextField.delegate = self
        MessageTextField.layer.cornerRadius = MessageTextField.frame.height/2
=======
        navBarSetUp()
        tableData()
        bindData()
        messageTextField.delegate = self
        messageTextField.layer.cornerRadius = messageTextField.frame.height/2
>>>>>>> 240dbf77762c549ee388e05910e5403bc2927e07
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFromCoreData()
        scrollToBottom()
        registerNotifications()
    }
    
    func bindData() {
        viewModel.status.bind { responsed in
            switch responsed {
            case true:
                DispatchQueue.main.async {
                    self.messageTextField.text = ""
                    self.chatTable.reloadData()
                    self.scrollToBottom()
                }
            case false:
                return
            }
        }
    }
    
<<<<<<< HEAD
    @IBAction func SendTapped(_ sender: UIButton) {
        if(MessageTextField.text!.isEmpty != true){
            view.endEditing(true)
            //MessageTextField.isUserInteractionEnabled = false
            //MessageTextField.isUserInteractionEnabled = true
            
            viewmodel.FetchAndUpdateCoreData(MessageTextField.text!)
            viewmodel.SaveMessage(MessageTextField.text!, false)
            let num = Int.random(in: 0...6)
            let seconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                viewmodel.FetchAndUpdateCoreData(viewmodel.arraymessage[num])
                viewmodel.SaveMessage(viewmodel.arraymessage[num], true)
            }
=======
    @IBAction func sendTapped(_ sender: UIButton) {
        if(messageTextField.text!.isEmpty != true){
            view.endEditing(true)
            viewModel.saveUserAndBotMessage(messageTextField.text!)
>>>>>>> 240dbf77762c549ee388e05910e5403bc2927e07
        }
    }
    
    
    func navBarSetUp() {
        title = botName
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "8EDFFA")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableData() {
        chatTable.delegate = self
        chatTable.dataSource = self
        chatTable.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        chatTable.register(UINib(nibName: "BotTableViewCell", bundle: nil), forCellReuseIdentifier: "BotCell")
        chatTable.tableFooterView = UIView(frame: .zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todos = viewModel.fetchedRC2?.fetchedObjects else { return 0 }
        rowcount = todos.count
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = viewModel.fetchedRC2.object(at: IndexPath(row: indexPath.row, section: indexPath.section))
        switch todo.frombot{
        case true:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BotCell", for: indexPath) as! BotTableViewCell
            cell.updateCell(todo.message!, "\(Date().offset(from: todo.date!)) ago")
            return cell
        case false:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as!
                UserTableViewCell
            cell.updateCell(todo.message!, "\(Date().offset(from: todo.date!)) ago")
            return cell
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: rowcount-1, section: 0)
            if (rowcount > 0){
            self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

extension ChatViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            let index = IndexPath(row: indexPath?.row ?? rowcount-1, section: indexPath?.section ?? 0) ?? (newIndexPath ?? nil)
            guard let cellIndex = index else { return }
            switch type {
                case .insert:
                    chatTable.insertRows(at: [cellIndex], with: .fade)
                    rowcount = rowcount + 1
                default:
                    break
            }
    }
  }


extension ChatViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
<<<<<<< HEAD
        var maxheight = CGFloat.greatestFiniteMagnitude
=======
        let maxheight = CGFloat.greatestFiniteMagnitude
>>>>>>> 240dbf77762c549ee388e05910e5403bc2927e07
        
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: maxheight))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.adjustUITextViewHeight()
        textView.frame = newFrame
    }
    }

extension ChatViewController{
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
<<<<<<< HEAD
        view.bottomAnchor.constraint(equalTo: chatview.bottomAnchor, constant: CGFloat(keyboardHeight)).isActive = true
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        view.bottomAnchor.constraint(equalTo: chatview.bottomAnchor, constant: 0 ).isActive = true
    }
    
=======
        self.chatViewBottom.constant = -keyboardHeight
        self.view.layoutIfNeeded()
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        //
        self.chatViewBottom.constant = -1
        self.view.layoutIfNeeded()
    }
    
    
>>>>>>> 240dbf77762c549ee388e05910e5403bc2927e07
}
