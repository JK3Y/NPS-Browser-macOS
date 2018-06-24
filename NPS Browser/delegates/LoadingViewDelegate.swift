//
//  LoadingViewDelegate.swift
//  NPS Browser
//
//  Created by JK3Y on 6/23/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

protocol LoadingViewDelegate {
    func setLabel(text: String)
    func setProgress(amount: Double)
    func closeWindow()
}
