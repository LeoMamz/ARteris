//
//  RankingListTableViewController.swift
//  ARTetris
//
//  Created by 马宝森 on 2019/6/17.
//  Copyright © 2019 Exyte. All rights reserved.
//

import UIKit
import Foundation
import ImageIO
import os.log

class RankingListTableViewController: UITableViewController {
    //MARK: Properties
    var scores = [Scores]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedScores = loadScores()
        
        if savedScores?.count ?? 0 > 0 {
            self.scores = savedScores ?? [Scores]()
        }else{
            //loadSampleScores()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RankingListTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RankingListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RankingListTableViewCell.")
        }

        // Configure the cell...
        let score = scores[indexPath.row]
        
        cell.rankName.text = score.name
        cell.rankScore.text = String(score.score)
        cell.rankIndex.text = String(indexPath.row+1)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadSampleScores() {
        let name1 = "无人上榜"
        guard let score1 = Scores(score: 0,name: name1) else {
            fatalError("Unable to instantiate score1")
        }
        scores += [score1]
    }
    func saveScores() {
        let fullPath = getDocumentsDirectory().appendingPathComponent("scores")
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: scores, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Scores successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save scores...", log: OSLog.default, type: .error)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func loadScores() -> [Scores]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("scores")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing:nsData)
                
                if let loadedScores = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Scores> {
                    return loadedScores
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
    
}
