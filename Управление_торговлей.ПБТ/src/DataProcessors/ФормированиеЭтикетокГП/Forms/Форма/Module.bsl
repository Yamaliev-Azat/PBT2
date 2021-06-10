
&НаСервере
Процедура ЗаполнитьТаблицуНаСервере()
	
	Если Не ЗначениеЗаполнено(НаДату) Тогда
		ОбщегоНазначения.СообщитьПользователю("Не выбрана дата!");
		Возврат;
	КонецЕсли; 
	
	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Печатать,
	|	МаршрутныйЛист.Ссылка КАК Ссылка,
	|	МаршрутныйЛист.Номенклатура КАК Номенклатура,
	|	МаршрутныйЛист.Количество КАК Количество,
	|	МаршрутныйЛист.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	МаршрутныйЛист.НомерСменыЗамеса КАК НомерСменыЗамеса,
	|	МаршрутныйЛист.Дата КАК ДатаИзготовления,
	|	МаршрутныйЛист.Серия КАК Серия,
	|	МаршрутныйЛист.Линия КАК Линия,
	|	МаршрутныйЛист.СрокГодности КАК ГоденДо,
	|	Штрихкоды.Штрихкод КАК Штрихкод,
	|	СпрУпаковки.Ссылка КАК Упаковка,
	|	СпрУпаковки.Вес КАК Масса,
	|	СпрУпаковки.КоличествоУпаковок КАК КоличествоУпаковок
	|ИЗ
	|	Документ.МаршрутныйЛист КАК МаршрутныйЛист
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК СпрУпаковки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК Штрихкоды
	|			ПО СпрУпаковки.Ссылка = Штрихкоды.Упаковка
	|		ПО МаршрутныйЛист.Номенклатура = СпрУпаковки.Владелец
	|			И (СпрУпаковки.ПометкаУдаления = ЛОЖЬ)
	|ГДЕ
	|	МаршрутныйЛист.Ссылка.Дата МЕЖДУ &НачПериода И &КонПериода
	|	И МаршрутныйЛист.Ссылка.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	МаршрутныйЛист.Ссылка,
	|	СпрУпаковки.Ссылка,
	|	Штрихкоды.Штрихкод,
	|	МаршрутныйЛист.Номенклатура,
	|	МаршрутныйЛист.Количество,
	|	МаршрутныйЛист.ХарактеристикаНоменклатуры,
	|	МаршрутныйЛист.НомерСменыЗамеса,
	|	МаршрутныйЛист.Дата,
	|	МаршрутныйЛист.Серия,
	|	МаршрутныйЛист.Линия,
	|	МаршрутныйЛист.СрокГодности,
	|	СпрУпаковки.Вес,
	|	СпрУпаковки.КоличествоУпаковок
	|
	|УПОРЯДОЧИТЬ ПО
	|	Линия,
	|	Номенклатура,
	|	НомерСменыЗамеса,
	|	ЕдиницаИзмерения
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("КонПериода", КонецДня(НаДату));
	Запрос.УстановитьПараметр("НачПериода", НаДату);
	//Запрос.УстановитьПараметр("Кг", Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("166"));
	//Запрос.УстановитьПараметр("Паллет", Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("900"));
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетали = Результат.Выбрать();
	
	
	Пока ВыборкаДетали.Следующий() Цикл
		НовСтр = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаДетали);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицу(Команда)
	ЗаполнитьТаблицуНаСервере();
КонецПроцедуры

