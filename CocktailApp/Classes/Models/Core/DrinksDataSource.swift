//
//  DrinksDataSource.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import Moya
import RxSwift

protocol DataSourceDelegate {
    func didLoadCategories()
    func didLoadDrinksForSection(section: Int)
    func willLoadDrinks()
}

class DrinksDataSource {
    
    // MARK: - Properties
    private let drinksService = DrinkService()
    private let disposeBag = DisposeBag()
    private var allCategories = [Category]()
    private var categories = [Category]()
    private var drinks = [[Drink]]()
    private let delegate: DataSourceDelegate
    
    // MARK: - Initialization -
    init(delegate: DataSourceDelegate) {
        self.delegate = delegate
    }
    
    func loadCategories() {
        drinksService.loadCategories().subscribe(onNext: { [weak self] (response) in
            self?.categoriesDidLoad(response: response)
        }).disposed(by: disposeBag)
    }
    
    func loadDrinksByCategories(_ categories: [Category]) {
        var categoriesForLoad = categories
        guard !categoriesForLoad.isEmpty else { return }
        guard let category = categoriesForLoad.first else { return}
        
        drinksService.loadDrinks(categoryName: category.name ?? "").subscribe(onNext: { [weak self] (response) in
            categoriesForLoad.removeFirst()
            self?.drinksDidLoadForCategory(сategory: category, responce: response)
            self?.loadDrinksByCategories(categoriesForLoad)
        }).disposed(by: disposeBag)
    }
    
    func filterByCategories(_ value: [Category]) {
        if value.isEmpty {
            loadCategories()
        } else {
            categories = value
            loadDrinksByCategories(categories)
        }
    }
    
    private func categoriesDidLoad(response: Categories) {
        categories.removeAll()
        guard let categoriesFromServes = response.list else { return }
        
        allCategories = categoriesFromServes
        categories = categoriesFromServes
        delegate.didLoadCategories()
    }
    
    private func drinksDidLoadForCategory(сategory: Category, responce: Drinks) {
        guard let section = categories.firstIndex(of: сategory),
            let drinksForSection = responce.list else { return }
        
        drinks.append(drinksForSection)
        delegate.didLoadDrinksForSection(section: section)
    }
    
    // MARK - Helpers -
    func numberOfSections() -> Int {
        return categories.count
    }
    
    func categoryForSection(_ section: Int) -> Category {
        return categories[section]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        guard drinks.count > section else { return 0 }
        return drinks[section].count
    }
    
    func drinkForIndexPath(indexPath: IndexPath) -> Drink {
        guard drinks.count > indexPath.section, drinks[indexPath.section].count > indexPath.row else { return Drink()}
        return drinks[indexPath.section][indexPath.row]
    }
    
    func getSelectedCategoriesNames() -> [String] {
        return categories.compactMap { $0.name }
    }
    
    func getAllCategoriesNames() -> [String] {
        return allCategories.compactMap { $0.name }
    }
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func setCategoriesToFilter(from categoriesNames: [String]) {
        if categoriesNames.isEmpty {
            categories = allCategories
        } else {
            categories = allCategories.filter { categoriesNames.contains($0.name ?? "") }
        }
        
        drinks.removeAll()
        delegate.willLoadDrinks()
        loadDrinksByCategories(categories)
    }
}
