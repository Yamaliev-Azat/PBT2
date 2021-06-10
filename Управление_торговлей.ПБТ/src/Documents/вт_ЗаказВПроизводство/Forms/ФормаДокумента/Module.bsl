&НаКлиенте
Перем КэшированныеЗначения; 

&НаКлиенте
Процедура ПродукцияНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	//++
	мВесСтруктура = ПолучитьПараметрыВеса(ТекущаяСтрока.Номенклатура);
	Элементы.Товары.ТекущиеДанные.ВесЗаЕдиницу = мВесСтруктура.ВесЕдиницы;
	Элементы.Товары.ТекущиеДанные.ЕдИзмВес = мВесСтруктура.ЕдиницаИзмерения;
	//--
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	ТекущаяСтрока.ВариантПроизводства = ПолучитьВариантПроизводстваПродукции(ТекущаяСтрока.Номенклатура, ТекущаяСтрока.Характеристика);//brava
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВариантПроизводстваПродукции(мНоменклатура, мХарактеристика) //brava
	Возврат вт_ОбщийМодульПроизводства.ПолучитьВариантПроизводстваПродукции(мНоменклатура, мХарактеристика).Ссылка; 
КонецФункции

&НаСервере
Функция ПолучитьПараметрыВеса(мНоменклатура) 
	мСтруктура = Новый Структура("ЕдиницаИзмерения,ВесЕдиницы");
	мЕдиницаИзмерения = мНоменклатура.ВесЕдиницаИзмерения;
	мВесЕдиницы = ?(мНоменклатура.ВесЗнаменатель=0,0,мНоменклатура.ВесЧислитель/мНоменклатура.ВесЗнаменатель);
	Если мНоменклатура.ВесИспользовать Тогда
		мСтруктура.ЕдиницаИзмерения = мЕдиницаИзмерения;
		мСтруктура.ВесЕдиницы = мВесЕдиницы;
	КонецЕсли;	
	Возврат мСтруктура;
КонецФункции

&НаСервере
Процедура ОбновитьСписокОтчетыПроизводства()
	Если ЗначениеЗаполнено(объект.Ссылка) тогда
		СписокОтчетыПроизводства.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Объект.Ссылка);
	Иначе
		СписокОтчетыПроизводства.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Документы.вт_ЗаказВПроизводство.ПустаяСсылка());
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьСтатусЗаказовВПроизводство()
	СрезСтатусов = РегистрыСведений.вт_СтатусыЗаказовВПроизводство.СрезПоследних(ТекущаяДата(),Новый Структура("ЗаказВПроизводство",Объект.Ссылка));
	Если СрезСтатусов.Количество()=0 Тогда
		СтатусЗаказаВПроизводство = Перечисления.вт_СтатусыПроизводства.Ожидание;	
	Иначе
		СтатусЗаказаВПроизводство = СрезСтатусов[0].Статус;
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Если Объект.Статус.Пустая() Тогда
			Объект.Статус = перечисления.вт_СтатусыПроизводства.Ожидание;		
		КонецЕсли;	
		
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация = КонстантыСервер.ПолучитьЗначениеКонстанты("вт_ОрганизацияПроизводства");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
			Объект.Склад = КонстантыСервер.ПолучитьЗначениеКонстанты("вт_СкладПроизводства");
		КонецЕсли;
		
		Если Объект.Автор.Пустая() Тогда
			Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
		КонецЕсли;
		
		Для Каждого СтрокаТовара из Объект.Товары Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТовара.КлючСтроки) Тогда
				СтрокаТовара.КлючСтроки = Новый УникальныйИдентификатор;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТовара.ВариантПроизводства) Тогда
				 ПриИзмененииВариантаПроизводства(СтрокаТовара.КлючСтроки, СтрокаТовара.ВариантПроизводства, СтрокаТовара.Количество, СтрокаТовара.ВесВсего);
			КонецЕсли;	
		КонецЦикла;
		
	КонецЕсли;	
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	ОбновитьСписокОтчетыПроизводства();
	
	ОбновитьСтатусЗаказовВПроизводство();
	
	
КонецПроцедуры

