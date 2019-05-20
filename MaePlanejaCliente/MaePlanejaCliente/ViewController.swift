//
//  ViewController.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 09/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

import NavigationDrawer

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let interactor = Interactor()
    
    var produtosList:[Produto] = []
    
    @IBOutlet weak var tableViewItems: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //populate()
        
        self.tableViewItems.delegate = self
        self.tableViewItems.dataSource = self
        
        //Obtendo os itens do banco:
        getProdutos()
        
        
    }
    /* ----- Obter produtos: ----- */
    func getProdutos(){
        
        let produtoRef = Database.database().reference().child(EnumTables.Produto.rawValue)
        produtoRef.observe(.value) { (snap) in
            if snap.childrenCount > 0 {
                self.produtosList.removeAll()
                for produtos in snap.children.allObjects as! [DataSnapshot]{
                    let produtoObject = produtos.value as? [String: AnyObject]
                    let produtoNome = produtoObject?["nome_item"]
                    let produtoImagem = produtoObject?["imagem"]
                    let produtoMes = produtoObject?["mes"]
                    let produtoPreco = produtoObject?["preco"]
                    let produto = Produto(nome_item: produtoNome as? String , preco: produtoPreco as? String,
                                          imagem: produtoImagem as? String,
                                          mes: produtoMes as? String, imagens: [""] )
                    self.produtosList.append(produto)
                }
            }
            self.tableViewItems.reloadData()
        }
    }
    
    /* ----- TableView ----- */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItensTableViewCell
        let produto = produtosList[indexPath.row]
        cell.titleTableViewCell.text = produto.nome_item
        cell.priceTableViewCell.text = produto.preco
        downloadImage(url: produto.imagem ?? "", downloadImageView: cell.imagemTableViewCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    /* ----- TableView ----- */
    
    /* ----- MENU ----- */
    
    @IBAction func homeButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSlidingMenu", sender: nil)
    }
    
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegue(withIdentifier: "showSlidingMenu", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SlidingViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = self.interactor
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    /* ----- MENU ----- */
    
    @objc func downloadImage(url:String,downloadImageView:UIImageView) {
        let imageURL = URL(string:url)!
        
        let dataTask = URLSession.shared.dataTask(with: imageURL) {
            (data, reponse, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    downloadImageView.image = UIImage(data: data)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func populate(){
        let ref: DatabaseReference! = Database.database().reference()
        let produtoRef = ref.child("Produto")
        let imgs = ["img01","img02","img03"]
        let produtos = [Produto(nome_item: "Fralda", preco: "R$ 20,00", imagem: "", mes: "3",imagens:imgs),
                        Produto(nome_item: "Carrinho de bebê", preco: "R$ 350,00", imagem: "", mes: "6",imagens:imgs),
                        Produto(nome_item: "Mamadeira", preco: "R$ 15,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Berço", preco: "R$ 400,00", imagem: "", mes: "6",imagens:imgs),
                        Produto(nome_item: "Cômoda", preco: "R$ 300,00", imagem: "", mes: "6",imagens:imgs),
                        Produto(nome_item: "Macacão", preco: "R$ 20,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Fralda de pano", preco: "R$ 5,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Pano umidecido", preco: "R$ 10,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Banheira", preco: "R$ 350,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Pote de leite", preco: "R$ 5,00", imagem: "", mes: "7",imagens:imgs)]
       
        for produto in produtos{
            let key = produtoRef.childByAutoId().key
            let prod = ["nome_item":produto.nome_item,"preco":produto.preco,"imagem": produto.imagem,"mes":produto.mes]
            produtoRef.child(key!).setValue(prod)
        }
    }


}

