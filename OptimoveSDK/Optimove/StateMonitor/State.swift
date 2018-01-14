//
//  State.swift
//  OptimoveSDK
//
//  Created by Mobile Developer Optimove on 25/09/2017.
//  Copyright © 2017 Optimove. All rights reserved.
//

import Foundation

struct State
{
    enum SDK
    {
        case loading
        case active
        case inactive
    }
    
    enum Component
    {
        case unknown
        case active
        case inactive
        case permitted
        case denied
        case activeInternal
    }
    
    enum Opt
    {
        case optIn
        case optOut
    }
}
