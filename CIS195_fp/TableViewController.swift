//
//  TableViewController.swift
//  CIS195_fp
//
//  Created by Ajay Vasisht on 4/23/20.
//  Copyright © 2020 Ajay Vasisht. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TableViewController : UITableViewController, AddMemoryDelegate {
    func didCreate(_ yes: Bool) {
        dismiss(animated: true, completion: nil)
        if (yes) {
            self.tableView.reloadData()
        }
    }
    
    var pinAnnotation : PinAnnotation? = nil
    var memories : [Memory] = []
    
    // set up Firebase variables (ref, refHandle)
   var ref : DatabaseReference!
   var refHandle : DatabaseHandle!
    
    override func viewDidLoad() {
        print("landed table view")
        dump(pinAnnotation)
        
        let pinId : Int = pinAnnotation!.id
        print(pinId)
        // TODO: set up Firebase ref
        ref = Database.database().reference()
        
        refHandle = ref.child("memories").child(String(pinId)).observe(DataEventType.value, with: { (snapshot) in
        //    - Decode the 'snapshot' (Firebase data) into an array of NSDictionary objects
            dump(snapshot.value)
            if let values = snapshot.value as? NSArray {
                print("uh")
                var temp = [Memory]()

                for val in values {
                    if let pin = val as? NSDictionary {
                        let title = pin["title"] as! String
                        let memId = pin["memId"] as! Int
                        let blurb = pin["blurb"] as! String
                        let imageUrl = pin["image"] as! String
                        
                        let mem : Memory = Memory(title: title, memId: memId, blurb: blurb, image: URL(string: imageUrl))
                        temp.append(mem)
                    }
                }
                
                DispatchQueue.main.async {
                    self.memories = temp
                    dump(self.memories)
                    print("here")
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            // TODO: How many sections? (Hint: we have 1 section and x rows)
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // How many rows in our section?
            return memories.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // TODO: Deque a cell from the table view and configure its UI. Set the label and star image by using cell.viewWithTag(..)
            let cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let label : UILabel = (cell?.textLabel)!
            let subtitle : UILabel = (cell?.detailTextLabel)!
        
            label.text = memories[indexPath.row].title
            subtitle.text = String(memories[indexPath.row].memId)

            //        print(cell?.textLabel?.text)
            return cell!
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100.0
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "2") {
                let destination : DetailViewController = segue.destination as! DetailViewController
                let path : IndexPath? = tableView.indexPathForSelectedRow
                
                destination.inputTitle = memories[path!.row].title
                destination.inputSubtitle = "Memory \(memories[path!.row].memId)"
                destination.inputBlurb = memories[path!.row].blurb
                destination.inputImageUrl = memories[path!.row].image
            }
            else if (segue.identifier == "3") {
                let destination : UINavigationController = segue.destination as! UINavigationController
                
                let mem : AddMemoryDBViewController = destination.topViewController as! AddMemoryDBViewController
                mem.pinId = self.pinAnnotation!.id
                mem.delegate = self
            }
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // TODO: Deselect the cell, and toggle the "favorited" property in your model
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.tableView.reloadData()
        }
}
