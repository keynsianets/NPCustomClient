//
//  ParcelsListModel.swift
//  NPCustomClient
//
//  Created by Denis Markov on 17.07.2019.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation

extension RestAPI {
    
    func getTrackInfo(documents: [String], callback: @escaping (_ isOK: Bool, _ trackInfo: NPResponse?) -> Void) {
        parameters["modelName"] = "TrackingDocument"
        parameters["calledMethod"] = "getStatusDocuments"
        
        var documentsDictionary: [[String:String]] = []
        for document in documents {
            documentsDictionary.append(["DocumentNumber": document, "Phone":""])
        }
        if let language = Locale.current.languageCode, language == "ru" {
            parameters["methodProperties"] = ["Documents": documentsDictionary, "Language" : language]
        } else {
            parameters["methodProperties"] = ["Documents": documentsDictionary]
        }
        
        guard let url = URL(string: serverURL) else {
            callback(false, nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            callback(false, nil)
            return
        }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            debugPrint("get response")
            if let error = error {
                debugPrint("error:", error)
                callback(false, nil)
                return
            }
            guard let data = data else {
                callback(false, nil)
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    callback(false, nil)
                    return
                }
                
                let npResponse = NPResponse(json: json)
                
                if Locale.current.languageCode == "ru", let citySender = npResponse.data[0].citySender, let cityRecipient = npResponse.data[0].cityRecipient {
                    if Locale.current.languageCode == "ru" {
                        RestAPI.shared.getCityRu(city: citySender) { (addressFound, citySenderRu) in
                            npResponse.data[0].citySender = citySenderRu
                            RestAPI.shared.getCityRu(city: cityRecipient) { (addressFound, cityRecipientRu) in
                                npResponse.data[0].cityRecipient = cityRecipientRu
                                callback(true, npResponse)
                            }
                        }
                        
                    }
                } else {
                    callback(true, NPResponse(json: json))
                }
                
                
                
                
            } catch let jsonError {
                print("Error serializing json: ", jsonError)
            }
        }.resume()
        
    }
    
    func getCityRu(city: String, callback: @escaping (_ isOK: Bool, _ city: String) -> Void) {
        parameters["modelName"] = "Address"
        parameters["calledMethod"] = "getCities"
        parameters["methodProperties"] = ["FindByString": city, "Language" : "ru"]
        
        guard let url = URL(string: serverURL) else {
            callback(false, city)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            callback(false, city)
            return
        }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            debugPrint("get response")
            if let error = error {
                debugPrint("error:", error)
                callback(false, city)
                return
            }
            guard let data = data else {
                callback(false, city)
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    callback(false, city)
                    return
                }
                guard let data = json["data"] as? [[String: Any]], let cityRu = data[0]["DescriptionRu"] as? String else {
                    callback(false, city)
                    return
                }
                callback(true, cityRu)
                
            } catch let jsonError {
                print("Error serializing json: ", jsonError)
            }
        }.resume()
    }
    
}

class NPResponse {
    var success: Bool?
    var data: [TrackInfo] = []
    var errors: [String]?
    var warnings: [String:Any]?
    var info: [String]?
    var messageCodes: [String]?
    var errorCodes: [String]?
    var warningCodes: [String]?
    var infoCodes: [String]?
    
    init(json: [String: Any]) {
        success                = json["success"] as? Bool
        errors                 = json["errors"] as? [String]
        warnings               = json["warnings"] as? [String : Any]
        info                   = json["info"] as? [String]
        messageCodes           = json["messageCodes"] as? [String]
        errorCodes             = json["errorCodes"] as? [String]
        warningCodes           = json["warningCodes"] as? [String]
        infoCodes              = json["infoCodes"] as? [String]
        
        if let sourceData = json["data"] as? [[String:Any]] {
            var dataSource: [TrackInfo] = []
            for doc in sourceData {
                dataSource.append(TrackInfo(json: doc))
            }
            data = dataSource
        }
    }
}

class TrackInfo {
    var number: String?
    var redelivery: Int?
    var redeliverySum: [Int]?
    var redeliveryNum: String?
    var redeliveryPayer: String?
    var ownerDocumentType: String?
    var lastCreatedOnTheBasisDocumentType: String?
    var lastCreatedOnTheBasisPayerType: String?
    var lastCreatedOnTheBasisDateTime: String?
    
    var lastTransactionStatusGM: String?
    var lastTransactionDateTimeGM: String?
    var dateCreated: String?
    var documentWeight: Double?
    var checkWeight: Double?
    var documentCost: Double?
    var sumBeforeCheckWeight: Double?
    var payerType: String?
    var recipientFullName: String?
    
    var recipientDateTime: String?
    var scheduledDeliveryDate: String?
    var paymentMethod: String?
    var cargoDescriptionString: String?
    var cargoType: String?
    var citySender: String?
    var cityRecipient: String?
    var warehouseRecipient: String?
    var counterpartyType: String?
    
