//
//  Task.swift
//  TodoListApp
//
//  Created by Guest User on 25/4/25.
//
import Foundation
struct Task: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

