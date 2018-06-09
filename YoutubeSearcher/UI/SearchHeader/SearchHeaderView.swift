//
//  SearchHeaderView.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/7/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit

protocol SearchHeaderDelegate {
    func searchButtonPressed()
}

class SearchHeaderView : UIView {
    
    static let NibName = "SearchHeaderView"
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var headerGradientView: UIView!
    
    var searchHeaderDelegate: SearchHeaderDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        containerView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: SearchHeaderView.NibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stylize()
    }
    
    func stylize() {
        headerGradientView.alpha = 0.7
        headerGradientView.backgroundColor = UIColor.gray
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchHeaderDelegate?.searchButtonPressed()
    }
}
