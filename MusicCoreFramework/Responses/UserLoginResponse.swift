//
//  UserLoginResponse.swift
//  MusicCoreFramework
//
//  Created by Amrendra on 16/10/21.
//

public struct UserLoginResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case success, error, data
        case currentTime = "current_time"
    }

    public let success: Bool
    public let currentTime: String? //": "2021-11-20T13:00:54.654Z",
    public let error: Int
    public let data: LoggedInUserData?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        data = try? container.decode(LoggedInUserData.self, forKey: .data)
        success = try container.decode(Bool.self, forKey: .success)
        currentTime = try? container.decode(String.self, forKey: .currentTime)
        error = try container.decode(Int.self, forKey: .error)
    }
}

public struct LoggedInUserData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case userData = "user_data"
    }
    
    public let userData: LoginedInUserInfo?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userData = try? container.decode(LoginedInUserInfo.self, forKey: .userData)
    }
}

public struct LoginedInUserInfo: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case userID = "u_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case birthDate = "birth_date"
        case status
        case subscriptionPlanId = "SubscriptionPlanId"
        case subscriptionexpireddate
        case stripeCustomerId = "stripe_customer_id"
        case stripeCustomerToken = "stripe_customer_token"
        case image
        case password
        case country
        case gender
        case token
        case danceOrg = "dance_org"
        case createTime = "create_time"
        case facebookId = "facebook_id"
        case googleId = "google_id"
        case twitterId = "twitter_id"
        case appleId = "apple_id"
        case inappProductId = "inapp_product_id"
        case device //= "device"
        case receiptData = "receipt_data"
        case originalTransactionId = "original_transaction_id"
        case promoApplied = "promo_applied"
        case notes
        case wallet
        case referral
        case groupName = "group_name"
        case version
         
    }

    let userID: Int
    var firstName: String
    let lastName: String?
    let email: String?
    let birthDate: String?
    let status: Int?
    let subscriptionPlanId: String?
    let subscriptionexpireddate: String?
    let stripeCustomerId: String?
    let stripeCustomerToken: String?
    let image: String?
    let password: String?
    let country: String?
    let gender: String?
    let token: String?
    let danceOrg: String?
    let createTime: String?
    let facebookId: String?
    let googleId: String?
    let twitterId: String?
    let appleId: String?
    let inappProductId: String?
    let device: String?
    let receiptData: String?
    let originalTransactionId: String?
    let promoApplied: String?
    let notes: String?
    var wallet: Int?
    let referral: String?
    let groupName: String?
    let version: String?
    
    /*public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userID = try container.decode(Int.self, forKey: .userID)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try? container.decode(String.self, forKey: .lastName)
        email = try? container.decode(String.self, forKey: .email)
        birthDate = try? container.decode(String.self, forKey: .birthDate)
        status = try? container.decode(Int.self, forKey: .status)
        subscriptionPlanId = try? container.decode(String.self, forKey: .subscriptionPlanId)
        subscriptionexpireddate = try? container.decode(String.self, forKey: .subscriptionexpireddate)
        stripeCustomerId = try? container.decode(String.self, forKey: .stripeCustomerId)
        stripeCustomerToken = try? container.decode(String.self, forKey: .stripeCustomerToken)
        image = try? container.decode(String.self, forKey: .image)
        password = try? container.decode(String.self, forKey: .password)
        country = try? container.decode(String.self, forKey: .country)
        gender = try? container.decode(String.self, forKey: .gender)
        token = try? container.decode(String.self, forKey: .token)
        danceOrg = try? container.decode(String.self, forKey: .danceOrg)
        createTime = try? container.decode(String.self, forKey: .createTime)
        facebookId = try? container.decode(String.self, forKey: .facebookId)
        googleId = try? container.decode(String.self, forKey: .googleId)
        twitterId = try? container.decode(String.self, forKey: .twitterId)
        appleId = try? container.decode(String.self, forKey: .appleId)
        inappProductId = try? container.decode(String.self, forKey: .inappProductId)
        device = try? container.decode(String.self, forKey: .device)
        receiptData = try? container.decode(String.self, forKey: .receiptData)
        originalTransactionId = try? container.decode(String.self, forKey: .originalTransactionId)
        promoApplied = try? container.decode(String.self, forKey: .promoApplied)
        notes = try? container.decode(String.self, forKey: .notes)
        wallet = try? container.decode(Int.self, forKey: .wallet)
        referral = try? container.decode(String.self, forKey: .referral)
        groupName = try? container.decode(String.self, forKey: .groupName)
        version = try? container.decode(String.self, forKey: .version)
        }*/
   
}