    var afterpaymentOnGoodsCost: Int?
    var serviceType: String?
    var undeliveryReasonsSubtypeDescription: String?
    var warehouseRecipientNumber: String?
    var lastCreatedOnTheBasisNumber: String?
    var phoneRecipient: String?
    var recipientFullNameEW: String?
    var warehouseRecipientInternetAddressRef: String?
    var marketplacePartnerToken: String?
    
    var clientBarcode: String?
    var recipientAddress: String?
    var counterpartyRecipientDescription: String?
    var counterpartySenderType: String?
    var dateScan: String?
    var paymentStatus: String?
    var paymentStatusDate: String?
    var amountToPay: String?
    var amountPaid: String?
    
    var status: String?
    var statusCode: String?
    var refEW: String?
    var backwardDeliverySubTypesServices: [Any]?
    var backwardDeliverySubTypesActions: [Any]?
    var undeliveryReasons: String?
    
    init(json: [String: Any]) {
        number                                              = json["Number"] as? String
        redelivery                                          = json["Redelivery"] as? Int
        redeliverySum                                       = json["RedeliverySum"] as? [Int]
        redeliveryNum                                       = json["RedeliveryNum"] as? String
        redeliveryPayer                                     = json["RedeliveryPayer"] as? String
        ownerDocumentType                                   = json["OwnerDocumentType"] as? String
        lastCreatedOnTheBasisDocumentType                   = json["LastCreatedOnTheBasisDocumentType"] as? String
        lastCreatedOnTheBasisPayerType                      = json["LastCreatedOnTheBasisPayerType"] as? String
        lastCreatedOnTheBasisDateTime                       = json["LastCreatedOnTheBasisDateTime"] as? String
        
        lastTransactionStatusGM                             = json["LastTransactionStatusGM"] as? String
        lastTransactionDateTimeGM                           = json["LastTransactionDateTimeGM"] as? String
        dateCreated                                         = json["DateCreated"] as? String
        documentWeight                                      = json["DocumentWeight"] as? Double
        checkWeight                                         = json["CheckWeight"] as? Double
        documentCost                                        = json["DocumentCost"] as? Double
        sumBeforeCheckWeight                                = json["SumBeforeCheckWeight"] as? Double
        payerType                                           = json["PayerType"] as? String
        recipientFullName                                   = json["RecipientFullName"] as? String
        
        recipientDateTime                                   = json["RecipientDateTime"] as? String
        scheduledDeliveryDate                               = json["ScheduledDeliveryDate"] as? String
        paymentMethod                                       = json["PaymentMethod"] as? String
        cargoDescriptionString                              = json["CargoDescriptionString"] as? String
        cargoType                                           = json["CargoType"] as? String
        citySender                                          = json["CitySender"] as? String
        cityRecipient                                       = json["CityRecipient"] as? String
        warehouseRecipient                                  = json["WarehouseRecipient"] as? String
        counterpartyType                                    = json["CounterpartyType"] as? String
        
        afterpaymentOnGoodsCost                             = json["AfterpaymentOnGoodsCost"] as? Int
        serviceType                                         = json["ServiceType"] as? String
        undeliveryReasonsSubtypeDescription                 = json["UndeliveryReasonsSubtypeDescription"] as? String
        warehouseRecipientNumber                            = json["WarehouseRecipientNumber"] as? String
        lastCreatedOnTheBasisNumber                         = json["LastCreatedOnTheBasisNumber"] as? String
        phoneRecipient                                      = json["PhoneRecipient"] as? String
        recipientFullNameEW                                 = json["RecipientFullNameEW"] as? String
        warehouseRecipientInternetAddressRef                = json["WarehouseRecipientInternetAddressRef"] as? String
        marketplacePartnerToken                             = json["MarketplacePartnerToken"] as? String
        
        clientBarcode                                       = json["ClientBarcode"] as? String
        recipientAddress                                    = json["RecipientAddress"] as? String
        counterpartyRecipientDescription                    = json["CounterpartyRecipientDescription"] as? String
        counterpartySenderType                              = json["CounterpartySenderType"] as? String
        dateScan                                            = json["DateScan"] as? String
        paymentStatus                                       = json["PaymentStatus"] as? String
        paymentStatusDate                                   = json["PaymentStatusDate"] as? String
        amountToPay                                         = json["AmountToPay"] as? String
        amountPaid                                          = json["AmountPaid"] as? String
        
        status                                              = json["Status"] as? String
        statusCode                                          = json["StatusCode"] as? String
        refEW                                               = json["RefEW"] as? String
        backwardDeliverySubTypesServices                    = json["BackwardDeliverySubTypesServices"] as? [Any]
        backwardDeliverySubTypesActions                     = json["BackwardDeliverySubTypesActions"] as? [Any]
        undeliveryReasons                                   = json["UndeliveryReasons"] as? String
    }
}
