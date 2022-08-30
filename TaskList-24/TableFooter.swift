//
//  TableFooter.swift
//  TaskList-24
//
///     TASK LIST by zamjay
///     Version 0.9a 2022-08-30
//
//  Created by Zam on 28.08.2022.
//

// MARK: Класс кастомного футера с кнопками (внизу экрана)

import UIKit

// В протоколе указываем делегируемые функции
protocol TableFooterDelegate {
    func add()
    func sort()
    func trash()
}

// Класс кастомного футера с кнопками
class TableFooter: UIView {
    
    // Переменная с делегатом
    var delegate: TableFooterDelegate?

    // Кнопки
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
    // Переменные для подготовки вью футера и именем xib-файла
    var footerView: UIView!
    var xibName = "TableFooter"
    
    // Инициализаторы класс с установкой вью футера
    override init(frame: CGRect) {
        super.init(frame: frame)
        setFooterView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setFooterView()
    }
    
    // Берём вью из xib-файла с указынным ранее именем
    func getFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: xibName, bundle: bundle)
        let view = xib.instantiate(withOwner: self).first as! UIView
        
        return view
    }
    
    // Функция установки вью футера с небольшими настройками
    func setFooterView() {
        footerView = getFromXib()
        footerView.frame = bounds
        footerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Меняем угол поворота кнопки-картинки сортировки на 180 градусов
        // Потому что изначально сортировка от старых задач к новым, и нет противоположной картинки в наборе
        sortButton.transform = CGAffineTransform(rotationAngle: .pi)
        
        // Добавляем готовую вью
        addSubview(footerView)
    }
    
    // Делегируемые функции, выполняемые по нажатию кнопок
    @IBAction func addButtonAction(_ sender: Any) {
        delegate?.add()
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        delegate?.sort()
    }
    
    @IBAction func trashButtonAction(_ sender: Any) {
        delegate?.trash()
    }

}
