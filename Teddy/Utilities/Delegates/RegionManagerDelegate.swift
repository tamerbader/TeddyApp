//
//  RegionManagerDelegate.swift
//  Triage
//
//  Created by Tamer Bader on 8/17/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

protocol RegionManagerDelegate {
    func didEnterRegion()
    func didExitRegion()
    func didExceedStayTime()
}
