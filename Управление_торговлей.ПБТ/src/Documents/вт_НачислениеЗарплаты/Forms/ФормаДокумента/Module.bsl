
&НаКлиенте
Процедура МесяцНачисленияПриИзменении(Элемент)
	Объект.МесяцНачисления = НачалоМесяца(Объект.МесяцНачисления);
КонецПроцедуры

&НаСервере
Процедура КомандаЗаполнитьПоВыработкеЗаПериодНаСервере()

 Запрос = Новый Запрос("ВЫБРАТЬ
                       |	вт_ВыработкаСотрудников.Сотрудник КАК Сотрудник,
                       |	СУММА(вт_ВыработкаСотрудников.Сумма) КАК Сумма,
                       |	вт_ВыработкаСотрудников.Основание КАК Основание
                       |ИЗ
                       |	РегистрНакопления.вт_ВыработкаСотрудников КАК вт_ВыработкаСотрудников
                       |ГДЕ
                       |	вт_ВыработкаСотрудников.Период МЕЖДУ &НачалоПериода И &КонецПериода
                       |	И вт_ВыработкаСотрудников.Организация = &Организация
                       |	И (вт_ВыработкаСотрудников.Подразделение = &Подразделение
                       |			ИЛИ &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))
                       |
                       |СГРУППИРОВАТЬ ПО
                       |	вт_ВыработкаСотрудников.Сотрудник,
                       |	вт_ВыработкаСотрудников.Основание
                       |ИТОГИ
                       |	СУММА(Сумма)
                       |ПО
                       |	Сотрудник");
 
 //   
 //Запрос = Новый Запрос("ВЫБРАТЬ
 //                      |	вт_ВыработкаСотрудников.Сотрудник КАК Сотрудник,
 //                      |	СУММА(вт_ВыработкаСотрудников.Сумма) КАК Сумма
 //                      |ИЗ
 //                      |	РегистрНакопления.вт_ВыработкаСотрудников КАК вт_ВыработкаСотрудников
 //                      |ГДЕ
 //                      |	вт_ВыработкаСотрудников.Период МЕЖДУ &НачалоПериода И &КонецПериода
 //                      |	И вт_ВыработкаСотрудников.Организация = &Организация
 //                      |	И (вт_ВыработкаСотрудников.Подразделение = &Подразделение
 //                      |			ИЛИ &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))
 //                      |
 //                      |СГРУППИРОВАТЬ ПО
 //                      |	вт_ВыработкаСотрудников.Сотрудник");
 //
 Запрос.УстановитьПараметр("Организация",Объект.Организация);
 Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Объект.МесяцНачисления));
 Запрос.УстановитьПараметр("КонецПериода",КонецМесяца(Объект.МесяцНачисления));
 Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
 
 
 Объект.Начисления.Очистить();
 Объект.ДанныеВыработки.Очистить();
 
 ВыборкаСотрудники = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
 
 Пока ВыборкаСотрудники.Следующий() Цикл
	 СтрокаНачисления = Объект.Начисления.Добавить();
	 СтрокаНачисления.ФизическоеЛицо = ВыборкаСотрудники.Сотрудник;
	 СтрокаНачисления.СуммаНачисления = ВыборкаСотрудники.Сумма;
	 
	 ВыборкаДетальные = ВыборкаСотрудники.Выбрать();
	 
	 Пока ВыборкаДетальные.Следующий() Цикл
		        СтрокаВырабокта = Объект.ДанныеВыработки.Добавить();
				СтрокаВырабокта.ФизическоеЛицо = ВыборкаДетальные.Сотрудник;
				СтрокаВырабокта.Основание      =  ВыборкаДетальные.Основание;
				СтрокаВырабокта.Сумма          =  ВыборкаДетальные.Сумма;
	 КонецЦикла;	            
 КонецЦикла;
 
 
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьПоВыработкеЗаПериод(Команда)
	КомандаЗаполнитьПоВыработкеЗаПериодНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.Начисления.ТекущиеДанные;
	ФизЛицо = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	
	Если ТекДанные<>Неопределено тогда
		ФизЛицо = ТекДанные.ФизическоеЛицо;
	КонецЕсли;
	
	Элементы.ДанныеВыработки.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ФизическоеЛицо",ФизЛицо));
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеВыработкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ТекДанные = Элементы.Начисления.ТекущиеДанные;
	ФизЛицо = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	
	Если ТекДанные=Неопределено тогда
		Сообщить("Выберите строку в таблице начисления!");
		Отказ=Истина;
	КонецЕсли;
	
	
	ФизЛицо = ТекДанные.ФизическоеЛицо;
	Если Не ЗначениеЗаполнено(ФизЛицо) Тогда
		Сообщить("Укажите сотрудника в строке в таблице начисления!");
		Отказ=Истина;
	КонецЕсли;	
	
	Элементы.Начисления.Обновить();
	Элементы.ДанныеВыработки.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ФизическоеЛицо",ФизЛицо));
	ЭтаФорма.ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеВыработкиПередНачаломИзменения(Элемент, Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ДанныеВыработкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока ТОгда 
		ТекДанные = Элементы.Начисления.ТекущиеДанные;
		ТекДанныеВыработки = Элементы.ДанныеВыработки.ТекущиеДанные;
		ТекДанныеВыработки.ФизическоеЛицо = ТекДанные.ФизическоеЛицо;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьСуммуПоФизЛицу()
	
	ТекДанные = Элементы.Начисления.ТекущиеДанные;
	
	ФизЛицо = ТекДанные.ФизическоеЛицо;
	СуммаФизЛицо = 0;
	СтрокиПоФизЛицу = Объект.ДанныеВыработки.НайтиСтроки(Новый Структура("ФизическоеЛицо",ФизЛицо));
	Для Каждого СтрокаФИзлицо из СтрокиПоФизЛицу Цикл 
		СуммаФизЛицо = СуммаФизЛицо + СтрокаФИзлицо.Сумма;
	КонецЦикла;
	
	ТекДанные.СуммаНачисления =  СуммаФизЛицо;
	ЭтаФорма.ОбновитьОтображениеДанных();

КонецПроцедуры

&НаКлиенте
Процедура ДанныеВыработкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	 ОбновитьСуммуПоФизЛицу();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеВыработкиПослеУдаления(Элемент)
	ОбновитьСуммуПоФизЛицу();
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПередУдалением(Элемент, Отказ)
	
	
	ТекДанные = Элементы.Начисления.ТекущиеДанные;
	
	ФизЛицо = ТекДанные.ФизическоеЛицо;
	СтрокиПоФизЛицу = Объект.ДанныеВыработки.НайтиСтроки(Новый Структура("ФизическоеЛицо",ФизЛицо));
	Для Каждого СтрокаФИзлицо из СтрокиПоФизЛицу Цикл 
		Объект.ДанныеВыработки.Удалить(СтрокаФИзлицо);
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеВыработкиХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ТипЗнч(ЭтаФорма.Элементы.ДанныеВыработки.ТекущиеДанные.Основание) <> Тип("СправочникСсылка.Номенклатура") Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;	
КонецПроцедуры
