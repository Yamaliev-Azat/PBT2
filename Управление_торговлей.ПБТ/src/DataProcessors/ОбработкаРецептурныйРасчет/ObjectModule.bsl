Функция СведенияОВнешнейОбработке() Экспорт

	РегистрационныеДанные = Новый Структура;
	РегистрационныеДанные.Вставить("Вид", "ДополнительнаяОбработка");
	РегистрационныеДанные.Вставить("Наименование", "Рецептурный расчет");
	РегистрационныеДанные.Вставить("Версия", "1.0");
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Информация", "Рецептурный расчет");
	ТЗКоманды = Новый ТаблицаЗначений;
	ТЗКоманды.Колонки.Добавить("Идентификатор");
	ТЗКоманды.Колонки.Добавить("Представление");
	ТЗКоманды.Колонки.Добавить("Модификатор");
	ТЗКоманды.Колонки.Добавить("ПоказыватьОповещение");
	ТЗКоманды.Колонки.Добавить("Использование");    
	СтрокаКоманды = ТЗКоманды.Добавить();
	СтрокаКоманды.Представление = "Рецептурный расчет";
	СтрокаКоманды.ПоказыватьОповещение = Ложь;
	СтрокаКоманды.Использование = "ОткрытиеФормы";
	СтрокаКоманды.Идентификатор = "Рецептурный расчет";    
	РегистрационныеДанные.Вставить("Команды", ТЗКоманды);    
	Возврат РегистрационныеДанные;
	
КонецФункции

Функция ПечатьРецепт() Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	Макет = ЭтотОбъект.ПолучитьМакет("Макет");
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Номенклатура = Номенклатура;
	ОбластьМакета.Параметры.НомерПартии = СокрЛП(НомерПартии);
	ОбластьМакета.Параметры.Дата = Формат(Дата, "ДФ=dd.MM.yyyy");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Для каждого ТекСтрока из Товары Цикл
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		ОбластьМакета.Параметры.Номенклатура = ТекСтрока.Номенклатура;
		ОбластьМакета.Параметры.КоличествоНаНесколькоТонн = ТекСтрока.КоличествоНаНесколькоТонн;
		ОбластьМакета.Параметры.Количество = ТекСтрока.Количество;
		
		ОбластьМакета.Параметры.СоставЖир = ТекСтрока.СоставЖир;
		ОбластьМакета.Параметры.СоставСОМО = ТекСтрока.СоставСОМО;
		ОбластьМакета.Параметры.СоставСахар = ТекСтрока.СоставСахар;
		ОбластьМакета.Параметры.СоставСВ = ТекСтрока.СоставСВ;
		
		ОбластьМакета.Параметры.Жир = ТекСтрока.Жир;
		ОбластьМакета.Параметры.СОМО = ТекСтрока.СОМО;
		ОбластьМакета.Параметры.Сахар = ТекСтрока.Сахар;
		ОбластьМакета.Параметры.СВ = ТекСтрока.СВ;
		
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	ОбластьМакета = Макет.ПолучитьОбласть("СтрокаПусто");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("СтрокаВода");
	ВодаКоличествоНаНесколькоТонн = (1000 - Товары.Итог("Количество"))*Количество / 1000;
	ВодаКоличество = 1000-Товары.Итог("Количество");
	ОбластьМакета.Параметры.КоличествоНаНесколькоТонн = (1000 - Товары.Итог("Количество"))*Количество / 1000;
	ОбластьМакета.Параметры.Количество = ""+Формат(1000-Товары.Итог("Количество"),"ЧДЦ=3")+" кг.";
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Всего");
	ОбластьМакета.Параметры.КоличествоНаНесколькоТонн = Товары.Итог("КоличествоНаНесколькоТонн") + ВодаКоличествоНаНесколькоТонн;
	ОбластьМакета.Параметры.Количество = ""+(Товары.Итог("Количество")+ВодаКоличество)+" кг.";
	
	ОбластьМакета.Параметры.Жир = Товары.Итог("Жир")/100;
	ОбластьМакета.Параметры.СОМО = Товары.Итог("СОМО")/100;
	ОбластьМакета.Параметры.Сахар = Товары.Итог("Сахар")/100;
	ОбластьМакета.Параметры.СВ = Товары.Итог("СВ")/100;
	
	ОбластьМакета.Параметры.СодержаниеЖир = СодержаниеЖир;
	ОбластьМакета.Параметры.СодержаниеСОМО = СодержаниеСОМО;
	ОбластьМакета.Параметры.СодержаниеСахар = СодержаниеСахар;
	ОбластьМакета.Параметры.СодержаниеСВ = СодержаниеСВ;
	ОбластьМакета.Параметры.Кислотность = Кислотность;
	
	ОбластьМакета.Параметры.Дата = Формат(Дата, "ДФ=dd.MM.yyyy");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Возврат ТабДокумент;
	
КонецФункции