//
//  DataSourceProtocol.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol DataSourceProtocol {
    associatedtype Section: SectionProtocol
    var sections: [Section] { get set }
    var isEmpty: Bool { get }
}

extension DataSourceProtocol {
    var isEmpty: Bool {
        return sections.contains(where: { !$0.rows.isEmpty })
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let section = sections[safe: section] else { return 0 }
        return section.rows.count
    }
    
    func section(at index: Int) -> Section? {
        return sections[safe: index]
    }
}

protocol SectionProtocol {
    associatedtype Row
    var rows: [Row] { get }
}

extension SectionProtocol {
    func row(at index: Int) -> Row? {
        return rows[safe: index]
    }
}
