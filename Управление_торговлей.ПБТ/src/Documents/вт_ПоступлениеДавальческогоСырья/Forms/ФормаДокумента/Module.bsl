&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

 &НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	Если объект.Ссылка.Пустая() ТОгда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Элементы.Партнер.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры


&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	Объект.Партнер = Объект.Контрагент.Партнер;	
КонецПроцедуры


&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	КонтрагентПриИзмененииНаСервере();
КонецПроцедуры

