Процедура ЗаполнитьЦеныВариантаИзДерева(пДерево) Экспорт
	Для Каждого СтрокаДерева из пДерево.Строки Цикл
		МассивСтрок = ЭтотОбъект.Состав.НайтиСтроки(Новый Структура("Сырье",СтрокаДерева.Номенклатура));
		Для Каждого СтрокаСОстава из МассивСтрок Цикл
			СтрокаСОстава.Цена = СтрокаДерева.Цена;
			СтрокаСОстава.Сумма = СтрокаДерева.Сумма;
		КонецЦикла;
		
		МассивСтрок = ЭтотОбъект.Операции.НайтиСтроки(Новый Структура("Операция",СтрокаДерева.Номенклатура));
		Для Каждого СтрокаСОстава из МассивСтрок Цикл
			СтрокаСОстава.Цена = СтрокаДерева.Цена;
			СтрокаСОстава.Сумма = СтрокаДерева.Сумма;
		КонецЦикла;
		
	КонецЦикла;	
	
	
	СуммаВерхСтрок = пДерево.Строки.Итог("Сумма",Ложь);
	ЭтотОбъект.Стоимость = СуммаВерхСтрок / ЭтотОбъект.Количество;
	
КонецПроцедуры	

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();	
	КонецЕсли; 

	Если Не ЭтоГруппа Тогда
		
		Если Основной И Не Ссылка.Основной Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Таблица.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.вт_ВариантыПроизводстваПоТехКартам КАК Таблица
			|ГДЕ
			|	Таблица.Владелец         = &Владелец
			|   И Таблица.Характеристика = &Характеристика
			|	И Таблица.Основной
			|	И Таблица.Ссылка <> &Ссылка
			|");
			Запрос.УстановитьПараметр("Владелец", Владелец);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.УстановитьПараметр("Характеристика", Ссылка.Характеристика);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Объект = Выборка.Ссылка.ПолучитьОбъект();
				Объект.Основной = Ложь;
				Объект.Записать();
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли; 

	ЭтотОбъект.Наименование = ЭтотОбъект.Владелец.Наименование+" "+ЭтотОбъект.НомерРецепта+" "+ЭтотОбъект.Статус;
	
КонецПроцедуры

Процедура ПриКопировании()
	Если Основной Тогда
		Основной = Ложь;
	КонецЕсли;	
КонецПроцедуры	

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	////МассивНепроверяемыхРеквизитов = Новый Массив;
	//
	//Если НЕ ЭтоГруппа Тогда
	//	//МассивНепроверяемыхРеквизитов.Добавить("Владелец");
	//	ПроверяемыеРеквизиты.Добавить("Владелец");
	//КонецЕсли;	
	//
	////ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры
