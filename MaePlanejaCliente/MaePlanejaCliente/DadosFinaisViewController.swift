//
//  DadosFinaisViewController.swift
//  MaePlanejaCliente
//
//  Created by Allyson Nascimento on 20/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit

class DadosFinaisViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var valorTotalLabel: UILabel!
    
    @IBOutlet weak var produtoTableView: UITableView!
    
    @IBOutlet weak var cupomBotaoOutlet: UIButton!
    var produtos:[Produto] = []
    

//    func hard_populate() {
//        let imgs = ["img01","img02","img03"]
//        produtos = [
//            Produto(nome_item: "Fralda", preco: "R$ 20,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/fraldadescartavel.jpg?alt=media&token=29488770-8584-4c4b-8b7c-5a85ce366fa1", mes: "3",imagens:imgs),
//            Produto(nome_item: "Carrinho de bebê", preco: "R$ 350,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/carrinhobebe.jpg?alt=media&token=530e368e-e003-4512-938f-ffd6b635be30", mes: "6",imagens:imgs),
//            Produto(nome_item: "Mamadeira", preco: "R$ 15,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/mamadeira.jpg?alt=media&token=10df756b-b14c-4439-93c4-c89e59cfec05", mes: "5",imagens:imgs),
//            Produto(nome_item: "Berço", preco: "R$ 400,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/berco.jpg?alt=media&token=468685fc-0163-411e-a78f-3807c927f342", mes: "6",imagens:imgs),
//            Produto(nome_item: "Cômoda", preco: "R$ 300,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/comoda.jpg?alt=media&token=203dfc0b-b4de-458b-8a70-2f181ac6ca90", mes: "6",imagens:imgs),
//            ]
//    }
    
    func populate() {
        if let produtosPref = Produto.getProdutos() {
            self.produtos = produtosPref
        }
        
        if let valorTotal = UserDefaults.standard.string(forKey: "valor_total") {
            self.valorTotalLabel.text = "     Valor total: \(valorTotal)"
        }
        
        //self.produtos = Produto.getProdutos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.produtoTableView.dataSource = self
        self.produtoTableView.delegate = self
        populate()
        self.produtoTableView.reloadData()
        if produtos.isEmpty {
            produtoTableView.alpha = 0
        } else {
            produtoTableView.alpha = 1
        }
        
        estilizarViews()
    }
    
    func estilizarViews() {
        cupomBotaoOutlet.layer.borderWidth = 0.1
        cupomBotaoOutlet.layer.cornerRadius = 10
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("quantidade de produtos: \(produtos.count)")
        return produtos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdutosFinaisTableViewCell") as! ProdutosFinaisTableViewCell
        let produto = produtos[indexPath.row]
        cell.descProdutoTextView.text = produto.nome_item
        
        cell.precoTextView.text = produto.preco
        downloadImage(url: produto.imagem ?? "", downloadImageView: cell.ProdutoImageView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let produto = produtos[indexPath.row]
        self.performSegue(withIdentifier: "showProdutoFinal", sender: produto)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ProdutoDetalhesViewController {
            destinationViewController.produto = sender as? Produto
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            produtos.remove(at: indexPath.row)
            Produto.save(itens: produtos)
            viewDidLoad()
        }
    }
    
    
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
}
