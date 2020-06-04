//
//  SymbolViewController.swift
//  HelpingHarper
//
//  Created by Ojas Chimane on 27/4/20.
//  Copyright © 2020 HelpingHarper. All rights reserved.
//

import UIKit
import Alamofire

class SymbolViewController: UIViewController {
    
    private var symbolList = [Symbol]()
    @IBOutlet weak var symbolTableView: UITableView!
    var symbolId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSymbolData()
        print("Symbol ID: \(symbolId)")
    }
    
    private func setupSymbolData() {
        
        guard let urlToExecute  = URL(string: Constants.baseURL+"/getAllSymbols/\(symbolId!)") else {
            return
        }
        
        AF.request(urlToExecute).responseJSON {response in
            debugPrint(response.result)
            
            
            switch response.result {
            case .success:
                if let data = response.data {
                    print(data)
                    do {
                        let responseDecoded = try JSONDecoder().decode(Array<Symbol>.self, from: data)
                        print("Symbol", responseDecoded[0].symbol_name)
                        self.symbolList = responseDecoded
                        self.symbolTableView.reloadData()
                    }catch let error as NSError{
                        print(error)
                    }
                    
                }
            case .failure(let error):
                print("Error:", error)
            }
            
        }
        
    }
    
    
    
}

extension SymbolViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbolList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SYMBOL_IDENTIFIER", for: indexPath) as! SymbolTableViewCell
        
        cell.symbolNameLabel?.text = self.symbolList[indexPath.row].symbol_name
        cell.symbolImageView?.image = UIImage(named: self.symbolList[indexPath.row].symbol_name)
        cell.symbolDescTextView?.text = self.symbolList[indexPath.row].symbol_desc
        
        return cell
    }
    
    
    
    
}

