//
//  Monitor.swift
//  OptimoveSDKDev
//
//  Created by Mobile Developer Optimove on 06/09/2017.
//  Copyright © 2017 Optimove. All rights reserved.
//

import Foundation
import os


public protocol OptimoveStateDelegate
{
    func didStartLoading()
    func didBecomeActive()
    func didBecomeInvalid(withErrors errors : [OptimoveError])
    
    var id: Int { get }
}

class MonitorOptimoveState
{
    //MARK: - Private Variables
    private var componentsState : [Component:State.Component]
    private var sdkState: State.SDK
    {
        didSet
        {
            for (_,delegate) in stateDalegates
            {
                notifyDelegate(delegate)
            }
        }
    }
    private var stateDalegates: [Int : OptimoveStateDelegate]
    
    var initializationErrors: [OptimoveError]?
    {
        didSet
        {
            if initializationErrors?.isEmpty ?? true
            {
               sdkState = .inactive
            }
        }
    }
    
    //MARK: - Initializers
    init(componentsState: [Component:State.Component]   = [.optiPush:.unknown,
                                                           .optiTrack:.unknown],
         sdkState :State.SDK                            = .loading,
         stateDalegates: [Int : OptimoveStateDelegate]  = [:]
        )
    {
        self.componentsState = componentsState
        self.sdkState = sdkState
        self.stateDalegates = stateDalegates
    }
    
    func setup(from json:[String:Any])
    {
        let monitorData = Parser.extractOptimoveComponentsPermissions(from:json)
        update(component: .optiPush, state: monitorData.isOptipushEnabled ? .permitted : .denied)
        update(component: .optiTrack, state: monitorData.isOptitrackEnabled ? .permitted : .denied)
    }
    
    
    
    // MARK: - Getters
    
    func getState(of component:Component) -> State.Component?
    {
        return componentsState[component]
    }
    
    func isSdkAvailable() -> Bool
    {
        return sdkState == .active
    }
    func isSdkInitialized() -> Bool
    {
        return sdkState != .loading
    }
    func isComponentPubliclyAvailable(_ component: Component) -> Bool
    {
        let state = getState(of: component)
        return state == .active
    }
    
    func isComponentInternallyAvailable(_ component: Component) -> Bool
    {
        let state = getState(of: component)
        return state == .active || state == .activeInternal
    }
    
    //MARK: - Setters
    func update(component: Component, state: State.Component)
    {
        Optimove.sharedInstance.logger.debug("\(component) state is \(state)")
        componentsState.updateValue(state, forKey: component)
    }
    
    func updateSDKState(with errors:[OptimoveError]? = nil )
    {
        Optimove.sharedInstance.logger.error("finish Optimove configuration")
        
        guard errors?.isEmpty ?? true
            else
        {
            initializationErrors = errors!
            sdkState = .inactive
            return
        }
        sdkState = .active
    }
    
    // MARK: - Delegates
    private func notifyDelegate(_ delegate: OptimoveStateDelegate)
    {
        switch sdkState
        {
        case .loading:
            delegate.didStartLoading()
        case .active:
            delegate.didBecomeActive()
        case .inactive:
            delegate.didBecomeInvalid(withErrors: initializationErrors ?? [])
        }
    }
    
    func register(stateDelegate: OptimoveStateDelegate)
    {
        Optimove.sharedInstance.logger.severe("\(stateDelegate.id) register to state delegate")
        notifyDelegate(stateDelegate)
        stateDalegates[stateDelegate.id] = stateDelegate
    }
    
    func unregister(stateDelegate:OptimoveStateDelegate)
    {
        Optimove.sharedInstance.logger.severe("\(stateDelegate.id) unregister to state delegate")
        stateDalegates.removeValue(forKey: stateDelegate.id)
    }
}


