//
//  Produto.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 14/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import Foundation

class Produto {
    var nome_item: String?
    var preco: String?
    var imagem: String?
    var imagens:[String]
    var mes: String?
    
    init(nome_item: String?, preco: String?, imagem: String?,mes:String?,imagens:[String]){
        self.nome_item = nome_item
        self.preco = preco
        self.imagem = imagem
        self.mes = mes
        self.imagens = imagens
    }
}