//++
&НаКлиенте
Процедура Печать(Команда)
	
	ТабДок = ПечатьНаСервере();  
	
	ТабДок.ПолеСлева 			   = 5;
	ТабДок.ПолеСправа 			   = 5;
	ТабДок.РазмерКолонтитулаСверху = 0;
	ТабДок.РазмерКолонтитулаСнизу  = 0;
	ТабДок.АвтоМасштаб 		   	   = Истина;
	ТабДок.ОтображатьСетку 	   	   = Ложь;
	ТабДок.ОтображатьЗаголовки     = Ложь;
	ТабДок.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;    
	
	//ТабДок.Показать("Заявка в производство", "ЗаявкаВПроизводство.xls");
	ОбластиОбъектов = Неопределено;
	ИдентификаторПечатнойФормы = "ПФ_ЗаявкаВПроизводство";   	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НСтр("ru = 'ПФ_ЗаявкаВПроизводство'");
	ПечатнаяФорма.ТабличныйДокумент = ТабДок;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НСтр("ru = 'ПФ_ЗаявкаВПроизводство'");	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов); 
	
КонецПроцедуры

&НаСервере
Функция ПечатьНаСервере()
	Возврат Документы.вт_ЗаказВПроизводство.ПечатьЗаказВпроизводство(Объект.Ссылка);	
КонецФункции	

&НаКлиенте
Процедура ПечатьСОстатком(Команда)
	 ТабДок = ПечатьНаСервереСОстатком();  
    
    ТабДок.ПолеСлева 			   = 5;
	ТабДок.ПолеСправа 			   = 5;
	ТабДок.РазмерКолонтитулаСверху = 0;
	ТабДок.РазмерКолонтитулаСнизу  = 0;
	ТабДок.АвтоМасштаб 		   	   = Истина;
    ТабДок.ОтображатьСетку 	   	   = Ложь;
    ТабДок.ОтображатьЗаголовки     = Ложь;
	ТабДок.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;    
    
   // ТабДок.Показать("Заявка в производство с остатком", "ЗаявкаВПроизводствоСОстатком.xls");
    ОбластиОбъектов = Неопределено;
	ИдентификаторПечатнойФормы = "ПФ_ЗаявкаВПроизводствоСОстатком";   	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НСтр("ru = 'ПФ_ЗаявкаВПроизводствоСОстатком'");
	ПечатнаяФорма.ТабличныйДокумент = ТабДок;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НСтр("ru = 'ПФ_ЗаявкаВПроизводствоСОстатком'");	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов); 

КонецПроцедуры

&НаСервере
Функция ПечатьНаСервереСОстатком()
	Возврат Документы.вт_ЗаказВПроизводство.ПечатьЗаказВпроизводствоСОстатком(Объект.Ссылка);	
КонецФункции	


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	//МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВариантПроизводстваПриИзменении(Элемент)
	СтрокаТовара = Элементы.Товары.ТекущиеДанные;
	ПриИзмененииВариантаПроизводства(СтрокаТовара.КлючСтроки, СтрокаТовара.ВариантПроизводства, СтрокаТовара.Количество, СтрокаТовара.ВесВсего);
	ТоварыВесЗаЕдиницуПриИзменении(Элемент);
КонецПроцедуры


