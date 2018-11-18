//
//  FilterViewController.swift
//  News App
//
//  Created by SK on 17/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    enum FilterType: Int {
        case category = 100
        case language = 101
        case country = 102
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: FilterTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    private var country = "", language = "", category = ""
    private var filterData: ((_ country: String, _ language: String, _ category: String)-> Void)?
    private var selectedFilterType = FilterType.category
    
    init(country: String, language: String, category: String, filterData: @escaping(String, String, String) -> Void) {
        super.init(nibName: "FilterViewController", bundle: nil)
        super.modalPresentationStyle = .overCurrentContext
        self.country = country
        self.language = language
        self.category = category
        self.filterData = filterData
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonFilterTypeButtonAction(categoryButton)
    }
    
    @IBAction func cross(_ sender: Any) {
        view.endEditing(true)
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reset(_ sender: Any) {
        view.endEditing(true)
        country = ""
        language = ""
        category = ""
        commonFilterTypeButtonAction(categoryButton)
    }
    
    @IBAction func apply(_ sender: Any) {
        view.endEditing(true)
        view.backgroundColor = .clear
        dismiss(animated: true, completion: {
            self.filterData?(self.country, self.language, self.category)
        })
    }
    
    @IBAction func commonFilterTypeButtonAction(_ sender: UIButton) {
        for tag in 100...102 {
            if let button = view.viewWithTag(tag) as? UIButton {
                button.isSelected = false
            }
        }
        sender.isSelected = true
        if let filterType = FilterType(rawValue: sender.tag) {
            selectedFilterType = filterType
        }
        tableView.reloadData()
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedFilterType {
        case .category:
            return NewsApp.Filter.categories.count
        case .language:
            return NewsApp.Filter.languages.count
        case .country:
            return NewsApp.Filter.countries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: FilterTableViewCell.self)

        let cellData: String?
        switch selectedFilterType {
        case .category:
            cellData = NewsApp.Filter.categories[indexPath.row]
            cell.contentButton.isSelected = cellData == category
            cell.backgroundColor = cellData == category ? .white : .clear
        case .language:
            cellData = NewsApp.Filter.languages[indexPath.row]
            cell.contentButton.isSelected = cellData == language
            cell.backgroundColor = cellData == language ? .white : .clear
        case .country:
            cellData = NewsApp.Filter.countries[indexPath.row]
            cell.contentButton.isSelected = cellData == country
            cell.backgroundColor = cellData == country ? .white : .clear
        }
        
        cell.contentButton.setTitle(cellData?.uppercased(), for: .normal)

        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch selectedFilterType {
        case .category:
            category = NewsApp.Filter.categories[indexPath.row]
        case .language:
            language = NewsApp.Filter.languages[indexPath.row]
        case .country:
            country = NewsApp.Filter.countries[indexPath.row]
        }
        
        tableView.reloadData()
    }
}