&НаСервере
Функция НапечататьНаСервере()
	
	ТабДок = Новый ТабличныйДокумент;
	
	КартинкаЗонтик = БиблиотекаКартинок.Зонтик;
	КартинкаХаляль = БиблиотекаКартинок.Халяль;
	КартинкаПетля = БиблиотекаКартинок.Петля;
	
	//КГ = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("166");
	
	Для каждого СтрТовары Из Объект.Товары Цикл
		
		Если Не СтрТовары.Печатать Тогда
			Продолжить;
		КонецЕсли; 
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	НоменклатураСпр.Ссылка КАК Номенклатура,
		               |	НоменклатураСпр.НаименованиеПолное КАК Назв,
		               |	СвБольшиеБуквыВНазвании.Значение КАК БольшиеБуквыВНазвании,
		               |	СвОбластьПрименения.Значение КАК ОбластьПрименения,
		               |	СвСостав.Значение КАК Состав,
		               |	СвСледы.Значение КАК Следы,
		               |	СвДозировка.Значение КАК Дозировка,
		               |	СвСрокГодности.Значение КАК СрокГодности,
		               |	СвУсловияХранения.Значение КАК УсловияХранения,
		               |	СвЗонтик.Значение КАК Зонтик,
		               |	НоменклатураСпр.ТУ КАК ТУ,
		               |	СвБезГМО.Значение КАК БезГМО,
		               |	СвЭнергетическаяЦенность.Значение КАК ЭнергетическаяЦенность,
		               |	СвПищеваяЦенность.Значение КАК ПищеваяЦенность,
		               |	СвДопИнформация.Значение КАК ДопИнформация,
		               |	СвБольшиеБуквыВНазванииКакДолжноБыть.Значение КАК БольшиеБуквыВНазванииКакДолжноБыть,
		               |	НоменклатураСпр.Артикул КАК Артикул,
		               |	СвПетля.Значение КАК Петля,
		               |	СвАдрес.Значение КАК Адрес,
		               |	КатегорияХаляль.Значение КАК Халяль,
		               |	КатегорияХаляль.Свойство КАК Свойство,
		               |	СвУгловыеБуквы.Значение КАК УгловыеБуквы
		               |ИЗ
		               |	Справочник.Номенклатура КАК НоменклатураСпр
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвБольшиеБуквыВНазвании
		               |		ПО НоменклатураСпр.Ссылка = СвБольшиеБуквыВНазвании.Объект
		               |			И (СвБольшиеБуквыВНазвании.Свойство = &СвБольшиеБуквы)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвАдрес
		               |		ПО НоменклатураСпр.Ссылка = СвАдрес.Объект
		               |			И (СвАдрес.Свойство = &Св_Адрес)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвБезГМО
		               |		ПО НоменклатураСпр.Ссылка = СвБезГМО.Объект
		               |			И (СвБезГМО.Свойство = &Св_БезГМО)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвБольшиеБуквыВНазванииКакДолжноБыть
		               |		ПО НоменклатураСпр.Ссылка = СвБольшиеБуквыВНазванииКакДолжноБыть.Объект
		               |			И (СвБольшиеБуквыВНазванииКакДолжноБыть.Свойство = &Св_БольшиеБуквыВНазванииКакДолжноБыть)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвДозировка
		               |		ПО НоменклатураСпр.Ссылка = СвДозировка.Объект
		               |			И (СвДозировка.Свойство = &Св_Дозировка)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвДопИнформация
		               |		ПО НоменклатураСпр.Ссылка = СвДопИнформация.Объект
		               |			И (СвДопИнформация.Свойство = &Св_ДопИнформация)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвЗонтик
		               |		ПО НоменклатураСпр.Ссылка = СвЗонтик.Объект
		               |			И (СвЗонтик.Свойство = &Св_Зонтик)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвОбластьПрименения
		               |		ПО НоменклатураСпр.Ссылка = СвОбластьПрименения.Объект
		               |			И (СвОбластьПрименения.Свойство = &Св_ОбластьПрименения)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвПетля
		               |		ПО НоменклатураСпр.Ссылка = СвПетля.Объект
		               |			И (СвПетля.Свойство = &Св_Петля)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвПищеваяЦенность
		               |		ПО НоменклатураСпр.Ссылка = СвПищеваяЦенность.Объект
		               |			И (СвПищеваяЦенность.Свойство = &Св_ПищеваяЦенность)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвСледы
		               |		ПО НоменклатураСпр.Ссылка = СвСледы.Объект
		               |			И (СвСледы.Свойство = &Св_Следы)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвСостав
		               |		ПО НоменклатураСпр.Ссылка = СвСостав.Объект
		               |			И (СвСостав.Свойство = &Св_Состав)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвУгловыеБуквы
		               |		ПО НоменклатураСпр.Ссылка = СвУгловыеБуквы.Объект
		               |			И (СвУгловыеБуквы.Свойство = &Св_УгловыеБуквы)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвУсловияХранения
		               |		ПО НоменклатураСпр.Ссылка = СвУсловияХранения.Объект
		               |			И (СвУсловияХранения.Свойство = &Св_УсловияХранения)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвСрокГодности
		               |		ПО НоменклатураСпр.Ссылка = СвСрокГодности.Объект
		               |			И (СвСрокГодности.Свойство = &Св_СрокГодности)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК СвЭнергетическаяЦенность
		               |		ПО НоменклатураСпр.Ссылка = СвЭнергетическаяЦенность.Объект
		               |			И (СвЭнергетическаяЦенность.Свойство = &Св_ЭнергетическаяЦенность)
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК КатегорияХаляль
		               |		ПО НоменклатураСпр.Ссылка = КатегорияХаляль.Объект
		               |			И (КатегорияХаляль.Свойство = &КатХаляль)
		               |ГДЕ
		               |	НоменклатураСпр.Ссылка = &Номенклатура";
		
		Запрос.УстановитьПараметр("Номенклатура", СтрТовары.Номенклатура);
		Запрос.УстановитьПараметр("КатХаляль", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "Качество_Халяль"));
		Запрос.УстановитьПараметр("СвБольшиеБуквы", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "БольшиеБуквыВНазвании"));
		
		Запрос.УстановитьПараметр("Св_Адрес", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "Адрес"));
		Запрос.УстановитьПараметр("Св_БезГМО", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "БезГМО"));
		Запрос.УстановитьПараметр("Св_БольшиеБуквыВНазванииКакДолжноБыть", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "БольшиеБуквыВНазванииКакДолжноБыть"));
		Запрос.УстановитьПараметр("Св_Дозировка", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "Дозировка"));
		Запрос.УстановитьПараметр("Св_ДопИнформация", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "ДопИнформация"));
		Запрос.УстановитьПараметр("Св_Зонтик", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "Зонтик"));
		Запрос.УстановитьПараметр("Св_ОбластьПрименения", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "ОбластьПрименения"));
		Запрос.УстановитьПараметр("Св_Петля", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "Петля"));
		Запрос.УстановитьПараметр("Св_ПищеваяЦенность", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "ПищеваяЦенность"));
		Запрос.УстановитьПараметр("Св_Следы", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "Следы"));
		Запрос.УстановитьПараметр("Св_Состав", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "Состав"));
		Запрос.УстановитьПараметр("Св_УгловыеБуквы", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "УгловыеБуквы"));
		Запрос.УстановитьПараметр("Св_УсловияХранения", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "УсловияХранения"));
		Запрос.УстановитьПараметр("Св_СрокГодности", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "СрокГодности"));
		Запрос.УстановитьПараметр("Св_ЭнергетическаяЦенность", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "ЭнергетическаяЦенность"));
		
		//Запрос.УстановитьПараметр("Св_ТУ", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("ИдентификаторДляФормул", "ЭнергетическаяЦенность"));
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Если СтрТовары.ДляКоробов Тогда 
				Макет = Обработки.ФормированиеЭтикетокГП.ПолучитьМакет("ЭтикеткаКороб");
				ОбластьНиз = Макет.ПолучитьОбласть("Низ|Верт");
				Если ЗначениеЗаполнено(СтрТовары.ШтрихКод) Тогда
					
					РисунокШтрихкодаИсточник = ОбластьНиз.Рисунки.Штрихкод;
					///***
					РисунокШтрихкода = ОбластьНиз.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
					ПечатьШК.СформироватьШК(РисунокШтрихкода, РисунокШтрихкодаИсточник, ОбластьНиз, СтрТовары.ШтрихКод);
					
				КонецЕсли;
				
			Иначе
				
				//не короб
				Если ЗначениеЗаполнено(СтрТовары.ШтрихКод) Тогда
					Макет = Обработки.ФормированиеЭтикетокГП.ПолучитьМакет("Этикетка");
					ОбластьНиз = Макет.ПолучитьОбласть("Низ|Верт");
					РисунокШтрихкодаИсточник = ОбластьНиз.Рисунки.Штрихкод;
					///***
					РисунокШтрихкода = ОбластьНиз.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
					ПечатьШК.СформироватьШК(РисунокШтрихкода, РисунокШтрихкодаИсточник, ОбластьНиз, СтрТовары.ШтрихКод);
				Иначе
					Макет = Обработки.ФормированиеЭтикетокГП.ПолучитьМакет("ЭтикеткаБезШК");
					ОбластьНиз = Макет.ПолучитьОбласть("Низ|Верт");
				КонецЕсли;	
			КонецЕсли; 
			
			ОбластьЭтик = Макет.ПолучитьОбласть("Этикетка|Верт");
			ОбластьЭтик.Параметры.Заполнить(Выборка);
			ОбластьЭтик.Параметры.Назв = СтрЗаменить(Выборка.Назв, Выборка.БольшиеБуквыВНазвании, "");
			
			Если ЗначениеЗаполнено(Выборка.БольшиеБуквыВНазванииКакДолжноБыть) Тогда
				ОбластьЭтик.Параметры.БольшиеБуквыВНазвании = Выборка.БольшиеБуквыВНазванииКакДолжноБыть;
			Иначе	
				ОбластьЭтик.Параметры.БольшиеБуквыВНазвании = ВРЕГ(СтрЗаменить(Выборка.БольшиеБуквыВНазвании, """",""));
			КонецЕсли; 
			
			Если СтрТовары.ДляКоробов Тогда  
				//короб
				Если СтрТовары.Петля = Истина Тогда //09.07.20 Юрьева попросила галочку пренести в обработку
					ОбластьЭтик.Рисунки.КартинкаПетля.Картинка = КартинкаПетля;	
				КонецЕсли;
				//Если Выборка.Зонтик = Истина Тогда
				Если СтрТовары.Зонтик = Истина Тогда //07.10.20 Юрьева попросила галочку пренести в обработку
					ОбластьЭтик.Рисунки.Зонтик.Картинка = КартинкаЗонтик;	
				КонецЕсли;					
			КонецЕсли;
			
			Если Выборка.Халяль = Истина Тогда
				ОбластьЭтик.Рисунки.КартинкаХаляль.Картинка = КартинкаХаляль;	
			КонецЕсли;			
			
			ОбластьЭтик.Параметры.УгловыеБуквы = Выборка.УгловыеБуквы;
			
			ТабДок.Вывести(ОбластьЭтик);
			
			Если НЕ СтрТовары.ДляКоробов Тогда
				Если ЗначениеЗаполнено(Выборка.ДопИнформация) Тогда
					ОбластьДопИнформация = Макет.ПолучитьОбласть("ДопИнформация|Верт");
					ОбластьДопИнформация.Параметры.ДопИнформация = Выборка.ДопИнформация;
					ТабДок.Вывести(ОбластьДопИнформация);
				КонецЕсли;
				
				ОбластьТУ = Макет.ПолучитьОбласть("ТУ|Верт");
				ОбластьТУ.Параметры.Заполнить(Выборка);
				ТабДок.Вывести(ОбластьТУ);
				
				ОбластьСостав = Макет.ПолучитьОбласть("Состав|Верт");
				Если ЗначениеЗаполнено(Выборка.Состав) Тогда
					ОбластьСостав.Параметры.Состав = Выборка.Состав;
					ТабДок.Вывести(ОбластьСостав);
				КонецЕсли;
				
				//Если НадписьПроАллергены Тогда
				//	ОбластьАлерг = Макет.ПолучитьОбласть("Аллерг|Верт");
				//	ТабДок.Вывести(ОбластьАлерг);
				//КонецЕсли;
				
				ОбластьСледы = Макет.ПолучитьОбласть("Следы|Верт");
				Если ЗначениеЗаполнено(Выборка.ПищеваяЦенность) Тогда
					ОбластьСледы.Параметры.Название = "Пищевая ценность, на 100 г";
					ОбластьСледы.Параметры.Следы = Выборка.ПищеваяЦенность;
					ТабДок.Вывести(ОбластьСледы);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(Выборка.ЭнергетическаяЦенность) Тогда
					ОбластьСледы.Параметры.Название = "Энергетическая ценность, на 100 г";
					ОбластьСледы.Параметры.Следы = Выборка.ЭнергетическаяЦенность;
					ТабДок.Вывести(ОбластьСледы);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(Выборка.Следы) Тогда
					ОбластьСледы.Параметры.Название = ""; 
					ОбластьСледы.Параметры.Следы = Выборка.Следы;
					ОбластьСледы.Область("R1C2").Текст = СтрЗаменить(ОбластьСледы.Область("R1C2").Текст, ": ", "");
					ТабДок.Вывести(ОбластьСледы);
				КонецЕсли;
			КонецЕсли;
			
			ОбластьНиз.Параметры.Заполнить(Выборка);
			
			Если НЕ СтрТовары.ДляКоробов Тогда   
				Если Выборка.БезГМО = Истина Тогда
					ОбластьНиз.Параметры.ГМО = "Произведено без использования ГМО";	
				КонецЕсли;
			Иначе
			КонецЕсли; 
			
			//добавляем данные из ТЧ
			ОбластьНиз.Параметры.Заполнить(СтрТовары);
			ОбластьНиз.Параметры.ДатаИзготовления = Формат(СтрТовары.ДатаИзготовления, "ДФ=dd.MM.yyyy") ;
			
			Если СтрТовары.КоличествоУпаковок>0 и СтрТовары.Упаковка.Наименование<>"Кг" Тогда
				ОбластьНиз.Параметры.Масса = ""+СтрТовары.Масса+" кг ("+СтрТовары.КоличествоУпаковок+" шт. по "+СтрТовары.Упаковка.Родитель.Вес+" кг)";
			Иначе	
				ОбластьНиз.Параметры.Масса = ""+СтрТовары.Масса+" кг";
			КонецЕсли; 
			
			Если СтрТовары.Штамп Тогда
				ОбластьНиз.Параметры.НомерПартии = "см. штамп на";
				ОбластьНиз.Параметры.НомерСменыЗамеса = "торцевой стороне мешка.";
			Иначе
				ОбластьНиз.Параметры.НомерПартии = СтрТовары.Серия.Номер;
			КонецЕсли; 
			
			Попытка
				Если ЗначениеЗаполнено(Выборка.Адрес) Тогда
					ОбластьНиз.Параметры.Адрес = "Адрес производства: "+Выборка.Адрес;
				Иначе	
					//ОбластьНиз.Параметры.Адрес = "Адрес производства: "+Справочники.АдресаДляЭтикеток.Основной;
				КонецЕсли; 
			Исключение
			КонецПопытки; 
			
			ТабДок.Вывести(ОбластьНиз);
			
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
	КонецЦикла; 
	
	ТабДок.ПолеСверху = 0;
	ТабДок.ПолеСнизу = 0;
	ТабДок.ПолеСправа = 5;
	ТабДок.ПолеСлева = 5;
	
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Возврат ТабДок;
	
КонецФункции

&НаКлиенте
Процедура Напечатать(Команда)
	
	ТабДок = НапечататьНаСервере();
	ТабДок.Показать();
	
КонецПроцедуры