&НаКлиенте
Процедура ПродукцияКоличествоПриИзменении(Элемент)
	СтрокаТовара = Элементы.Товары.ТекущиеДанные;
	СтрокаТовара.ВесВсего = СтрокаТовара.Количество * СтрокаТовара.ВесЗаЕдиницу;
	ПриИзмененииКоличестваВеса(СтрокаТовара.КлючСтроки, СтрокаТовара.ВариантПроизводства, СтрокаТовара.Количество, СтрокаТовара.ВесВсего);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыВесЗаЕдиницуПриИзменении(Элемент)
	СтрокаТовара = Элементы.Товары.ТекущиеДанные;
	СтрокаТовара.ВесВсего = СтрокаТовара.Количество * СтрокаТовара.ВесЗаЕдиницу;
	ПриИзмененииКоличестваВеса(СтрокаТовара.КлючСтроки, СтрокаТовара.ВариантПроизводства, СтрокаТовара.Количество, СтрокаТовара.ВесВсего);

	//ПриИзмененииВесВыпуска(СтрокаТовара.КлючСтроки, СтрокаТовара.ВариантПроизводства, СтрокаТовара.ВесВсего);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВесВсегоПриИзменении(Элемент)
	СтрокаТовара = Элементы.Товары.ТекущиеДанные;
	СтрокаТовара.ВесЗаЕдиницу = СтрокаТовара.ВесВсего / СтрокаТовара.Количество;
	ПриИзмененииКоличестваВеса(СтрокаТовара.КлючСтроки, СтрокаТовара.ВариантПроизводства, СтрокаТовара.Количество, СтрокаТовара.ВесВсего);

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииКоличестваВеса(КлючСтроки, ВариантПроизводства, КоличествоВыпуска, ВесВыпуска)
	Если ВариантПроизводства.ЕдИзм.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Вес И ВесВыпуска>0 Тогда
		 ПриИзмененииВесВыпуска(КлючСтроки,ВариантПроизводства, ВесВыпуска);
	Иначе
		 ПриИзмененииКоличестваВыпуска(КлючСтроки,ВариантПроизводства, КоличествоВыпуска);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВариантаПроизводства(КлючСтроки, ВариантПроизводства, КоличествоВыпуска, ВесВыпуска)
	СтрокиТовары = Объект.Товары.НайтиСтроки(Новый Структура("КлючСтроки",КлючСтроки));
	//СтрокиТовары[0].ЕдИзмВес = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("163",,,Справочники.НаборыУпаковок.БазовыеЕдиницыИзмерения); // граммы
	СтрокиТовары[0].ВесЗаЕдиницу = ВариантПроизводства.ВесДетали;
	
	МассивСтрок =  Объект.Сырье.НайтиСтроки(Новый Структура("КлючСвязиСтроки",КлючСтроки));
	Для Каждого СтрокаСырье из МассивСтрок Цикл
		Объект.Сырье.Удалить(СтрокаСырье);
	КонецЦикла;
	
	Для Каждого СтрокаВарианта из ВариантПроизводства.Состав Цикл
		  СтрокаСЫрье = Объект.Сырье.Добавить();
		  СтрокаСЫрье.КлючСвязиСтроки = КлючСтроки;
		  СтрокаСЫрье.Номенклатура = СтрокаВарианта.Сырье;
		  СтрокаСЫрье.Характеристика = СтрокаВарианта.Характеристика;
		  СтрокаСЫрье.ВариантПроизводства = вт_ОбщийМодульПроизводства.ПолучитьВариантПроизводстваПродукции(СтрокаСЫрье.Номенклатура, СтрокаСЫрье.Характеристика).Ссылка;
	КонецЦикла;
	
	//Если тех.карта сделана на вес, то пересчитываем исходя из веса
	ПриИзмененииКоличестваВеса(КлючСтроки, ВариантПроизводства, КоличествоВыпуска, ВесВыпуска);	
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииКоличестваВыпуска(КлючСтроки,ВариантПроизводства, КоличествоВыпуска)
	СоставленНа = ВариантПроизводства.Количество;
	СоставленНаЕдИзм = ВариантПроизводства.ЕдИзм;
	
	Для Каждого СтрокаВарианта из ВариантПроизводства.Состав Цикл
		СтрокиСырье = Объект.Сырье.НайтиСтроки(Новый Структура("КлючСвязиСтроки, Номенклатура",КлючСтроки, СтрокаВарианта.Сырье));
		Если СтрокиСырье.Количество()> 0 Тогда
			 СтрокиСырье[0].Количество = КоличествоВыпуска * СтрокаВарианта.Количество / СоставленНа;
			 СтрокиСырье[0].Сумма = СтрокиСырье[0].Количество * СтрокиСырье[0].Цена; 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВесВыпуска(КлючСтроки,ВариантПроизводства, ВесВыпуска)
	СоставленНа = ВариантПроизводства.Количество;
	СоставленНаЕдИзм = ВариантПроизводства.ЕдИзм;
	
	Для Каждого СтрокаВарианта из ВариантПроизводства.Состав Цикл
		СтрокиСырье = Объект.Сырье.НайтиСтроки(Новый Структура("КлючСвязиСтроки, Номенклатура",КлючСтроки, СтрокаВарианта.Сырье));
		Если СтрокиСырье.Количество()> 0 Тогда
			 СтрокиСырье[0].Количество = ВесВыпуска * СтрокаВарианта.Количество / СоставленНа;
			 СтрокиСырье[0].Сумма = СтрокиСырье[0].Количество * СтрокиСырье[0].Цена; 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	Если Элементы.Товары.ТекущиеДанные = Неопределено ТОгда
		Возврат;
	КонецЕсли;	
	КлючСтроки = Элементы.Товары.ТекущиеДанные.КлючСтроки;
	Элементы.Сырье.ОтборСтрок				= Новый ФиксированнаяСтруктура(Новый Структура("КлючСвязиСтроки",КлючСтроки));
	Элементы.ОперацииПроизводства.ОтборСтрок= Новый ФиксированнаяСтруктура(Новый Структура("КлючСвязиСтроки",КлючСтроки));
		
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элементы.Товары.ТекущиеДанные.КлючСтроки = Новый УникальныйИдентификатор;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

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


