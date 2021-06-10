
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    СписокОтчетовПроизводства.Параметры.УстановитьЗначениеПараметра("НачалоПериода", НачалоДня(ТекущаяДата()));
    СписокОтчетовПроизводства.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецДня(ТекущаяДата()));
    СписокОтчетовПроизводства.Параметры.УстановитьЗначениеПараметра("Ответственный", ПользователиКлиентСервер.ТекущийПользователь());
	
	ПолноеИмяОбъекта = РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя();
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
    
    ОповещениеФормы = Новый ОписаниеОповещения("ОбработкаЗакрытияФормыВвода", ЭтаФорма);
    
	//ОткрытьФорму("ВнешняяОбработка.ОтчетыПроизводства.Форма.Форма", ПараметрыФормы, ЭтаФорма , , , , ОповещениеФормы);
	ОткрытьФорму(ПолноеИмяОбъекта + ".Форма.Форма", , , , , , ОповещениеФормы);
    
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаЗакрытияФормыВвода(Параметр, ДополнительныеПараметры) Экспорт 

    Элементы.СписокОтчетовПроизводства.Обновить();

КонецПроцедуры // ОбработкаЗакрытияФормыВвода()

