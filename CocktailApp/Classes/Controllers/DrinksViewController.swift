//
//  DrinksViewController.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import UIKit
import SVProgressHUD
import PPBadgeViewSwift

class DrinksViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var activityContainerView: UIView!
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Properties -
    private lazy var dataSource = DrinksDataSource(delegate: self)

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeFilterScreen" {
            if let vc = segue.destination as? FiltersViewController, let filters = sender as? [String] {
                vc.fillScreen(by: filters, dataSource.getAllCategoriesNames(), delegate: self)
            }
        }
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        showHud()
        dataSource.loadCategories()
        setupNavigationItems()
        setupTableView()
    }
    
    private func showHud() {
        SVProgressHUD.show()
        activityContainerView.isHidden = false
    }
    
    private func hideHud() {
        SVProgressHUD.dismiss()
        activityContainerView.isHidden = true
    }
    
    private func setupNavigationItems() {
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "filterImage"), style: .plain, target: self, action: #selector(filtersButtonPressed))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupTableView() {
        tableView.register(type: DrinkCell.self)
        tableView.register(DrinkCategoryHeader.nib, forHeaderFooterViewReuseIdentifier: DrinkCategoryHeader.reuseIdentifier)
    }
    
    private func isRightBarbuttonItemBadgeHidden(_ value: Bool) {
        guard let rightBarButton = self.navigationItem.rightBarButtonItem else { return }
        value ? rightBarButton.pp.addDot(color: .red) : rightBarButton.pp.hiddenBadge()
    }
    
    @objc private func filtersButtonPressed() {
        let filters = dataSource.getSelectedCategoriesNames()
        guard !filters.isEmpty else { return }
        performSegue(withIdentifier: "sequeFilterScreen", sender: filters)
    }
}

extension DrinksViewController: UITableViewDataSource, UITableViewDelegate { 

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DrinkCell.reuseIdentifier) as? DrinkCell else { fatalError() }
        let drink = dataSource.drinkForIndexPath(indexPath: indexPath)
        cell.fillCell(by: drink.name ?? "Empty name", drink.imageUrl ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DrinkCategoryHeader.reuseIdentifier) as? DrinkCategoryHeader else {
            return nil
        }
        let category = dataSource.categoryForSection(section)
        header.fillCategoryName(category.name?.uppercased() ?? "Empty name")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DrinkCategoryHeader.headerHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DrinkCell.cellHeight()
    }
}

extension DrinksViewController: FiltersViewControllerDelegate {
    
    func filtersDidChange(filters: [String]) {
        showHud()
        isRightBarbuttonItemBadgeHidden(!filters.isEmpty)
        dataSource.setCategoriesToFilter(from: filters)
    }
}

extension DrinksViewController: DataSourceDelegate {
    
    func didLoadCategories() {
        tableView.reloadData()
        dataSource.loadDrinksByCategories(dataSource.getCategories())
    }
    
    func didLoadDrinksForSection(section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .fade)
        if section == dataSource.numberOfSections() - 1 {
            hideHud()
        }
    }
    
    func willLoadDrinks() {
        showHud()
        tableView.reloadData()
    }
}
