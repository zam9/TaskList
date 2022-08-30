//
//  TaskListModel.swift
//  TaskList-24
//
///     TASK LIST by zamjay
///     Version 0.9a 2022-08-30
//
//  Created by Zam on 28.08.2022.
//

// MARK: Модель приложения с данными и логикой их обработки, а также с описанием класса задачи

import UIKit

// Класс задачи с инициализацией
class Task {
    
    // Что есть у задачи - имя (строка), дата (в формате Date для сортировки), статус выполнения (Bool)
    var name: String
    var date: Date
    var done: Bool
    
    // Инициализация
    init(name: String, date: Date, done: Bool) {
        self.name = name
        self.date = date
        self.done = done
    }
}

// Класс модели с данными и функциями для их обработки
class Model {
    
    // Режим сортировки данных (по дате-времени) - от старых задач к новым или наоборот
    var sortedOldToNew = true
    //var trashIsOn = false

    // Настройки форматтера даты и времени
    var dateFormat = "d MMM y HH:mm:ss"
    var dateLocale = Locale(identifier: "en-us")
    
    // Массив с данными - примеры задач с разным временем и небольшой инструкцией о возможностях приложения
    var tasks: [Task] = [
        Task(name: "Finish SkillFactory course", date: Date(timeIntervalSinceNow: -5200008), done: false),
        Task(name: "Become great developer", date: Date(timeIntervalSinceNow: -4100002), done: false),
        Task(name: "Find awesome job", date: Date(timeIntervalSinceNow: -1950001), done: false),
        Task(name: "Fly to Mars", date: Date(timeIntervalSinceNow: -88009), done: true),
        Task(name: "→ Tap any task to edit it", date: Date(timeIntervalSinceNow: -8888), done: false),
        Task(name: "← Tap the circle 😉", date: Date(timeIntervalSinceNow: -88), done: false),
        Task(name: "↓ Tap 三 to sort by date-time", date: Date(), done: false)
   ]
    
    // Добавлени задачи с данными в массив задач
    func addTask(name: String, date: Date, done: Bool = false) {
        tasks.append(Task(name: name, date: date, done: done))
    }

    // Изменение имени задачи в массиве по конкретному индексу
    func changeTask(at index: Int, with name: String) {
        tasks[index].name = name
    }
    
    // Изменение статуса задачи на противоположный в массиве по конкретному индексу
    func changeState(at item: Int) {
        tasks[item].done = !tasks[item].done
    }

    // Удаление задачи из массиве по конкретному индексу
    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }

    // Изменение сортировки задач в массиве по дате создания на противоположный
    func sortByDate() {
        tasks.sort { sortedOldToNew ? $0.date < $1.date : $0.date > $1.date }
    }
}
