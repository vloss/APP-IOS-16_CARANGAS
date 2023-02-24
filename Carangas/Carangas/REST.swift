//
//  REST.swift
//  Carangas
//
//  Created by Vinicius Loss on 24/02/23.
//  Copyright © 2023 Eric Brito. All rights reserved.
//

import Foundation

class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        
        //.default - Configurações padrões.
        //.ephemeral - Semelhante a navegação privada do navegador, não armazena nenhuma informação.
        //.background - Para requisições quando o app não está sendo usado.
        let config = URLSessionConfiguration.background(withIdentifier: <#T##String#>)
        
        config.allowsCellularAccess = false // Para não permitir usar na 3g
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0 // segundos
        config.httpMaximumConnectionsPerHost = 5 // Para limitar o número de tarefas usando a requisição
        
        return config
    }()
    
    private static let session = URLSession(configuration: configuration) // URLSession.shared // Sessão compartilhada, jeito mais comum de criar uma sessão.
}
