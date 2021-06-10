// Функция определяет реквизиты выбранного документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВнутреннееПотреблениеТоваров - Ссылка на документ
//
// Возвращаемое значение:
//	Структура - реквизиты внутреннего потребления товаров
//
Функция ПолучитьРеквизитыДокумента(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.вт_ПланСборки КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Дата = Выборка.Дата;
		Организация = Выборка.Организация;
	Иначе
		Дата = Дата(1,1,1);
		Организация = Неопределено;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("Дата, Организация",
		Дата,
		Организация,
	);
	
	Возврат СтруктураРеквизитов;

КонецФункции // ПолучитьРеквизитыДокумента()