&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	Если Элементы.Товары.ТекущиеДанные = Неопределено ТОгда
		Возврат;
	КонецЕсли;	
	УдалитьСтрокиСырьеПоКлючу(Элементы.Товары.ТекущиеДанные.КлючСтроки);
КонецПроцедуры
 
Процедура УдалитьСтрокиСырьеПоКлючу(КлючСтроки)
	МассивСтрок = Объект.Сырье.НайтиСтроки(Новый Структура("КлючСвязиСтроки",КлючСтроки)); 
	Для Каждого СтрокаСырье из МассивСтрок Цикл
		   Объект.Сырье.Удалить(СтрокаСырье);
	КонецЦикла;	
КонецПроцедуры	

&НаКлиенте
Процедура СырьеЦенаПриИзменении(Элемент)
	СтрокаТовара = Элементы.Сырье.ТекущиеДанные;
	СтрокаТовара.Сумма = СтрокаТовара.Количество * СтрокаТовара.Цена;
КонецПроцедуры

&НаКлиенте
Процедура СырьеКоличествоПриИзменении(Элемент)
	СтрокаТовара = Элементы.Сырье.ТекущиеДанные;
	СтрокаТовара.Сумма = СтрокаТовара.Количество * СтрокаТовара.Цена;
КонецПроцедуры

&НаКлиенте
Процедура СырьеСуммаПриИзменении(Элемент)
	СтрокаТовара = Элементы.Сырье.ТекущиеДанные;
	СтрокаТовара.Цена = СтрокаТовара.Сумма / СтрокаТовара.Количество;

КонецПроцедуры

