//
//  ViewModelType.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/14.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation

protocol ViewModelType {
	// Inputs from View/ViewController Layer
    associatedtype Input
	
	// Transformed outputs for View/ViewController from inputs
    associatedtype Output
	
	// Dependencies inject
    associatedtype Dependencies
    
	// Transforming inputs to outputs
    func transform(input: Input) -> Output
}

