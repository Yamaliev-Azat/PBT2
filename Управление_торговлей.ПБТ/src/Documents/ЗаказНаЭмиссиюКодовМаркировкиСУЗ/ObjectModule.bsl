
&Вместо("ОбработкаЗаполнения")
Процедура Расш1_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ДанныеПула") Тогда
			ЗаполнитьПоДаннымПулаКодовМаркировки(ДанныеЗаполнения);
		ИначеЕсли ДанныеЗаполнения.Свойство("ЗаказВПроизводство") Тогда
			ЗаполнитьПоЗаказуПроизводства(ДанныеЗаполнения);
		ИначеЕсли ДанныеЗаполнения.Свойство("ОтчетПроизводства") Тогда
			ЗаполнитьПоОтчетуПроизводства(ДанныеЗаполнения);	
		КонецЕсли;
	
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.МаркировкаТоваровИСМП") Тогда
		
		//ЗаполнитьПоВводуВОборот(ДанныеЗаполнения);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПеремаркировкаТоваровИСМП") Тогда
		
		ЗаполнитьПоПеремаркировке(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ЗаполнитьИдентификаторыСтрокТабличнойЧастиТовары();
	
	ЗаполнитьОбъектПоСтатистике();
	
	ИнтеграцияИСМППереопределяемый.ЗаполнитьКодыТНВЭДПоНоменклатуреВТабличнойЧасти(Товары);
	
	//ПроверкаЗаполненияТоварныхПозицийСВозможностьюУдаленияЛишнихСтрок(, Истина);
	
	ЗаполнитьСпособФормированияСерийныхНомеровПоУмолчанию();
	

КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьПоОтчетуПроизводства(ДанныеЗаполнения)
	// Запрос некорректный, Серии заказа на эмиссию нужно заполнять  
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.ЗначенияЗаполнения);
	Запрос.Текст = "ВЫБРАТЬ
	|	вт_ОтчетПроизводстваТовары.Номенклатура КАК Номенклатура,
	|	вт_ОтчетПроизводстваТовары.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА вт_ОтчетПроизводстваТовары.Серия ЕСТЬ NULL
	|			ТОГДА вт_ОтчетПроизводстваСерии.Серия
	|		ИНАЧЕ вт_ОтчетПроизводстваТовары.Серия
	|	КОНЕЦ КАК Серия,
	|	ВЫБОР
	|		КОГДА вт_ОтчетПроизводстваТовары.Серия ЕСТЬ NULL
	|			ТОГДА вт_ОтчетПроизводстваСерии.Количество
	|		ИНАЧЕ вт_ОтчетПроизводстваТовары.Количество
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА вт_ОтчетПроизводстваТовары.Серия ЕСТЬ NULL
	|			ТОГДА вт_ОтчетПроизводстваСерии.Количество
	|		ИНАЧЕ вт_ОтчетПроизводстваТовары.Количество
	|	КОНЕЦ КАК КоличествоУпаковок
	|ИЗ
	|	Документ.вт_ОтчетПроизводства.Товары КАК вт_ОтчетПроизводстваТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.вт_ОтчетПроизводства.Серии КАК вт_ОтчетПроизводстваСерии
	|		ПО вт_ОтчетПроизводстваТовары.КодСтроки = вт_ОтчетПроизводстваСерии.КлючСвязиСтроки
	|			И вт_ОтчетПроизводстваТовары.Ссылка = вт_ОтчетПроизводстваСерии.Ссылка 
	|	ГДЕ вт_ОтчетПроизводстваТовары.Ссылка =&Ссылка  	";	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), Выборка);
	КонецЦикла;
	ОтчетПроизводства = ДанныеЗаполнения.ЗначенияЗаполнения.ПолучитьОбъект();
	Организация = ОтчетПроизводства.Организация;
	ДанныеЗаполнения.Вставить("Организация",ОтчетПроизводства.Организация);
	СпособВводаВОборот = Перечисления.СпособыВводаВОборотСУЗ.Производство;
КонецПроцедуры	

//______________________________________________________________
&НаСервере 
Процедура ЗаполнитьПоЗаказуПроизводства(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.ЗначенияЗаполнения);
	Запрос.Текст = "ВЫБРАТЬ
	               |	вт_ЗаказВПроизводствоТовары.Номенклатура КАК Номенклатура,
	               |	вт_ЗаказВПроизводствоТовары.Характеристика КАК Характеристика,
	               |	вт_ЗаказВПроизводствоТовары.Количество КАК Количество,
	               |	вт_ЗаказВПроизводствоТовары.Количество КАК КоличествоУпаковок
	               |ПОМЕСТИТЬ Продукция
	               |ИЗ
	               |	Документ.вт_ЗаказВПроизводство.Товары КАК вт_ЗаказВПроизводствоТовары
	               |ГДЕ
	               |	вт_ЗаказВПроизводствоТовары.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
	               |	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика,
	               |	ШтрихкодыНоменклатуры.Упаковка КАК Упаковка,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ШтрихкодыНоменклатуры.Штрихкод) КАК КоличествоШтрихкодов
	               |ПОМЕСТИТЬ Штрихкоды
	               |ИЗ
	               |	Продукция КАК Продукция
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	               |		ПО Продукция.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	               |			И Продукция.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	               |			И (ВЫБОР
	               |				КОГДА ШтрихкодыНоменклатуры.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	               |					ТОГДА ИСТИНА
	               |				ИНАЧЕ Продукция.Номенклатура.ЕдиницаИзмерения = ШтрихкодыНоменклатуры.Упаковка
	               |			КОНЕЦ)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ШтрихкодыНоменклатуры.Номенклатура,
	               |	ШтрихкодыНоменклатуры.Характеристика,
	               |	ШтрихкодыНоменклатуры.Упаковка
	               |
	               |ИМЕЮЩИЕ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ШтрихкодыНоменклатуры.Штрихкод) = 1
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Штрихкоды.Номенклатура КАК Номенклатура,
	               |	Штрихкоды.Характеристика КАК Характеристика,
	               |	Штрихкоды.Упаковка КАК Упаковка,
	               |	ШтрихкодыНоменклатуры.Штрихкод КАК GTIN
	               |ПОМЕСТИТЬ ШК2
	               |ИЗ
	               |	Штрихкоды КАК Штрихкоды
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	               |		ПО Штрихкоды.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	               |			И Штрихкоды.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	               |			И Штрихкоды.Упаковка = ШтрихкодыНоменклатуры.Упаковка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Продукция.Номенклатура КАК Номенклатура,
	               |	Продукция.Характеристика КАК Характеристика,
	               |	Продукция.Количество КАК Количество,
	               |	Продукция.КоличествоУпаковок КАК КоличествоУпаковок,
	               |	ШК2.GTIN КАК GTIN,
	               |	ШК2.Упаковка КАК Упаковка
	               |ИЗ
	               |	Продукция КАК Продукция
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ШК2 КАК ШК2
	               |		ПО Продукция.Номенклатура = ШК2.Номенклатура
	               |			И Продукция.Характеристика = ШК2.Характеристика
	               |			И Продукция.Номенклатура.ЕдиницаИзмерения = ШК2.Упаковка";	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), Выборка);
	КонецЦикла;
	ЗаказВПроизводство = ДанныеЗаполнения.ЗначенияЗаполнения.ПолучитьОбъект();
	Организация = ЗаказВПроизводство.Организация;
	ДанныеЗаполнения.Вставить("Организация",ЗаказВПроизводство.Организация);
	СпособВводаВОборот = Перечисления.СпособыВводаВОборотСУЗ.Производство;
	
КонецПроцедуры	