&НаКлиенте
Процедура СписокОтчетыПроизводстваВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(,Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если НачалоДня(Объект.Дата)>НачалоДня(Объект.ТребуемаяДата) ТОгда
		сообщить("Дата документа не должна быть больше требуемой даты");
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КомандаРасчетСебестоимости(Команда)
	КомандаРасчетСебестоимостиНаСервере();
	
	
	Элементы.ТоварыГруппаСебестТовары.Видимость     = Истина;
	Элементы.СырьеГруппаСебестоимостьСырье.Видимость= Истина;
	
КонецПроцедуры


&НаСервере
Процедура КомандаРасчетСебестоимостиНаСервере()
	
	Обр = Обработки.вт_РасчетыПлановойСебестоимости.Создать();
	
	
	для Каждого  СтрокаГП из Объект.Товары Цикл
		
		//Получаем сырье
		МассивСтрокСырье = Объект.Сырье.НайтиСтроки(Новый Структура("КлючСвязиСтроки",СтрокаГП.КлючСтроки));
		
		МассивНоменклХарактеристик = Новый Массив;
		Для Каждого СтрокаТЗ из МассивСтрокСырье Цикл
			Структ = Новый Структура("Номенклатура,Характеристика",СтрокаТЗ.Номенклатура , СтрокаТЗ.Характеристика);
			МассивНоменклХарактеристик.Добавить(Структ);
		КонецЦикла;
		
		//Получаем цены
		ТаблицаЦен = Обр.ПолучитьЦеныПоВариантуРасчета(МассивНоменклХарактеристик, Объект.Организация, ТекущаяДата(),ВариантРасчетаСебестоимость);
		
		//Заполняем таблицу цен
		СуммаПоИзделию = 0;
		Для Каждого СтрокаТЗ из МассивСтрокСырье Цикл
			МассивЦен = ТаблицаЦен.НайтиСтроки(Новый Структура("Номенклатура,Характеристика",СтрокаТЗ.Номенклатура , СтрокаТЗ.Характеристика));
			Для Каждого СтрокаЦен из МассивЦен Цикл
				СтрокаТЗ.Цена = СтрокаЦен.цена;
				СтрокаТЗ.Сумма = СтрокаЦен.цена * СтрокаТЗ.Количество;
			КонецЦикла;	
			СуммаПоИзделию = СуммаПоИзделию + СтрокаТЗ.Сумма;
		КонецЦикла;
		СтрокаГП.Сумма = СуммаПоИзделию;
		СтрокаГП.цена  = СуммаПоИзделию / СтрокаГП.Количество;
		
		//ЗначениеВРеквизитФормы(ДеревоВыпуска,"ДеревоПроизводства");
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСебестоимость(Команда)
	
	Элементы.ТоварыГруппаСебестТовары.Видимость     = НЕ Элементы.ТоварыГруппаСебестТовары.Видимость;
	Элементы.СырьеГруппаСебестоимостьСырье.Видимость= НЕ Элементы.СырьеГруппаСебестоимостьСырье.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьССырьемИОстатком(Команда)
	 ТабДок = ПечатьНаСервереССырьемИОстатком();  
    
    ТабДок.ПолеСлева 			   = 5;
	ТабДок.ПолеСправа 			   = 5;
	ТабДок.РазмерКолонтитулаСверху = 0;
	ТабДок.РазмерКолонтитулаСнизу  = 0;
	ТабДок.АвтоМасштаб 		   	   = Истина;
    ТабДок.ОтображатьСетку 	   	   = Ложь;
    ТабДок.ОтображатьЗаголовки     = Ложь;
	ТабДок.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;    
    
    //ТабДок.Показать("Заявка в производство с сырьем и остатком", "ЗаявкаВПроизводствоССырьемИОстатком.xls");
    ОбластиОбъектов = Неопределено;
	ИдентификаторПечатнойФормы = "ПФ_ЗаявкаВПроизводствоССырьемИОстатком";   	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НСтр("ru = 'ПФ_ЗаявкаВПроизводствоССырьемИОстатком'");
	ПечатнаяФорма.ТабличныйДокумент = ТабДок;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НСтр("ru = 'ПФ_ЗаявкаВПроизводствоССырьемИОстатком'");	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов);
КонецПроцедуры

&НаСервере
Функция ПечатьНаСервереССырьемИОстатком()
	Возврат Документы.вт_ЗаказВПроизводство.ПечатьЗаказВпроизводствоССырьемИОстатком(Объект.Ссылка);	
КонецФункции

&НаКлиенте
Процедура ПечатьЗаказНаряда(Команда)
	 ТабДок = ПечатьНаСервереЗаказНаряда();
	 
    ТабДок.ПолеСлева 			   = 5;
	ТабДок.ПолеСправа 			   = 5;
	ТабДок.РазмерКолонтитулаСверху = 0;
	ТабДок.РазмерКолонтитулаСнизу  = 0;
	ТабДок.АвтоМасштаб 		   	   = Истина;
    ТабДок.ОтображатьСетку 	   	   = Ложь;
    ТабДок.ОтображатьЗаголовки     = Ложь;
	ТабДок.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;    

	//ТабДок.Показать("Заказ-наряд", "Заказ_наряд.xls");
	ОбластиОбъектов = Неопределено;
	ИдентификаторПечатнойФормы = "ПФ_ЗаказНаряда";   	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НСтр("ru = 'ПФ_ЗаказНаряда'");
	ПечатнаяФорма.ТабличныйДокумент = ТабДок;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НСтр("ru = 'ПФ_ЗаказНаряда'");	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов);	
КонецПроцедуры

&НаСервере
Функция ПечатьНаСервереЗаказНаряда()
	Возврат Документы.вт_ЗаказВПроизводство.ПечатьЗаказНаряда(Объект.Ссылка);
КонецФункции


&НаКлиенте
Процедура ОбновитьСписокОтчетыПроизводства1(Команда)
	ОбновитьСписокОтчетыПроизводства();
КонецПроцедуры


