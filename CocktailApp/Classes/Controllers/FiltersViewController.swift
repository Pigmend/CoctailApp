//
//  FiltersViewController.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func filtersDidChange(filters: [String])
}

class FiltersViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var applyButton: UIButton!
    
    // MARK: - Properties -
    private var allFilters: [String] = []
    private var previousSelectedFilters: [String]?
    private var currentSelectedFilters: [String] = []
    private var delegate: FiltersViewControllerDelegate?
    
    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
    }
    
    // MARK: - Interface -
    func fillScreen(by selectedFilters: [String], _ allFilters: [String], delegate: FiltersViewControllerDelegate) {
        self.allFilters = allFilters
        if selectedFilters.count != allFilters.count {
            previousSelectedFilters = selectedFilters
        }
        self.delegate = delegate
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        if previousSelectedFilters == nil {
            previousSelectedFilters = []
        }
        setupApplyButton()
        setupTableView()
        selectPreviousFilters()
    }
    
    private func setupApplyButton() {
        applyButton.isEnabled = isFiltersChanged()
    }
    
    private func setupTableView() {
        tableView.register(type: FilterCell.self)
    }
    
    private func updateApplyButton() {
        applyButton.isEnabled = isFiltersChanged()
    }
    
    private func isFiltersChanged() -> Bool {
        guard let previousFilters = previousSelectedFilters else { return true }
        return previousFilters != currentSelectedFilters
    }
    
    private func selectPreviousFilters() {
        guard let previousSelectedFilterd = previousSelectedFilters, !previousSelectedFilterd.isEmpty else { return }
        
        for filter in previousSelectedFilterd {
            let _ = allFilters.map {
                if $0 == filter, let row = allFilters.firstIndex(of: $0) {
                    self.tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
                    self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: IndexPath(row: row, section: 0))
                }
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func applyButtonPressed(_ sender: Any) {
        guard let delegate = self.delegate, isFiltersChanged() else { return }
        previousSelectedFilters = currentSelectedFilters
        delegate.filtersDidChange(filters: currentSelectedFilters)
        navigationController?.popViewController(animated: true)
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier) as? FilterCell else { fatalError() }
        cell.fillCell(by: allFilters[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FilterCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath)  {
            cell.accessoryType = .checkmark
            currentSelectedFilters.append(allFilters[indexPath.row])
            updateApplyButton()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            currentSelectedFilters.removeAll { $0 == allFilters[indexPath.row]}
            updateApplyButton()
        }
    }
}
