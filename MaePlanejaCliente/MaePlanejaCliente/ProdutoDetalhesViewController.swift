//
//  ProdutoDetalhesViewController.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 23/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProdutoDetalhesViewController: UIViewController, UIScrollViewDelegate {

    var produto: Produto?
    var localSource: [ImageSource] = []
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var nomeProduto: UILabel!
    @IBOutlet weak var descProduto: UILabel!
    @IBOutlet weak var nomeLoja: UILabel!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var viewNomeLoja: UIView!
    @IBOutlet weak var viewOutrasLojas: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* IMAGE SLIDE */
        slideShow.slideshowInterval = 5.0
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideShow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideShow.pageIndicator = pageControl
        
        nomeProduto.text = produto?.nome_item
        descProduto.text = produto?.descProduto
        nomeLoja.text = produto?.nome_loja
        
        for urlString in produto?.imagens ?? ["img1"]{
            if urlString != ""{
                let url = URL(string: urlString)!
                downloadImage(from: url)
            }
            else{
                localSource.append(ImageSource(image: UIImage(named: "img1")!))
            }
        }
       
        if let produtoMostrado = produto {
            if produtoMostrado.taNaLista == 0 {
                addButtonOutlet.alpha = 1
            } else {
                addButtonOutlet.alpha = 0
            }
        }
        estilizarViews()
    }
  
    
    @IBAction func lojaButton(_ sender: Any) {
    }
    
    @IBAction func outrasLojasButton(_ sender: Any) {
    }
    
    @IBAction func addItemButton(_ sender: Any) {
        produto?.taNaLista = 1
        atualizarListaProdutosFinais()
        self.navigationController?.popViewController(animated: true)
    }
    
    func atualizarListaProdutosFinais() {
        var produtosFinais = Produto.getProdutos() ?? []
        if let produtoMostrado = produto {
            produtosFinais.append(produtoMostrado)
        }
        Produto.save(itens: produtosFinais)
    }
    
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                if let image = UIImage(data: data){
                    self.localSource.append(ImageSource(image: image))
                    if(self.localSource.count>=2){
                        self.slideShow.setImageInputs(self.localSource)
                        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProdutoDetalhesViewController.didTap))
                        self.slideShow.addGestureRecognizer(recognizer)
                    }
                }
            }
        }
    }
    
    func estilizarViews() {
        addButtonOutlet.layer.borderWidth = 0.1
        addButtonOutlet.layer.cornerRadius = 10
        
        viewNomeLoja.layer.borderWidth = 0.1
        viewNomeLoja.layer.cornerRadius = 10
        
        viewOutrasLojas.layer.borderWidth = 0.1
        viewOutrasLojas.layer.cornerRadius = 10
    }
}
