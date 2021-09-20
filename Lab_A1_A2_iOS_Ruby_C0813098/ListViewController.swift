//
//  ListViewController.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import UIKit

class ListViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tbList: UITableView!
    
    
    //MARK:- MemberVariables
    var isProductShown = true // Create Bool to check which screen is shown either products or providers.
    
    var arrProducts = [Product]() // Create array to store all the products from the database.
    
    var arrProviders = [Provider]() // Create array to strore all the providers from the database.

    private let providerManager = ProviderManager() // Create provider manager to access database of provider.
    
    private let productManager = ProductManager() // Create provider manager to access database of product.
    
    let searchController = UISearchController(searchResultsController: nil) // Create search controller for search operation.
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupInitails()
    }
    
    
    //MARK:- PrivateFunctions
    private func setupInitails(){
        
        self.title = "Products" // Set up Navigation bar title.
        
        // Set up navigation bar attributes properties.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 40) ??
                UIFont.systemFont(ofSize: 40)]
        
        reloadTable() // Reload table to access the fresh data.
        
        searchBarSetup() // Set up search bar below the navigation bar.
        
        tbList.tableFooterView = UIView() // Remove extra seprator lines from table view
    }
    
    private func searchBarSetup(){
        
        // Set up search controller basic properties.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Items"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    
    private func reloadTable(){
        
        // Access all the providers from the database.
        guard let providers = providerManager.getAllProviders() else{ return }
        arrProviders = providers
        
        // Access all the products from the database.
        guard let products = productManager.getAllProducts() else{ return }
        arrProducts = products
        
        // Reload the table view to get fresh data.
        tbList.reloadData()
    }
    
    private func showProductForm(update: Bool){
        
        // Navigate to the product form with some information.
        let productForm = self.storyboard!.instantiateViewController(withIdentifier: "ProductFormViewController") as! ProductFormViewController
        
        productForm.isUpdate = update
        
        productForm.delegate = self
        
        self.present(productForm, animated: true, completion: nil)
    }
    
    private func getData(){
        
        // Access all the providers from the database.
        guard let providers = providerManager.getAllProviders() else{ return }
        arrProviders = providers
        
        // Access all the products from the database.
        guard let products = productManager.getAllProducts() else{ return }
        arrProducts = products
    }
    
    //MARK:- IBActions
    @IBAction func tapShowProviderOrProduct(_ sender: UIButton) {
        
        // Show products or providers accordint to the tap on the button.
        if isProductShown{
            
            isProductShown = false
            self.title = "Providers"
            sender.setTitle("Show Products", for: .normal)
        }
        else{
            
            isProductShown = true
            self.title = "Products"
            sender.setTitle("Show Providers", for: .normal)
        }
        
        reloadTable()
    }
    
    @IBAction func tapCreateProduct(_ sender: UIButton) {
        
        // When tap on add button you will get the product form to create new product.
        showProductForm(update: false)
    }
}

extension ListViewController: UITableViewDataSource,UITableViewDelegate{
    
    //MARK:- TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Create number of rows according to the list shown on the screen.
        if isProductShown{
            
            return arrProducts.count // Create number of rows according to the products count.
        }
        else{
            
            return arrProviders.count // Create number of rows according to the providers count.
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
        
        if isProductShown{
            
            // When products is shown then icon folder is hidden and also set title label leading contraint
            cell.iconFolder.alpha = 0
            cell.constLeadingLblTitle.constant = 18
            
            // Access the product according to the indexing of array
            let product = arrProducts[indexPath.row]
            
            // show product data on the table view cell
            cell.lblTitle.text = product.name
            cell.lblSubtitle.text = product.providerName
        }
        else{
            
            // When products is shown then icon folder is visible and also set title label leading contraint
            cell.iconFolder.alpha = 1
            cell.constLeadingLblTitle.constant = 65
            
            // Access the provider according to the indexing of array
            let provider = arrProviders[indexPath.row]
            
            // Show provider data on the table view cell
            cell.lblTitle.text = provider.providerName
            cell.lblSubtitle.text = "\(provider.product?.count ?? 0)"
        }
        
        return cell
    }
    
    //MARK:- TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isProductShown{
            
            // when product is shown and tap on the product then you will navigate and get the product information
            let productForm = self.storyboard!.instantiateViewController(withIdentifier: "ProductFormViewController") as! ProductFormViewController
            
            productForm.isUpdate = true
            
            let product = arrProducts[indexPath.row]
            
            productForm.id = product.id
            
            productForm.delegate = self
            
            self.navigationController?.present(productForm, animated: true, completion: nil)
        }
        else{
            
            // When you tap on the provider, then you navigate to the product list and get all the associated products.
            let productList = self.storyboard!.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            
            let provider = arrProviders[indexPath.row]
            
            productList.providerName = provider.providerName
            
            self.navigationController?.present(productList, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Add deletion action on the table view cell.
        if editingStyle == .delete{
            
            // When product is shown then it will delete the particular product by swipping the table view cell.
            if isProductShown{
                
                let product = arrProducts[indexPath.row]
                
                productManager.deleteProduct(record: product)
                arrProducts.remove(at: indexPath.row)
            }
            // when provider is shown then it will delete the provider as well as associated products.
            else{
                
                let provider = arrProviders[indexPath.row]
                
                providerManager.deleteProvider(record: provider)
                arrProviders.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ListViewController: ListViewDelegate{
    
    func getDetails() {
        
        reloadTable()
    }
}

extension ListViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Set functionality for doing search on the products and providers.
        guard let searchText = searchController.searchBar.text else { return }
        
        // When search text is empty then you will get the whole product array.
        if searchText == ""{
            
            getData()
        }
        else{
            
            // Filter array according to the search text.
            getData()
            
            if isProductShown{
                
                arrProducts = arrProducts.filter{
                     
                    $0.name.contains(searchText)
                }
            }
            else{
                
                arrProviders = arrProviders.filter{
                    
                    $0.providerName.contains(searchText)
                }
            }
        }
        
        tbList.reloadData()
    }
}
