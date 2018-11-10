//
//  NoteTableViewController.swift
//  Notes
//
//  Created by Gagan on 2018-04-04.
//  Copyright © 2018 My Org. All rights reserved.
//

import UIKit
import os.log

class NoteTableViewController: UITableViewController {

    var categorizedNotes :[[Note]] = [[], [], [], []]
    
    var categories: [String] = ["Work", "School", "Personal", "Others"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = editButtonItem
      
        
    }
    
    
    func refreshUI() {
        DispatchQueue.main.async {
            print("Calling refresh")
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categorizedNotes[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NoteTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NoteTableViewCell else { fatalError("The dequeued cell is not an instance of NoteTableViewCell.") }
        let note = categorizedNotes[indexPath.section][indexPath.row]
        cell.descriptionLabel.text = note.title
        cell.timeUpdatedLabel.text = toHumanReadable(date: note.timeUpdated!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    
    @IBAction func unwindToNoteList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NoteViewController, let note = sourceViewController.note {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                categorizedNotes[selectedIndexPath.section][selectedIndexPath.row] = note
//                tableView.moveRow(at: selectedIndexPath, to: IndexPath(row: categorizedNotes[note.categoryId!], section: note.categoryId))
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                if (note.text?.count)! <= 0 {
                    return
                }
            // Add a new note.
                let newIndexPath = IndexPath(row: categorizedNotes[note.categoryId!].count, section: note.categoryId!)
                categorizedNotes[note.categoryId!].append(note)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
//        self.notes.sort { (note1, note2) -> Bool in
//            //note1.timeUpdated > note2.timeUpdated
//            (note1.timeUpdated as! Date) > (note2.timeUpdated as! Date)
//        }
        
        refreshUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "AddNote":
            os_log("Adding a new note", log: OSLog.default, type: .debug)
        case "ShowNote":
            os_log("Showing a existing note.", log: OSLog.default, type: .debug)
            guard let noteViewController = segue.destination as? NoteViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedNoteCell = sender as? NoteTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedNoteCell) else {
                fatalError("The selected cell is not being displayed by table")
            }
            
            let selectedNote = categorizedNotes[indexPath.section][indexPath.row]
            noteViewController.note = selectedNote
        default:
            fatalError("Unexpected segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            categorizedNotes[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
