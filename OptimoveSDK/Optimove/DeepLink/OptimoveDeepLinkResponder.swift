//
//  OptimoDeepLinkResponder.swift
//  DevelopSDK
//
//  Created by Elkana Orbach on 22/11/2017.
//  Copyright © 2017 Optimove. All rights reserved.
//

import Foundation

public protocol OptimoveDeepLinkCallback
{
    func didReceive(deepLink: OptimoveDeepLinkComponents?)
}

public class OptimoveDeepLinkResponder: NSObject
{
    private let deepLinkCallback: OptimoveDeepLinkCallback
    
    public init(_ deepLinkCallback: OptimoveDeepLinkCallback)
    {
        self.deepLinkCallback = deepLinkCallback
    }
    
    func didReceive(deepLinkComponent: OptimoveDeepLinkComponents)
    {
        deepLinkCallback.didReceive(deepLink: deepLinkComponent)
    }
}

public struct OptimoveDeepLinkComponents
{
    public var screenName : String
    public var query: [String:String]?
}
