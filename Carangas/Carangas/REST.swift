//
//  REST.swift
//  Carangas
//
//  Created by Vinicius Loss on 24/02/23.
//  Copyright © 2023 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        
        //.default - Configurações padrões.
        //.ephemeral - Semelhante a navegação privada do navegador, não armazena nenhuma informação.
        //.background - Para requisições quando o app não está sendo usado.
        let config = URLSessionConfiguration.default
        
        config.allowsCellularAccess = false // Para não permitir usar na 3g
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0 // segundos
        config.httpMaximumConnectionsPerHost = 5 // Para limitar o número de tarefas usando a requisição
        
        return config
    }()
    
    private static let session = URLSession(configuration: configuration) // URLSession.shared // Sessão compartilhada, jeito mais comum de criar uma sessão.
    
    // Metodo de class que nao precisa a classe estar instanciada para ser utilixado.
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void){
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        
        // Cria a tarefa - Retorna JSON no data
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                
                // desembrulhando response
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                
                // valida código de retorno do response
                if response.statusCode == 200 {
                    
                    // desembrulhando data
                    guard let data = data else { return }
                    
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        
                        onComplete(cars)
                        
                    } catch {
                        //print(error.localizedDescription)
                        onError(.invalidJSON)
                    }
                    
                } else {
                    //print("Algum status inválido pelo servidor!!")
                    onError(.responseStatusCode(code: response.statusCode))
                }
                
            } else {
                // Esse erro se refere a algum erro no app e não na resposta ou servidor
                //print(error!)
                onError(.taskError(error: error!))
            }
        }
        
        // Executa a tarefa.
        dataTask.resume()
        
    }
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void){
        
        guard let url = URL(string: basePath) else {
            onComplete(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                    onComplete(false)
                    return
                }
                print(data)
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
        dataTask.resume()
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void){
        
        let urlString = basePath + "/" + car._id!
        
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                    onComplete(false)
                    return
                }
                print(data)
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
