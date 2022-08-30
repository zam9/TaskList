//
//  CustomCell.swift
//  TaskList-24
//
///     TASK LIST by zamjay
///     Version 0.9a 2022-08-30
//
//  Created by Zam on 28.08.2022.
//

// MARK: Класс кастомной ячейки, в которой отображается задача

import UIKit

// В протоколе указываем делегируемые функции
protocol CustomCellDelegate {
    func changeTaskStatus(cell: CustomCell)
}

class CustomCell: UITableViewCell {
    
    // Переменная с делегатом
    var delegate: CustomCellDelegate?
    
    // Основное содержимое ячейки - лейблы с названием задачи и датой-временем создания и кнопка-статус задачи
    @IBOutlet weak var customCellNameLabel: UILabel!
    @IBOutlet weak var customCellDateLabel: UILabel!
    @IBOutlet weak var customCellDoneButton: UIButton!
    
    // Действие кнопки-кружка статуса задачи - делегируем функцию в TVC
    // Будет менять статус задачи в массиве задач в модели
    @IBAction func doneButtonAction(_ sender: UIButton) {
        delegate?.changeTaskStatus(cell: self)
    }
}
