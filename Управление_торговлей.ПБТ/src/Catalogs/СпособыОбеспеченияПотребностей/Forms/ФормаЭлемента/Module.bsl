&Вместо("ЗаполнитьСписокВыбораТипаОбеспечения")
Функция ПБТ_ЗаполнитьСписокВыбораТипаОбеспечения()
	
	//brava 01.04.2021
	//так как у функции нет аннтонации после, то приходится заменять целиком.
	//здесь надо только добавить производство в конце.
	// в модуле подразумевалось, что производство вообще не доступно
	
	// Заполнение списка выбора доступных типов обеспечения.
	СписокВыбора = Новый СписокЗначений;
	
	// Заполняем возможные типы обеспечения в зависимости от функциональных опций.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.Покупка);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеТоваров")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаПеремещение")
		Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.Перемещение);
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСборкуРазборку")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку") Тогда
		СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.СборкаРазборка, НСтр("ru = 'Сборка'"));
	КонецЕсли;
	
	СписокВыбора.Добавить(Перечисления.ТипыОбеспечения.Производство); //brava
	
	Для НомерПереключателя = 1 По 5 Цикл
		ИмяЭлемента = "ТипОбеспечения" + НомерПереключателя;
		Элементы[ИмяЭлемента].СписокВыбора.Очистить();
		Если НомерПереключателя <= СписокВыбора.Количество() Тогда
			ЗначениеВыбора = СписокВыбора.Получить(НомерПереключателя-1);
			Элементы[ИмяЭлемента].СписокВыбора.Добавить(ЗначениеВыбора.Значение, ЗначениеВыбора.Представление);
		Иначе
			Элементы[ИмяЭлемента].Видимость = Ложь;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат СписокВыбора;

КонецФункции
