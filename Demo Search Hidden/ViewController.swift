//
//  ViewController.swift
//  Demo Search Hidden
//
//  Created by Pham Anh on 8/29/17.
//  Copyright © 2017 Pham Anh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxShortcuts

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    
    private let disposeBag = DisposeBag()
    private var lastPoint: CGPoint = CGPoint(x: 0, y: -44)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.contentInset.top = 44
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureTableView() {
        
        tableView.rx
            .didScroll
            .withLatestFrom(tableView.rx.contentOffset)
            .filter { $0.y > self.searchView.frame.size.height * -1 }
            .subscribeNext { point in
                print(String(describing: point))
                
                let distance = self.searchView.frame.size.height * (-1)
                
                let shouldHidden: Bool = {
                    let isScrollUp = point.y > self.lastPoint.y
                    return isScrollUp && self.searchViewTopConstraint.constant != distance
                }()
                
                let shouldShow: Bool = {
                    let isScrollDown = point.y < self.lastPoint.y
                    return isScrollDown && self.searchViewTopConstraint.constant != 0.0
                }()
                
                if shouldHidden {
                    self.searchViewTopConstraint.constant = distance
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                } else if shouldShow {
                    self.searchViewTopConstraint.constant = 0.0
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
                
                self.lastPoint = point
            }
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = String(describing: indexPath)
        
        return cell
    }
}

