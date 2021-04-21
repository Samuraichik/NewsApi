//
//  FiltersTableViewController.swift
//  OleksiyNewsAPI
//
//  Created by User on 03.04.2021.
//

import UIKit

extension FiltersTableViewController{
    enum PickerState {
        case source
        case country
        case category
    }
}

class FiltersTableViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Public Properties
    
    public static let shared = FiltersTableViewController()
    public var newsListViewControllerDelegate: NewsListViewControllerDelegate?
    // MARK: - Private Properties
    
    private var countrySelect = ""
    private var sourceSelect = ""
    private var categorySelect = ""
    private var currentPickerState: PickerState?
    private let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    private let country = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz",
                           "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma",
                           "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk",
                           "th", "tr", "tw", "ua", "us", "ve", "za"]
    private let source = ["BBC News", " The New York Times", " CNN", " Washington Post", "CNBC", "TIME", "Euronews", "The Washington Times"]

    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPickerState = .category
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // MARK: - IBActions
    
    @IBAction func applyButton(_ sender: UIBarButtonItem) {
        newsListViewControllerDelegate?.infoWasDelegated(selectedCo: countrySelect, selectedSo: sourceSelect, selectedCate: categorySelect)
    }
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        switch  sender.selectedSegmentIndex {
        case  0:
            currentPickerState = .category
            pickerView.reloadAllComponents()
        case  1:
            currentPickerState = .country
            pickerView.reloadAllComponents()
        case  2:
            currentPickerState = .source
            pickerView.reloadAllComponents()
        default:
            break
        }
    }
    
    // MARK: - Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var temp = 0
        switch currentPickerState {
        case .source:
            temp = source.count
        case .category:
            temp = categories.count
        case .country:
            temp = country.count
        default:
            break
        }
        return temp
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var tempStr = ""
        switch currentPickerState {
        case .source:
            tempStr = source[row]
            sourceSelect = source[row]
        case .category:
            tempStr = categories[row]
            categorySelect = categories[row]
        case .country:
            tempStr = country[row]
            countrySelect  = country[row]
        case .none:
            break
        }
        return tempStr
    }
}

