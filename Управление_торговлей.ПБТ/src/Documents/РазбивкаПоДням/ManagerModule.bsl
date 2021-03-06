Функция ПечатьРД(Объект) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.РазбивкаПоДням.ПолучитьМакет("Печать");
	// Заголовок
	Область = Макет.ПолучитьОбласть("Заголовок");
	ТабДок.Вывести(Область);
	// Шапка
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.Заполнить(Объект);
	ТабДок.Вывести(Шапка);
	// Продукция
	Область = Макет.ПолучитьОбласть("ПродукцияШапка");
	ТабДок.Вывести(Область);
	ОбластьПродукция = Макет.ПолучитьОбласть("Продукция");
	Для Каждого ТекСтрокаПродукция Из Объект.Продукция Цикл
		ОбластьПродукция.Параметры.Заполнить(ТекСтрокаПродукция);
		ТабДок.Вывести(ОбластьПродукция);
	КонецЦикла;
	// Подвал
	Подвал = Макет.ПолучитьОбласть("Подвал");
	Подвал.Параметры.Заполнить(Объект);
	ТабДок.Вывести(Подвал);

	ТабДок.ОтображатьСетку = Ложь;
	//ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;

	Возврат ТабДок;
	
КонецФункции