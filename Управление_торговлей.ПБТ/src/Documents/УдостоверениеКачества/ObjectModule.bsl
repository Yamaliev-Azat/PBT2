Процедура ОбработкаПроведения(Отказ, Режим)
	
	// регистр ОтборОбразцов Расход
	//Движение = Движения.ОтборОбразцов.Добавить();
	//Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	//Движение.Период = Дата;
	//
	//Движение.Номенклатура = Номенклатура;
	//Движение.ДокументПоступления = ДокументПоступления;
	//Движение.КодПродукта = КодПродукта;
	//Движение.ВидДокумента = Перечисления.лаб_ВидыДокументов.УдостоверениеКачества;
	//Движение.Организация = Организация;
	//Движение.Количество = 1;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат;
	КонецЕсли; 	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПротоколАнализа") Тогда
		Организация = ДанныеЗаполнения.Организация;
		Образец = ДанныеЗаполнения.Образец;
		ДатаИзготовления = Образец.ДатаИзготовления; 
		ДокументПоступления = Образец.ДокументПоступления; 
		КодПродукта = Образец.КодПродукта; 
		Номенклатура = ДанныеЗаполнения.Номенклатура; 
		Серия = ДанныеЗаполнения.Серия; 
		Производитель = ДанныеЗаполнения.Производитель; 
		НомерЗамеса = Образец.НомерЗамеса;
		Пользователь = Пользователи.ТекущийПользователь();//глЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;
	
	//Заполнение табличных частей
	лТЗПротоколов = Лаборатория_Сервер.гл_ПолучитьТаблицуПротоколов(Номенклатура, Серия);
	ТЧ_ПротоколыАнализа.Загрузить(лТЗПротоколов);
	//лТЗШаблон = Лаборатория_Сервер.гл_ПолучитШаблонныеДанные(Номенклатура, ТекущаяДатаСеанса());
	//ТаблицаВидовИсследования(ТЗПротоколов, лТЗШаблон);
	//лТЗПротоколов = ПротоколыСрезПоследних(ТЗПротоколов);
	//ТЧ_ПротоколыАнализа.Очистить();
	Документы.УдостоверениеКачества.ЗаполнениеТаблиц(ЭтотОбъект);
	
	Если Номенклатура.Ссылка <> справочники.Номенклатура.ПустаяСсылка() тогда
		НоменклатураНаПечать = Номенклатура.НаименованиеПолное ;//+ Символы.ПС + "ТУ " + Номенклатура.ТУ;
	КонецЕсли;	
	
КонецПроцедуры


Функция ОтборПоПараметру(парам_ТЗ, парам_Ключ, парам_Значение) Экспорт
	Отбор = Новый Структура();
	Отбор.Вставить(парам_Ключ, парам_Значение);
	Результат = парам_ТЗ.НайтиСтроки(Отбор);
	Возврат  Результат;
КонецФункции // ОтборПоПараметру()

Процедура ТаблицаВидовИсследования(ТЗПротоколов, ТЗШаблоны) Экспорт
	
	//Убираем протоколы по которым есть шаблоны на регистре
	ТЗВидыИсследований = Новый ТаблицаЗначений;
	ТЗВидыИсследований.Колонки.Добавить("ВидИсследования");
	Для Н=1 По ТЗШаблоны.Количество() Цикл
		ТЗВидыИсследований.Добавить();
	КонецЦикла;
	СтрокиТЗ = ОтборПоПараметру(ТЗПротоколов, "ВидИсследования", Справочники.ВидыИсследований.ФункциональныеСвойства);
	Если СтрокиТЗ.Количество()>0  Тогда 
		Для каждого Строка Из СтрокиТЗ Цикл
			ТЗПротоколов.Удалить(Строка);
		КонецЦикла; 
	КонецЕсли;
	СтрокиТЗ = "";
	Если ТЗШаблоны.Количество()>0 Тогда
		ТЗВидыИсследований.ЗагрузитьКолонку(ТЗШаблоны.ВыгрузитьКолонку("ВидИсследования"), "ВидИсследования");
		ТЗВидыИсследований.Свернуть("ВидИсследования");
		Для каждого Элемент Из  ТЗВидыИсследований Цикл
			//Отбор = Новый Структура();
			//Отбор.Вставить("ВидИсследования", Элемент.ВидИсследования);
			//СтрокиТЗ = ТЗПротоколов.НайтиСтроки(Отбор);
			СтрокиТЗ = ОтборПоПараметру(ТЗПротоколов, "ВидИсследования", Элемент.ВидИсследования);
			Если СтрокиТЗ.Количество()>0 Тогда
				#Если Клиент Тогда
					Ответ = Вопрос("Для вида исследований "+Элемент.ВидИсследования.Наименование+" найдены шаблонные данные, удалить соответствующие Протоколы анализа?", РежимДиалогаВопрос.ДаНет);
					Если Ответ = КодВозвратаДиалога.Да Тогда
						Для каждого Строка Из СтрокиТЗ Цикл
							ТЗПротоколов.Удалить(Строка);
						КонецЦикла; 
					Иначе
						СтрокиВИ = ОтборПоПараметру(ТЗШаблоны, "ВидИсследования", Элемент.ВидИсследования);
						Для каждого лСтрВИ Из СтрокиВИ Цикл
							ТЗШаблоны.Удалить(лСтрВИ);			
						КонецЦикла; 			
					КонецЕсли;
				#КонецЕсли
			КонецЕсли;
			
			Если ТЗПротоколов.Количество()=0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли;
	
	Возврат ;	
	
КонецПроцедуры


