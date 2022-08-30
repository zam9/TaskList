//
//  TaskListTVC.swift
//  TaskList-24
//
///     TASK LIST by zamjay
///     Version 0.9a 2022-08-30
//
//  Created by Zam on 28.08.2022.
//

// MARK: Основной TableViewController приложения
// MARK: Тут работаем в основном с визуальной частью
// MARK: А также инициируем запуск функций из модели для получения и обработки данных

import UIKit

class TaskListTVC: UITableViewController {
    
    // Готовим экземппляры модели и кастомного футера с кнопками
    let model = Model()
    let footer = TableFooter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Добавляем кастомный футер с кнопками в самый низ экрана, а также задаем ему делегат для работы его кнопок
        footer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 120, width: tableView.frame.width, height: 120)
        navigationController?.view.addSubview(footer)
        footer.delegate = self
    }
    
    // MARK: - Работаем с таблицей (списком задач)

    // Количество секций в нашей TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Берём количество задач из массива задач из модели - столько будет строк в TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.tasks.count
    }
    
    // Готовим ячейки-строки для TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell

        // Задаем делегат для ячейки для работы ее кнопки-кружка
        cell.delegate = self
        
        // Два варианта значка для кнопок-кружков
        let taskNotDoneImg = UIImage(systemName: "circle")
        let taskDoneImg = UIImage(systemName: "checkmark.circle")
        
        // Создаём форматтер даты и времени и настраиваем его настройками из модели
        let formatter = DateFormatter()
        formatter.dateFormat = model.dateFormat
        formatter.locale = model.dateLocale
        
        // Берём данные задачи из масиива задач из модели и присваиваем их ячейке, форматируя дату в строку
        let currentTask = model.tasks[indexPath.row]
        cell.customCellNameLabel.text = currentTask.name
        cell.customCellDateLabel.text = formatter.string(from: currentTask.date)
        
        // Регулируем внешний вид кнопок-кружков и лейблов в зависимости от статуса задачи
        if currentTask.done {
            cell.customCellDoneButton.setImage(taskDoneImg, for: .normal)
            cell.customCellDoneButton.tintColor = .systemTeal
            cell.customCellNameLabel.textColor = .systemGray
        } else {
            cell.customCellDoneButton.setImage(taskNotDoneImg, for: .normal)
            cell.customCellDoneButton.tintColor = .label
            cell.customCellNameLabel.textColor = .label
        }
   
        // Меняем свойство кнопок-кружков - чтобы не меняли цвет при общем затенении, когда появляется алерт
        cell.customCellDoneButton.tintAdjustmentMode = .normal
        
        // Возвращаем готовую ячейку
        return cell
    }

    // Что будем делать при включении режима редактирования таблицы
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // В случае удаления указываем, какой запускать метод из модели для удаления задачи
        // А также удаляем ячейку-строку с ней из таблицы
        if editingStyle == .delete {
            model.removeTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // При нажатии на строку-задачу отображаем алерт для ее редактирования
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Создаем константу с ячейкой задачи для получения названия задачи
        let cell = tableView.cellForRow(at: indexPath) as! CustomCell
        
        // Начинаем готовить алерт
        let alert = UIAlertController(title: "Edit task", message: nil, preferredStyle: .alert)
        
        // Добавляем в алерт текстовое поле - в него помещаем текущее имя задачи
        alert.addTextField() { $0.text = cell.customCellNameLabel.text }
        
        // Готовим кнопку отмены
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Готовим кнопку для записи (подтверждения изменений)
        let saveAlertAction = UIAlertAction(title: "Save", style: .destructive) {_ in
       
            // Безопасно создаем константу с новыми данными из текстового поля
            guard let textValue = alert.textFields?[0].text else { return }
            
            // Запускаем метод из модели для изменения задачи
            self.model.changeTask(at: indexPath.row, with: textValue)
            
            // Обновляем таблицу, чтобы отобразились измененные данные
            self.tableView.reloadData()
        }
        
        // Добавляем кнопки в алерт и отображаем его
        alert.addAction(cancelAlertAction)
        alert.addAction(saveAlertAction)
        present(alert, animated: true)
    }
}

// MARK: - Расширения для реализации протоколов с делегируемыми функциями (нажатия на кнопки)

// Расширение нашего TableViewController с делегированными из футера функциями
extension TaskListTVC: TableFooterDelegate {
    
    // Добавление задачи
    func add() {
        
        // Начинаем готовить алерт
        let alert = UIAlertController(title: "Add new task", message: nil, preferredStyle: .alert)
        
        // Добавляем в алерт пустое текстовое поле
        alert.addTextField()
        
        // Готовим кнопку отмены
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Готовим кнопку для записи (добавления задачи)
        let saveAlertAction = UIAlertAction(title: "Add", style: .destructive) {_ in
       
            // Безопасно создаем константу с новыми данными из текстового поля
            guard let textValue = alert.textFields?[0].text else { return }
            
            // Запускаем метод из модели для добавления задачи с названием из текстового поля и текущей датой/временем
            self.model.addTask(name: textValue, date: Date(), done: false)
            
            // Обновляем таблицу, чтобы отобразились новые данные
            self.tableView.reloadData()
        }
        
        // Добавляем кнопки в алерт и отображаем его
        alert.addAction(cancelAlertAction)
        alert.addAction(saveAlertAction)
        present(alert, animated: true)
    }
    
    // Сортровка по дате
    func sort() {
        
        // Меняем в модели переменную направления сортировки (от старых задач к новым или наоборот)
        model.sortedOldToNew = !model.sortedOldToNew
        
        // Угол поворота кнопки-картинки сортировки в зависимости от направления - 0 или 180 градусов
        // Потому что нет противоположной картинки в наборе
        let sortButtonAngle = model.sortedOldToNew ? CGFloat.pi : 0
        
        // Поворачиваем кнопку-картинку сортировки на определенный выше угол
        footer.sortButton.transform = CGAffineTransform(rotationAngle: sortButtonAngle)
        
        // Запускаем метод модели для сортировки задач модели по дате
        model.sortByDate()
        
        // Обновляем таблицу, чтобы отобразить по-новому отсортированные задачи
        tableView.reloadData()
    }
    
    // Режим удаления (изменения содержимого таблицы)
    func trash() {
        
        // Меняем режим изменения ячеек в таблице на противоположный (включаем или выключаем)
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        // Меняем цвет кнопки режима удаления в зависимости от того, включен он или нет
        footer.trashButton.tintColor = tableView.isEditing ? .red : .label
    }
}

// Расширение нашего TableViewController с делегированными из кастомной ячейки функциями
extension TaskListTVC: CustomCellDelegate {
    
    // Меняем статус задачи (выполнена или нет) на противоположный в массиве задач в модели
    // Также после обновления таблицы изменится и внешний вид кнопки-кружка и лейбла
    func changeTaskStatus(cell: CustomCell) {

        // Безопасно получаем индекс нужной ячейки
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // Вызываем метод из модели для изменеия статуса нужной задачи
        model.changeState(at: indexPath.row)
        
        // Обновляем таблицу, чтобы отобразить изменения внешнего вида ячейки задачи с новым статусом
        tableView.reloadData()
    }
}