&НаКлиенте
Процедура ОперацииПроизводстваПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.ОперацииПроизводства.ТекущиеДанные;
	Если ТекДанные = Неопределено ТОгда
		Возврат;
	КонецЕсли;	
	
	КлючСвязиСтроки   = ТекДанные.КлючСвязиСтроки;
	КодСтрокиОперации = ТекДанные.КодСтроки;
	
	Элементы.РасходСырьяНаОперации.ОтборСтрок	= Новый ФиксированнаяСтруктура(
														Новый Структура("КлючСвязиСтроки,КодСтрокиОперации",
																		 КлючСвязиСтроки, КодСтрокиОперации));
КонецПроцедуры


&НаКлиенте
Процедура ОперацииПроизводстваПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекДанныеТовары = Элементы.Товары.ТекущиеДанные;
	Если ТекДанныеТовары = Неопределено ТОгда
		Возврат;
	КонецЕсли;	
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.КодСтроки = Новый УникальныйИдентификатор;
		Элемент.ТекущиеДанные.КлючСвязиСтроки = ТекДанныеТовары.КлючСтроки;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура РасходСырьяНаОперацииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекДанныеОперации = Элементы.ОперацииПроизводства.ТекущиеДанные;
	Если ТекДанныеОперации = Неопределено ТОгда
		Возврат;
	КонецЕсли;	
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.КодСтрокиОперации = ТекДанныеОперации.КодСтроки;
		Элемент.ТекущиеДанные.КлючСвязиСтроки = ТекДанныеОперации.КлючСвязиСтроки;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура РасходСырьяНаОперацииНоменклатураНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
КонецПроцедуры


&НаКлиенте
Процедура РасходСырьяНаОперацииНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекДанныеТовары = Элементы.Товары.ТекущиеДанные;
	Если ТекДанныеТовары = Неопределено ТОгда
		Возврат;
	КонецЕсли;	
	
	Элемент.СписокВыбора.очистить();
	
	//Получить сырье текущей готовой продукции
	МассивСтрокСырье = Объект.Сырье.НайтиСтроки(Новый Структура("КлючСвязиСтроки",ТекДанныеТовары.КлючСтроки));
	Для Каждого СтрокаСырье из МассивСтрокСырье Цикл
		Элемент.СписокВыбора.добавить(СтрокаСырье.Номенклатура);
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура РасходСырьяНаОперацииНоменклатураПриИзменении(Элемент)
	ТекДанныеТовары = Элементы.Товары.ТекущиеДанные;
	Если ТекДанныеТовары = Неопределено ТОгда
		Возврат;
	КонецЕсли;	
	ТекДанныеОперацииСырье = Элементы.РасходСырьяНаОперации.ТекущиеДанные;
	Если ТекДанныеОперацииСырье = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоменклСырье = ТекДанныеОперацииСырье.Номенклатура;
	ХарактеристикаСырье = ТекДанныеОперацииСырье.Характеристика;
	
	КлючСтрокиГП = ТекДанныеТовары.КлючСтроки;
	
	МассивСтрокСырье = Объект.Сырье.НайтиСтроки(Новый Структура("КлючСвязиСтроки,Номенклатура,Характеристика",
												КлючСтрокиГП, НоменклСырье, ХарактеристикаСырье));
	
	Количествосырья = 0;
	Для Каждого СтрокаСтрокСырье из МассивСтрокСырье Цикл
		Количествосырья = Количествосырья + СтрокаСтрокСырье.Количество;
	КонецЦикла;
	
	ТекДанныеОперацииСырье.Количество = Количествосырья;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованию(Команда)
	
	ЗаполнитьПоОснованиюНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ОбработкаЗаполнения(Объект.ДокументОснование, Истина);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	//brava - странно но сырье не заполнялось в обработке заполнения. 
	//Все расчеты - прямо в форме
	Для Каждого СтрокаТовара из Объект.Товары Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТовара.КлючСтроки) Тогда
			СтрокаТовара.КлючСтроки = Новый УникальныйИдентификатор;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТовара.ВариантПроизводства) Тогда
			ПриИзмененииВариантаПроизводства(СтрокаТовара.КлючСтроки, СтрокаТовара.ВариантПроизводства, СтрокаТовара.Количество, СтрокаТовара.ВесВсего);
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

