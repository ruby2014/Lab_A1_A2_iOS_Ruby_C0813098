//
//  ViewController.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import UIKit
import CoreData

class ListingVC: UIViewController, UITableViewDelegate,UITableViewDataSource,saveData{
   
    
    // Array to store providers
    var providers = [Providers]()
    
    // Array to store both type (Product and Providers) of data and populate on tableview
    var tableViewArray = [Any]()
    
    // Create the context
    var managedContext: NSManagedObjectContext!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet var table: UITableView!
    
    let VIEW_PRODUCTS="View Products"
    let VIEW_PROVIDERS="View Providers"
    let TITLE_PRODUCTS="Products"
    let TITLE_PROVIDERS = "Providers"
    
    var isProvider=false
    
    
    // Define a search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        table.dataSource=self
        table.delegate=self
        
        //Call Method to show searchbar on tableview
        showSearchBar()
        
        
    
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        // Initially Load Providers and populate in list
        loadDataFromCoreData(type: Providers())
        if #available(iOS 11.0, *) {
                navigationItem.hidesSearchBarWhenScrolling = false
            }
    }
    
   
    @IBAction func onViewButtonClick(_ sender: UIButton) {
        
        // Toogle View Button
        if (sender.titleLabel?.text == VIEW_PRODUCTS){
            loadDataFromCoreData(type: Product())
            self.navigationItem.title = TITLE_PRODUCTS
            sender.setTitle(VIEW_PROVIDERS, for: .normal)
            isProvider=false
        }else if (sender.titleLabel?.text == VIEW_PROVIDERS){
            loadDataFromCoreData(type: Providers())
            self.navigationItem.title  = TITLE_PROVIDERS
            sender.setTitle(VIEW_PRODUCTS, for: .normal)
            isProvider=true
        }
    }
   
    @IBAction func onEditclick(_ sender: UIBarButtonItem) {
        if(sender.title=="Edit"){
            table.isEditing=true
            sender.title="Save"
        }else if (sender.title=="Save"){
            table.isEditing=false
            sender.title="Edit"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let object = tableViewArray[indexPath.row]
        
        // Set TableView cell based on objects type in array
         if let product = object as? Product {
             cell = tableView.dequeueReusableCell(withIdentifier: "product" ) as! ProdCell
            (cell as! ProdCell).setProdCell(product: product)
            return cell
        } else if let provider = object as? Providers {
            cell = tableView.dequeueReusableCell(withIdentifier: "provider" ) as! ProviderCell
            (cell as! ProviderCell).setProviderCell(provider: provider)
            return cell
        }

        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If Click on Providers listing load product for that particular provider
        if (tableView.cellForRow(at: indexPath) is ProviderCell ){
            loadProductsOfProvider(name: (tableViewArray[indexPath.row] as! Providers).providerName ?? "")
            self.navigationItem.title = TITLE_PRODUCTS
            btnView.setTitle(VIEW_PROVIDERS, for: .normal)
          }

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete on Providers and Products
        if editingStyle == .delete {
            if (tableView.cellForRow(at: indexPath) is ProdCell ){ // If its Product
                deleteProduct(product : tableViewArray[indexPath.row] as! Product )
                tableViewArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                loadDataFromCoreData(type: Product())
            }else if(tableView.cellForRow(at: indexPath) is ProviderCell){ // If its Provider
                deleteProvider(provider : tableViewArray[indexPath.row] as! Providers )
                tableViewArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                loadDataFromCoreData(type: Providers())
            }
        }
        
      
    }
    

    // MARK:- Method to load data from core data based on Object type
    func loadDataFromCoreData(type: NSManagedObject) {
        
        // Clear previous data
        tableViewArray.removeAll()
        providers.removeAll()
        
        if(type is Product){
            
            // Load data of type Product
            let request: NSFetchRequest<Product> = Product.fetchRequest()
            do {
                tableViewArray = try managedContext.fetch(request)
                self.navigationItem.title = TITLE_PRODUCTS
                btnView.setTitle(VIEW_PROVIDERS, for: .normal)
               isProvider=false
            } catch {
                print(error)
            }
        }else if (type is Providers){
            
            // Load data of type providers
            let request: NSFetchRequest<Providers> = Providers.fetchRequest()
            do {
                tableViewArray = try managedContext.fetch(request)
                providers = try managedContext.fetch(request)
                self.navigationItem.title = TITLE_PROVIDERS
                btnView.setTitle(VIEW_PRODUCTS, for: .normal)
                isProvider=true
            } catch {
                print(error)
            }
        }
        
        // Update Table View
        table.reloadData()
    }
    
    //MARK:- Method to load products with provider name
    func loadProductsOfProvider(name: String) {
        tableViewArray.removeAll()
       
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        // Predicate to check provider name to load products for that
        let providerPredicate = NSPredicate(format: "provider.providerName=%@", name)
        request.predicate=providerPredicate
        do {
            tableViewArray = try managedContext.fetch(request)
           isProvider=false
            }
        catch {
            print(error)
        }
     
        table.reloadData()
    }
    
    //MARK:- Method to craete category, create and update product
    func updateProduct(pId: Int, pName: String, pDes: String, pPrice: Double, pProvider: String , selectedProvider:Providers?) {
            let newProduct = Product(context: context)
           newProduct.productId = Int32(pId)
           newProduct.productName = pName
           newProduct.productPrice = pPrice
           newProduct.productDescription = pDes
        
        if(selectedProvider != nil){
            if(pProvider == selectedProvider!.providerName){
                    newProduct.provider = selectedProvider!
            }else{
                let existingProvider = checkIfProviderAlreadyExist(name: pProvider)
            
                if (existingProvider != nil ){
                      newProduct.provider = existingProvider
                }else{
                     let newProvider = Providers(context: context)
                        newProvider.providerName=pProvider
                       newProduct.provider = newProvider
                }
            }
        
        }else{
            let existingProvider = checkIfProviderAlreadyExist(name: pProvider)
        
            if (existingProvider != nil ){
                  newProduct.provider = existingProvider
            }else{
                 let newProvider = Providers(context: context)
                    newProvider.providerName=pProvider
                   newProduct.provider = newProvider
            }
        }
       
               
        do {
            
            managedContext = appDelegate.persistentContainer.viewContext
           try managedContext.save()
        } catch {
            print(error)
        }
        
        
        loadDataFromCoreData(type : Product())
             
    }
    

    
    //MARK:- Delete Product from Core Data
    func deleteProduct(product: Product) {
        context.delete(product)
    }
    //MARK:- Delete Provider from Core Data
    func deleteProvider(provider: Providers) {
        context.delete(provider)
     }
    
    //MARK:- Method to check if provider already exist in database and return value of that provider if exist
    func checkIfProviderAlreadyExist(name: String) -> Providers?{
        var providerExisting : Providers? = nil
     
        for provider in providers{
            if((provider.providerName?.caseInsensitiveCompare(name)) == ComparisonResult.orderedSame){
                providerExisting = provider
                break
            }
        }
        return providerExisting
    }
    
    //MARK: - Show Search Bar to serach products from listing
    func showSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Item"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = .black
    }

    //MARK:-Override prepare method to send selectd product to Detail Product View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AddEditProductVC
        destination.delegate=self
        if let indexPath = table.indexPathForSelectedRow {
            if (tableViewArray[indexPath.row] is  Product){
                destination.selectedProduct =  tableViewArray[indexPath.row] as? Product
            }
        }
    }
    
    // MARK:- Method to clear Core Data
    func clearCoreData() {
        let fetchRequestProducts = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let fetchRequestProviders = NSFetchRequest<NSFetchRequestResult>(entityName: "Providers")
  
        do {
            var results = try managedContext.fetch(fetchRequestProducts)
            for result in results {
                if let managedObject = result as? NSManagedObject {
                    managedContext.delete(managedObject)
                }
            }
       
           results = try managedContext.fetch(fetchRequestProviders)
            for result in results {
                if let managedObject = result as? NSManagedObject {
                    managedContext.delete(managedObject)
                }
            }
        } catch {
            print("Error deleting records \(error)")
        }
        
        
    }
  
    //MARK:- Method to load searched products
    func loadSearchedData(predicate: NSPredicate? = nil, type: NSManagedObject ){
        tableViewArray.removeAll()
        providers.removeAll()
        
        var request:NSFetchRequest<NSFetchRequestResult>?
        if (type is Product){
            request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        }else if (type is Providers){
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Providers")
        }
        
        request!.predicate=predicate
        
        do {
            tableViewArray = try context.fetch(request!)
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
        
        table.reloadData()
    }
    
}

//MARK: - search bar delegate methods
extension ListingVC: UISearchBarDelegate {

    /// search button on keypad functionality
    /// - Parameter searchBar: search bar is passed to this function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
            if (isProvider){
                let predicate = NSPredicate(format: "providerName CONTAINS[cd] %@", searchBar.text!)
                loadSearchedData(predicate: predicate, type: Providers())
            }else{
                // Predicate for product name and description
                let predicate = NSPredicate(format: "productName CONTAINS[cd] %@ OR productDescription CONTAINS[cd] %@", searchBar.text!,searchBar.text!)
                loadSearchedData(predicate: predicate, type: Product())
            }
       
    }
    
    
     // MARK:- When Text in search bar changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            if (isProvider){
                loadSearchedData(type: Providers())
            }else{
                loadSearchedData(type: Product())
            }
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

