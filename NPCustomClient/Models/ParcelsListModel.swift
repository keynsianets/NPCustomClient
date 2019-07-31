//
//  ParcelsListModel.swift
//  NPCustomClient
//
//  Created by Denis Markov on 17.07.2019.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

extension RestAPI {
    
    func getTrackInfo(documents: [String], callback: @escaping (_ isOK: Bool, _ trackInfo: NPResponse?) -> Void) {
        parameters["modelName"] = "TrackingDocument"
        parameters["calledMethod"] = "getStatusDocuments"
        
        var documentsDictionary: [[String:String]] = []
        for document in documents {
            documentsDictionary.append(["DocumentNumber": document, "Phone":""])
        }
        parameters["methodProperties"] = ["Documents": documentsDictionary]
        Alamofire.request(serverURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseObject{ (response: DataResponse<NPResponse>) in
            callback(response.result.isSuccess, response.result.value)
        }
    }
    
}

class NPResponse: Mappable {
    
    var success: Bool?
    var data: [TrackInfo]?
    var errors: [String]?
    var warnings: [String:Any]?
    var info: [String]?
    var messageCodes: [String]?
    var errorCodes: [String]?
    var warningCodes: [String]?
    var infoCodes: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success                <- map["success"]
        data                   <- map["data"]
        errors                 <- map["errors"]
        warnings               <- map["warnings"]
        info                   <- map["info"]
        messageCodes           <- map["messageCodes"]
        errorCodes             <- map["errorCodes"]
        warningCodes           <- map["warningCodes"]
        infoCodes              <- map["infoCodes"]
    }
}


class TrackInfo: Mappable {
    
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
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        number                                              <- map["Number"]
        redelivery                                          <- map["Redelivery"]
        redeliverySum                                       <- map["RedeliverySum"]
        redeliveryNum                                       <- map["RedeliveryNum"]
        redeliveryPayer                                     <- map["RedeliveryPayer"]
        ownerDocumentType                                   <- map["OwnerDocumentType"]
        lastCreatedOnTheBasisDocumentType                   <- map["LastCreatedOnTheBasisDocumentType"]
        lastCreatedOnTheBasisPayerType                      <- map["LastCreatedOnTheBasisPayerType"]
        lastCreatedOnTheBasisDateTime                       <- map["LastCreatedOnTheBasisDateTime"]
        
        lastTransactionStatusGM                             <- map["LastTransactionStatusGM"]
        lastTransactionDateTimeGM                           <- map["LastTransactionDateTimeGM"]
        dateCreated                                         <- map["DateCreated"]
        documentWeight                                      <- map["DocumentWeight"]
        checkWeight                                         <- map["CheckWeight"]
        documentCost                                        <- map["DocumentCost"]
        sumBeforeCheckWeight                                <- map["SumBeforeCheckWeight"]
        payerType                                           <- map["PayerType"]
        recipientFullName                                   <- map["RecipientFullName"]
        
        recipientDateTime                                   <- map["RecipientDateTime"]
        scheduledDeliveryDate                               <- map["ScheduledDeliveryDate"]
        paymentMethod                                       <- map["PaymentMethod"]
        cargoDescriptionString                              <- map["CargoDescriptionString"]
        cargoType                                           <- map["CargoType"]
        citySender                                          <- map["CitySender"]
        cityRecipient                                       <- map["CityRecipient"]
        warehouseRecipient                                  <- map["WarehouseRecipient"]
        counterpartyType                                    <- map["CounterpartyType"]
        
        afterpaymentOnGoodsCost                             <- map["AfterpaymentOnGoodsCost"]
        serviceType                                         <- map["ServiceType"]
        undeliveryReasonsSubtypeDescription                 <- map["UndeliveryReasonsSubtypeDescription"]
        warehouseRecipientNumber                            <- map["WarehouseRecipientNumber"]
        lastCreatedOnTheBasisNumber                         <- map["LastCreatedOnTheBasisNumber"]
        phoneRecipient                                      <- map["PhoneRecipient"]
        recipientFullNameEW                                 <- map["RecipientFullNameEW"]
        warehouseRecipientInternetAddressRef                <- map["WarehouseRecipientInternetAddressRef"]
        marketplacePartnerToken                             <- map["MarketplacePartnerToken"]
        
        clientBarcode                                       <- map["ClientBarcode"]
        recipientAddress                                    <- map["RecipientAddress"]
        counterpartyRecipientDescription                    <- map["CounterpartyRecipientDescription"]
        counterpartySenderType                              <- map["CounterpartySenderType"]
        dateScan                                            <- map["DateScan"]
        paymentStatus                                       <- map["PaymentStatus"]
        paymentStatusDate                                   <- map["PaymentStatusDate"]
        amountToPay                                         <- map["AmountToPay"]
        amountPaid                                          <- map["AmountPaid"]
        
        status                                              <- map["Status"]
        statusCode                                          <- map["StatusCode"]
        refEW                                               <- map["RefEW"]
        backwardDeliverySubTypesServices                    <- map["BackwardDeliverySubTypesServices"]
        backwardDeliverySubTypesActions                     <- map["BackwardDeliverySubTypesActions"]
        undeliveryReasons                                   <- map["UndeliveryReasons"]
    }
}
