//
//  CitySelectionViewController.swift
//  AppleClock
//
//  Created by Gunwoo Sun on 4/30/25.
//

import UIKit

struct Item {
    let title: String
    let timeZone: TimeZone
}

struct Section {
    let title: String
    let items: [Item]
}

class CitySelectionViewController: UIViewController {

    @IBOutlet weak var cityTableView: UITableView!
    
    var list = [Section]()
    var filteredList = [Section]()
    
    func setupList() {
        var dict = [String: [TimeZone]]()
        
        for id in TimeZone.knownTimeZoneIdentifiers {
            guard let city = id.components(separatedBy: "/").last else {continue}
            
            var timeZoneList = [TimeZone(identifier: id)!]
            let key = city.chosung ?? "Unknown"
            
            if let list = dict[key] {
                timeZoneList.append(contentsOf: list)
            }
            
            dict[key] = timeZoneList
        }
        
        for (key, value) in dict {
            let items = value.sorted {
                guard let lhs = $0.city, let rhs = $1.city else { return false }
                return lhs < rhs
            }.map {
                Item(title: $0.city ?? $0.identifier, timeZone: $0)
            }
            
            let section = Section(title: key, items: items)
            list.append(section)
        }
        
        list.sort { $0.title < $1.title }
        filteredList = list
    }
    
    @objc func closeVC() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        
        
        let btn = UIButton(type: .custom)
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.systemOrange, for: .normal)
        btn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        btn.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    
        let stack = UIStackView(arrangedSubviews: [searchBar, btn])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.widthAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.width - 40).isActive = true
        
        navigationItem.titleView = stack
        
        setupList()
        cityTableView.reloadData()
        
    }
}

extension CitySelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            filteredList = list
            cityTableView.reloadData()
            cityTableView.isHidden = false
            return
        }
        
        filteredList.removeAll()
        
        for section in list {
            let items = section.items.filter {
            $0.title.lowercased().contains(searchText.lowercased()) }
            
            if !items.isEmpty {
                filteredList.append(Section(title: section.title, items: items))
            }
        }
        
        cityTableView.reloadData()
        cityTableView.isHidden = filteredList.isEmpty
        
    }
}

extension CitySelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        
        let target = filteredList[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = target.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredList[section].title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sectionIndexTitles: [String] = [
            "ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ",
            "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ",
            "ㅋ", "ㅌ", "ㅍ", "ㅎ"
        ] + (65...90).compactMap { UnicodeScalar($0).map { String($0) } }
        
        return sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return filteredList.firstIndex(where: { $0.title.uppercased() == title.uppercased()
        }) ?? 0
    }
}

extension CitySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = filteredList[indexPath.section].items[indexPath.row]
        
        NotificationCenter.default.post(name: .timeZoneDidSelect, object: nil, userInfo: ["timeZone": target.timeZone])
        
        dismiss(animated: true)
    }
}

extension Notification.Name {
    static let timeZoneDidSelect = Notification.Name(rawValue: "timeZoneDidSelect")
}
