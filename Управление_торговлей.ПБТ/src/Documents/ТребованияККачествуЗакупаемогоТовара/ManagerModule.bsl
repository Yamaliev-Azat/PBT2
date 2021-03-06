Функция ПечатьПриложенияАнгл(Объект)  Экспорт//0018172
	
	ТабДок = Новый ТабличныйДокумент;
	
	Если Не ЗначениеЗаполнено(Объект.НаименованиеНаАнглийском) Тогда  //0020925
		Сообщить("Не заполнено название на английском!");
		Возврат ТабДок;
	КонецЕсли; 
	
	Макет = Документы.ТребованияККачествуЗакупаемогоТовара.ПолучитьМакет("ПриложениеАнгл");
	// Заголовок
	Область = Макет.ПолучитьОбласть("Заголовок");
	
	//Область.Параметры.Заполнить(Ссылка);
	Область.Параметры.Дата = Формат(ТекущаяДатаСеанса(), "ДФ=dd.MM.yyyy");
	Область.Параметры.Номер = Объект.Номер;
	Область.Параметры.Договор = Объект.Договор.Номер;
	Область.Параметры.ДатаДоговора = Формат(Объект.Договор.Дата, "ДФ=dd.MM.yyyy"); //0018773
	//0018474
	Если ТипЗнч(Объект.Поставщик) = Тип("СправочникСсылка.Контрагенты") Тогда
	   Область.Параметры.Поставщик = Объект.Поставщик.НаименованиеПолное;
	ИначеЕсли ТипЗнч(Объект.Поставщик) = Тип("СправочникСсылка.Производители") Тогда	
	   Область.Параметры.Поставщик = Объект.Поставщик.Наименование;
	   Область.Параметры.Договор = "________________";
	КонецЕсли;
	
	//Орг = Заявка.Организация; 
	Орг = Объект.Организация; //0019380
	Область.Параметры.Организация = Орг.НаименованиеПолное;
	//ОрганизацияАнгл = ПолучитьСвойствоПоОбъектуИВидуСвойств(Объект.Организация, ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("ОргНАнгл "));
	//Область.Параметры.ОрганизацияАнгл = ОрганизацияАнгл;
	
	//не сделал стандартный вывод, потому что нужно в род падеже
	Если Орг.Код = "000000011" Тогда   //ПА
	    Область.Параметры.ГенеральныйДиректорАнгл = "Ms. Levina L.R.";
		Область.Параметры.ГенеральныйДиректор = "г-жи Левиной Ларисы Румеровны";
		Область.Параметры.АдресАнгл = "142305, Russian Federation,  Moscow region, district Chehovskii, Sergeevo";
		Область.Параметры.АдресРус = "142305, Московская область, Чеховский  район, д. Сергеево";
		ОрганизацияАнгл = "Platinum Absolute LLC";
		Область.Параметры.ОрганизацияАнгл = ОрганизацияАнгл;
	ИначеЕсли Орг.Код = "000000001" Тогда   //ГК
	    Область.Параметры.ГенеральныйДиректор = "Mr. Tsyplakov U.N. ";
		Область.Параметры.ГенеральныйДиректор = "Цыплакова Ю.Н.";
		Область.Параметры.АдресАнгл = "141011, Kommunistichescaya Str. 21/A bld. 1 area 1, Mytischi, Moscow region, Russia";
		Область.Параметры.АдресРус = "141011, Россия, Московская область, город Мытищи, улица Коммунистическая, владение 21А, строение 1, помещение 1";
		ОрганизацияАнгл = "Group of Companies PTI LLC";
		Область.Параметры.ОрганизацияАнгл = ОрганизацияАнгл;
	КонецЕсли; 
	
	//гг д Область.Параметры.Номенклатура = Номенклатура.НаименованиеПолное;
	//Область.Параметры.Номенклатура = Номенклатура.Наименование; //гг д
	Область.Параметры.Номенклатура = Объект.НаименованиеНаАнглийском; //brava 0019867
	ТабДок.Вывести(Область);
	Если ЗначениеЗаполнено(Объект.Производитель) Тогда
		ОблПроизводитель = Макет.ПолучитьОбласть("Производитель");
		ОблПроизводитель.Параметры.Производитель = Объект.Производитель.Наименование;
		ТабДок.Вывести(ОблПроизводитель);
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДок.Вывести(Область);
	
	ОбластьПоказатели = Макет.ПолучитьОбласть("Показатель");
	ОбластьПоказателиРег = Макет.ПолучитьОбласть("Показатель");
	Результат = ВыполнитьЗапросПоТабличнойЧастиДокумента(Объект.Ссылка);
	ТекВидП = "";
	ВывелиЗвездочку = Ложь;
	Пока Результат.Следующий() Цикл
		Если Результат.НеВыводитьВСпецификации Тогда
			Продолжить;
		КонецЕсли; 
		//0023081	
		Если Результат.НеВыводитьВСпецификацииПоказатель Тогда
			Продолжить;
		КонецЕсли;
		
		//гг д 0022559 Если ЗначениеЗаполнено(Результат.ЗначениеПоказателя) Тогда
		Если ЗначениеЗаполнено(Результат.ЗначениеПоказателя) или ЗначениеЗаполнено(Результат.ЗначениеПоказателяНач) Тогда //гг д 0022559
			ОбластьПоказатели.Параметры.Заполнить(Результат);
			
			//гг д нач 0022559
			Если не ЗначениеЗаполнено(Результат.ЗначениеПоказателя) Тогда
				ОбластьПоказатели.Параметры.ЗначениеПоказателя = Переводы.ПеревестиЯндексом(Результат.ЗначениеПоказателяНач);
			КонецЕсли;
			//гг д кон 0022559
			
			//0018655
			Если НЕ ТекВидП = Результат.ВидИсследования Тогда
				//если выводим другой вид показателей, то проверяем не надо ли вывести регламент для него
				ТекВидП = Результат.ВидИсследования;
				СтрРег = Объект.ТехническиеРегламенты.Найти(ТекВидП);
				Если Не СтрРег = Неопределено Тогда
					ОбластьПоказателиРег.Параметры.ВидПоказателя = ТекВидП.НаименованиеНаАнглийском;
					//ОбластьПоказателиРег.Параметры.ЗначениеПоказателя = ""+СтрРег.Регламент.НаименованиеНаАнгл+?(ЗначениеЗаполнено(СтрРег.Комментарий), ", "+Переводы.ПеревестиЯндексом(СтрРег.Комментарий),""); //0019327
					ОбластьПоказателиРег.Параметры.ЗначениеПоказателя = ""+СтрРег.Регламент.НаименованиеНаАнгл+" "+СтрРег.Регламент.КомментарийНаАнгл+?(ЗначениеЗаполнено(СтрРег.Комментарий), ", "+Переводы.ПеревестиЯндексом(СтрРег.Комментарий),""); //0021109
					ТабДок.Вывести(ОбластьПоказателиРег);
				КонецЕсли; 
			КонецЕсли; 
			
			//при любом из этих условий должны печататься конечные
			Если Объект.Статус = Перечисления.СтатусЗаявки.Согласована Тогда
				//гг д 0018524 ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателяКонечные;
				ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателя; //гг д 
			КонецЕсли; 
			Если Объект.РаботаОККПоРазногласиямЗавершена и Объект.РаботаЦИРПоРазногласиямЗавершена Тогда
				//гг д 0018524 ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателяКонечные;
				ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателя;
			КонецЕсли;	
			
			//0022062
			Если Результат.ВариантСравнения = Перечисления.ВариантыСравнения.Между Тогда
			    ОбластьПоказатели.Параметры.ЗначениеПоказателя = ""+Результат.ЗначениеПоказателя;//+"-"+Результат.Интервал;
			Иначе	
			    ОбластьПоказатели.Параметры.ЗначениеПоказателя = ""+Переводы.ПеревестиЯндексом(Результат.ВариантСравнения)+" "+ОбластьПоказатели.Параметры.ЗначениеПоказателя;
			КонецЕсли;
			
			Если Результат.ОтличаетсяОтТР_ТС Тогда   //0022683
			    ОбластьПоказатели.Параметры.ВидПоказателя = ""+ОбластьПоказатели.Параметры.ВидПоказателя + " *";
				ВывелиЗвездочку = Истина;
			КонецЕсли; 
			
			ТабДок.Вывести(ОбластьПоказатели);
			
		КонецЕсли;
	КонецЦикла;
	
	Если ВывелиЗвездочку Тогда
	    ПодвалПоказателей = Макет.ПолучитьОбласть("ПодвалПоказателей");
		ТабДок.Вывести(ПодвалПоказателей);
	КонецЕсли; 
	
	//аллергены
	Область = Макет.ПолучитьОбласть("Шапка2");
	ОбластьАллерген = Макет.ПолучитьОбласть("Аллерген");	
	Если ТипЗнч(Объект.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		//Если Номенклатура.НоменклатурнаяГруппаЛаб = Справочники.НоменклатурныеГруппыЛаб.Упаковка Тогда   //0018968
		//	Область = Макет.ПолучитьОбласть("ШапкаУпаковка");
		//	ОбластьАллерген = Макет.ПолучитьОбласть("АллергенУпаковка");
		//КонецЕсли; 
	КонецЕсли;
	
	ТабДок.Вывести(Область);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	АллергенСпр.Ссылка КАК Аллерген,
	               |	ЕСТЬNULL(Док.НаличиеВПродукте, ЛОЖЬ) КАК НаличиеВПродукте,
				   |	ЕСТЬNULL(Док.НаличиеСледовВПродукте, ЛОЖЬ) КАК НаличиеСледовВПродукте
	               |ИЗ
	               |	Справочник.Аллерген КАК АллергенСпр
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТребованияККачествуЗакупаемогоТовара.Аллергены КАК Док
	               |		ПО (Док.Аллерген = АллергенСпр.Ссылка)
	               |			И (Док.Ссылка = &Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	ТЗ = Результат.Выгрузить();
	Для каждого СтрТЗ Из ТЗ Цикл

		ОбластьАллерген.Параметры.Аллерген = СтрТЗ.Аллерген.НаименованиеАнгл;
		Если ТипЗнч(Объект.Номенклатура) = Тип("СправочникСсылка.Номенклатура")   Тогда //0018968 и НЕ Номенклатура.НоменклатурнаяГруппаЛаб = Справочники.НоменклатурныеГруппыЛаб.Упаковка
			Если СтрТЗ.НаличиеВПродукте Тогда
				ОбластьАллерген.Параметры.НаличиеВПродукте = "Yes";
			Иначе
				ОбластьАллерген.Параметры.НаличиеВПродукте = "";
			КонецЕсли; 
		КонецЕсли; 
		
		Если СтрТЗ.НаличиеСледовВПродукте Тогда
		    ОбластьАллерген.Параметры.НаличиеСледовВПродукте = "Yes";
		Иначе
			ОбластьАллерген.Параметры.НаличиеСледовВПродукте = "";
		КонецЕсли; 
		
		ТабДок.Вывести(ОбластьАллерген);
	КонецЦикла;  	
	
	//Подвал
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Если Орг.Код = "000000011" Тогда   //ПА
	    ОбластьПодвал.Параметры.ГенеральныйДиректорАнгл = "Ms. Levina L.R.";
		//ОбластьПодвал.Параметры.ГенеральныйДиректор = "Левиной Л.Р.";
	ИначеЕсли Орг.Код = "000000001" Тогда   //ГК
	    ОбластьПодвал.Параметры.ГенеральныйДиректорАнгл = "Mr. Tsyplakov U.N. ";
		//ОбластьПодвал.Параметры.ГенеральныйДиректор = "Цыплакова Ю.Н.";
	КонецЕсли; 
	
	//0020833
	Если ТипЗнч(Объект.Поставщик) = Тип("СправочникСсылка.Контрагенты") Тогда
	   ОбластьПодвал.Параметры.Поставщик = Объект.Поставщик.НаименованиеПолное;
	ИначеЕсли ТипЗнч(Объект.Поставщик) = Тип("СправочникСсылка.Производители") Тогда	
	   ОбластьПодвал.Параметры.Поставщик = Объект.Поставщик.Наименование;
	КонецЕсли;
	
	
	ОбластьПодвал.Параметры.ОрганизацияАнгл = ОрганизацияАнгл;
	ТабДок.Вывести(ОбластьПодвал);
	
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	ТабДок.АвтоМасштаб = Истина;
	
Возврат ТабДок;
	
КонецФункции

Функция ПечатьПриложения(Объект)  Экспорт//0018172
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.ТребованияККачествуЗакупаемогоТовара.ПолучитьМакет("Приложение");
	// Заголовок
	Область = Макет.ПолучитьОбласть("Заголовок");
	
	//Область.Параметры.Заполнить(Ссылка);
	Область.Параметры.Дата = Формат(ТекущаяДатаСеанса(), "ДФ=dd.MM.yyyy");
	Область.Параметры.Номер = Объект.Номер;
	Область.Параметры.Договор = Объект.Договор.Номер;
	Область.Параметры.ДатаДоговора = Формат(Объект.Договор.Дата, "ДФ=dd.MM.yyyy"); //0018773
	
	//0018474
	Если ТипЗнч(Объект.Поставщик) = Тип("СправочникСсылка.Контрагенты") Тогда
	   Область.Параметры.Поставщик = Объект.Поставщик.НаименованиеПолное;
	ИначеЕсли ТипЗнч(Объект.Поставщик) = Тип("СправочникСсылка.Производители") Тогда	
	   Область.Параметры.Поставщик = Объект.Поставщик.Наименование;
	   Область.Параметры.Договор = "________________";
	КонецЕсли;
	
	//Орг = Заявка.Организация; 
	Орг = Объект.Организация; //0019380
	Область.Параметры.Организация = Орг.НаименованиеПолное;
	
	//не сделал стандартный вывод, потому что нужно в род падеже
	Если Орг.Код = "000000011" Тогда   //ПА
	    Область.Параметры.ГенеральныйДиректор = "Левиной Л.Р.";
	ИначеЕсли Орг.Код = "000000001" Тогда   //ГК
	    Область.Параметры.ГенеральныйДиректор = "Цыплакова Ю.Н.";	
	КонецЕсли; 
	
	//гг д Область.Параметры.Номенклатура = Номенклатура.НаименованиеПолное;
	Номенклатура = Объект.Номенклатура;
	Область.Параметры.Номенклатура = Номенклатура.Наименование; //гг д
	
	ТабДок.Вывести(Область);
	Если ЗначениеЗаполнено(Объект.Производитель) Тогда
		ОблПроизводитель = Макет.ПолучитьОбласть("Производитель");
		ОблПроизводитель.Параметры.Производитель = Объект.Производитель.Наименование;
		ТабДок.Вывести(ОблПроизводитель);
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДок.Вывести(Область);
	
	ОбластьПоказатели = Макет.ПолучитьОбласть("Показатель");
	ОбластьПоказателиРег = Макет.ПолучитьОбласть("Показатель");
	Результат = ВыполнитьЗапросПоТабличнойЧастиДокумента(Объект.Ссылка);
	ТекВидП = "";
	ВывелиЗвездочку = Ложь;
	Пока Результат.Следующий() Цикл
		Если Результат.НеВыводитьВСпецификации Тогда
			Продолжить;
		КонецЕсли; 
			//0023081	
		Если Результат.НеВыводитьВСпецификацииПоказатель Тогда
			Продолжить;
		КонецЕсли;
	
			ОбластьПоказатели.Параметры.Заполнить(Результат);
			
			//гг д нач 0022559
			Если СокрЛП(Результат.ЗначениеПоказателяКонечные) <> "" Тогда
				ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателяКонечные;
			КонецЕсли;
			//гг д кон 0022559
			
			//0018655
			Если НЕ ТекВидП = Результат.ВидИсследования Тогда
				//если выводим другой вид показателей, то проверяем не надо ли вывести регламент для него
				ТекВидП = Результат.ВидИсследования;
				//СтрРег = Объект.ТехническиеРегламенты.Найти(ТекВидП);
				//Если Не СтрРег = Неопределено Тогда
				//	ОбластьПоказателиРег.Параметры.ВидПоказателя = ТекВидП;
				//	//ОбластьПоказателиРег.Параметры.ЗначениеПоказателя = ""+СтрРег.Регламент+" "+СтрРег.Комментарий;
				//	ОбластьПоказателиРег.Параметры.ЗначениеПоказателя = ""+СтрРег.Регламент+" "+СтрРег.Регламент.Комментарий+" "+СтрРег.Комментарий; //0021109
				//	ТабДок.Вывести(ОбластьПоказателиРег);
				//КонецЕсли; 
			КонецЕсли; 
			//при любом из этих условий должны печататься конечные
			Если Объект.Статус = Перечисления.СтатусЗаявки.Согласована Тогда
				ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателяКонечные;
			КонецЕсли; 
			Если Объект.РаботаОККПоРазногласиямЗавершена и Объект.РаботаЦИРПоРазногласиямЗавершена Тогда
				ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателяКонечные;
			КонецЕсли;		   
			
			//0022062
			Если Результат.ВариантСравнения = Перечисления.ВариантыСравнения.Между Тогда
			    ОбластьПоказатели.Параметры.ЗначениеПоказателя = ""+Результат.ЗначениеПоказателяКонечные;//+"-"+Результат.Интервал;
			Иначе	
			    ОбластьПоказатели.Параметры.ЗначениеПоказателя = ""+Результат.ВариантСравнения+" "+ОбластьПоказатели.Параметры.ЗначениеПоказателя;
			КонецЕсли;
			
			Если Результат.ОтличаетсяОтТР_ТС Тогда   //0022683
			    ОбластьПоказатели.Параметры.ВидПоказателя = ""+ОбластьПоказатели.Параметры.ВидПоказателя + " *";
				ВывелиЗвездочку = Истина;
			КонецЕсли; 
			ТабДок.Вывести(ОбластьПоказатели);
	КонецЦикла;
	
	Если ВывелиЗвездочку Тогда
	    ПодвалПоказателей = Макет.ПолучитьОбласть("ПодвалПоказателей");
		ТабДок.Вывести(ПодвалПоказателей);
	КонецЕсли; 
	
	//аллергены
	Область = Макет.ПолучитьОбласть("Шапка2");
	ОбластьАллерген = Макет.ПолучитьОбласть("Аллерген");	
	Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		//Если Номенклатура.НоменклатурнаяГруппаЛаб = Справочники.НоменклатурныеГруппыЛаб.Упаковка Тогда   //0018968
		//	Область = Макет.ПолучитьОбласть("ШапкаУпаковка");
		//	ОбластьАллерген = Макет.ПолучитьОбласть("АллергенУпаковка");
		//КонецЕсли;
	КонецЕсли;
	
	ТабДок.Вывести(Область);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	АллергенСпр.Ссылка КАК Аллерген,
	               |	ЕСТЬNULL(Док.НаличиеВПродукте, ЛОЖЬ) КАК НаличиеВПродукте,
	               |	ЕСТЬNULL(Док.НаличиеСледовВПродукте, ЛОЖЬ) КАК НаличиеСледовВПродукте
	               |ИЗ
	               |	Справочник.Аллерген КАК АллергенСпр
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТребованияККачествуЗакупаемогоТовара.Аллергены КАК Док
	               |		ПО (Док.Аллерген = АллергенСпр.Ссылка)
	               |			И (Док.Ссылка = &Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	ТЗ = Результат.Выгрузить();
	Для каждого СтрТЗ Из ТЗ Цикл
		
		ОбластьАллерген.Параметры.Аллерген = СтрТЗ.Аллерген;
		//Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") И НЕ Номенклатура.НоменклатурнаяГруппаЛаб = Справочники.НоменклатурныеГруппыЛаб.Упаковка  Тогда //0018968
		//	Если СтрТЗ.НаличиеВПродукте Тогда
		//		ОбластьАллерген.Параметры.НаличиеВПродукте = "ДА";
		//	Иначе
		//		ОбластьАллерген.Параметры.НаличиеВПродукте = "";
		//	КонецЕсли; 
		//КонецЕсли; 

		Если СтрТЗ.НаличиеСледовВПродукте Тогда
		    ОбластьАллерген.Параметры.НаличиеСледовВПродукте = "ДА";
		Иначе
			ОбластьАллерген.Параметры.НаличиеСледовВПродукте = "";
		КонецЕсли; 
		
		ТабДок.Вывести(ОбластьАллерген);
	КонецЦикла;  	
	
	//Подвал
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	//Руководители = РегламентированнаяОтчетность.ОтветственныеЛицаОрганизации(Орг, ТекущаяДата());
	//Руководитель = Руководители.Руководитель;
	//ОбластьПодвал.Параметры.ГенеральныйДиректор = Руководитель;
	//ОбластьПодвал.Параметры.Организация = Орг.НаименованиеПолное;

	//0020833
	Если ТипЗнч(Объект.Поставщик) = Тип("СправочникСсылка.Контрагенты") Тогда
	   ОбластьПодвал.Параметры.Поставщик = Объект.Поставщик.НаименованиеПолное;
	ИначеЕсли ТипЗнч(Объект.Поставщик) = Тип("СправочникСсылка.Производители") Тогда	
	   ОбластьПодвал.Параметры.Поставщик = Объект.Поставщик.Наименование;
	КонецЕсли;
	
	ТабДок.Вывести(ОбластьПодвал);
	
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	ТабДок.АвтоМасштаб = Истина;
	
Возврат ТабДок;
	
КонецФункции

Функция ПечатьАнглийский(Объект, пСтрокаТЧЗаявки = Неопределено, ТолькоРазногласия = ЛОжь) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.ТребованияККачествуЗакупаемогоТовара.ПолучитьМакет("ПечатьАнглийский");
	// Заголовок
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.Спецификация = "Specification";
	
	ТабДок.Вывести(Область);
	// Шапка
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		ШапкаДата = Макет.ПолучитьОбласть("ШапкаДата");
		ШапкаДата.Параметры.Заполнить(Объект);
		ТабДок.Вывести(ШапкаДата);
	КонецЕсли;
	//Если ЗначениеЗаполнено(Номенклатура.ВидСырья) Тогда
	//	ШапкаПризнак = Макет.ПолучитьОбласть("ШапкаПризнак");
	//	ШапкаПризнак.Параметры.ВидСырья = Номенклатура.ВидСырья;
	//	ТабДок.Вывести(ШапкаПризнак);
	//КонецЕсли;
	
	//0013602
	ШапкаНоменклатура = Макет.ПолучитьОбласть("ШапкаНоменклатура");
	//0018113
	Если Не ЗначениеЗаполнено(Объект.НаименованиеНаАнглийском) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнено название номенклатуры на английском языке! Заполните пожалуйста.");
		Возврат ТабДок;
	КонецЕсли; 
	ШапкаНоменклатура.Параметры.Номенклатура = Объект.НаименованиеНаАнглийском;
	ТабДок.Вывести(ШапкаНоменклатура);
	
	// 0018114
	//НазвНаАнгл = ПолучитьСвойствоПоОбъектуИВидуСвойств(Заявка.Организация, ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("ОргНАнгл "));
	
	ШапкаПроизводитель = Макет.ПолучитьОбласть("ШапкаПроизводитель");
	ШапкаПоставщик = Макет.ПолучитьОбласть("ШапкаПоставщик");
	
	// 0018056
	Если ЗначениеЗаполнено(Объект.Производитель) Тогда	
		ШапкаПроизводитель.Параметры.Производитель = Объект.Производитель;
		ТабДок.Вывести(ШапкаПроизводитель);
	КонецЕсли;
	
	//0013548   0018056
	Если ЗначениеЗаполнено(Объект.Поставщик) Тогда
		ШапкаПоставщик.Параметры.Поставщик = Объект.Поставщик;
		ТабДок.Вывести(ШапкаПоставщик);
	КонецЕсли;
	
	// Показатели
	Если ТолькоРазногласия Тогда
		ОбластьПоказатели = Макет.ПолучитьОбласть("ПоказателиРазногласия");
		Область = Макет.ПолучитьОбласть("ПоказателиШапкаРазногласия");
	Иначе	
		ОбластьПоказатели = Макет.ПолучитьОбласть("Показатели");
		Область = Макет.ПолучитьОбласть("ПоказателиШапка");
	КонецЕсли; 
    ТабДок.Вывести(Область);
	
	//Если Ссылка.Статус = Перечисления.СтатусЗаявки.Закрыта Тогда
	//	Результат = ВыполнитьЗапросПоРегистру(Истина);
	//Иначе
		Результат = ВыполнитьЗапросПоТабличнойЧастиДокумента(Объект.Ссылка);
	//КонецЕсли;
	Пока Результат.Следующий() Цикл
		//0015419	
		Если Результат.НеВыводитьВСпецификации Тогда
			Продолжить;
		КонецЕсли; 
		//0023081	
		Если Результат.НеВыводитьВСпецификацииПоказатель Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьПоказатели.Параметры.Заполнить(Результат);
		
			Если ТолькоРазногласия Тогда //0024791
				Если Результат.ОтНасАнглийский<>Результат.ЗначениеПоказателя Тогда
					ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ОтНасАнглийский;
					ОбластьПоказатели.Параметры.ЗначениеПоказателяОтПоставщикаНачальные = Результат.ЗначениеПоказателя;
					
					ТабДок.Вывести(ОбластьПоказатели);
				КонецЕсли; 
			Иначе	
				ТабДок.Вывести(ОбластьПоказатели);
			КонецЕсли;
			
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("Аллергены");
	ТабДок.Вывести(Область);
	
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
Возврат ТабДок;
	
КонецФункции

Функция ВыполнитьЗапросПоТабличнойЧастиДокумента(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.Показатель КАК Показатель,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ВидИсследования КАК ВидИсследования,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ОтНасАнглийский КАК ОтНасАнглийский,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ЗначениеПоказателяАнглийский КАК ЗначениеПоказателяАнглийский,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ЗначениеПоказателяОтНасНачальные КАК ЗначениеПоказателяОтНасНачальные,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ЗначениеПоказателяКонечные КАК ЗначениеПоказателяКонечные,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ЗначениеПоказателяОтПоставщикаНачальные КАК ЗначениеПоказателяОтПоставщикаНачальные,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.НеВыводитьВСпецификации КАК НеВыводитьВСпецификации,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.Показатель.НеВыводитьВСпецификации КАК НеВыводитьВСпецификацииПоказатель,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ВариантСравнения КАК ВариантСравнения,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.Интервал КАК Интервал,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ОтличаетсяОтТР_ТС КАК ОтличаетсяОтТР_ТС,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.НомерСтроки КАК НомерСтроки
	               |ИЗ
	               |	Документ.ТребованияККачествуЗакупаемогоТовара.ТЧ_Показатели КАК ТребованияККачествуЗакупаемогоТовараПоказатели
	               |ГДЕ
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.Ссылка = &Ссылка
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.ВидИсследования.ПорядокВывода,
	               |	ТребованияККачествуЗакупаемогоТовараПоказатели.НомерСтроки";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить().Выбрать();
	Возврат Результат;
	
КонецФункции

Функция ПечатьРусский(Объект, ТолькоРазногласия = ЛОжь) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.ТребованияККачествуЗакупаемогоТовара.ПолучитьМакет("Печать");
	// Заголовок
	Область = Макет.ПолучитьОбласть("Заголовок");
		Область.Параметры.Спецификация = "Спецификация";
	
	ТабДок.Вывести(Область);
	// Шапка
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		ШапкаДата = Макет.ПолучитьОбласть("ШапкаДата");
		ШапкаДата.Параметры.Заполнить(Объект);
		ТабДок.Вывести(ШапкаДата);
	КонецЕсли;
	
	ШапкаПроизводитель = Макет.ПолучитьОбласть("ШапкаПроизводитель");
	ШапкаНоменклатура = Макет.ПолучитьОбласть("ШапкаНоменклатура");
	ШапкаПоставщик = Макет.ПолучитьОбласть("ШапкаПоставщик");
	
	ШапкаНоменклатура.Параметры.Номенклатура = Объект.Номенклатура;
	ТабДок.Вывести(ШапкаНоменклатура);
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ШапкаОрг = Макет.ПолучитьОбласть("ШапкаОрганизация");
		ШапкаОрг.Параметры.Организация = Объект.Организация.Наименование;
		ТабДок.Вывести(ШапкаОрг);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Производитель) Тогда	
		ШапкаПроизводитель.Параметры.Производитель = Объект.Производитель;
		ТабДок.Вывести(ШапкаПроизводитель);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Поставщик) Тогда
		ШапкаПоставщик.Параметры.Поставщик = Объект.Поставщик;
		ТабДок.Вывести(ШапкаПоставщик);
	КонецЕсли;

	// Показатели
	Если ТолькоРазногласия Тогда
		ОбластьПоказатели = Макет.ПолучитьОбласть("ПоказателиРазногласия");
		Область = Макет.ПолучитьОбласть("ПоказателиШапкаРазногласия");
	Иначе	
		ОбластьПоказатели = Макет.ПолучитьОбласть("Показатели");
		Область = Макет.ПолучитьОбласть("ПоказателиШапка");
	КонецЕсли; 
	ТабДок.Вывести(Область);
	
		Результат = ВыполнитьЗапросПоТабличнойЧастиДокумента(Объект.Ссылка);
		
		Пока Результат.Следующий() Цикл
		//0015419	
		Если Результат.НеВыводитьВСпецификации Тогда
			Продолжить;
		КонецЕсли; 
		//0023081	
		Если Результат.НеВыводитьВСпецификацииПоказатель Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьПоказатели.Параметры.Заполнить(Результат);
		
		//при любом из этих условий должны печататься конечные
		Если Объект.Статус = Перечисления.СтатусЗаявки.Согласована Тогда
			ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателяКонечные;
		КонецЕсли; 
		Если Объект.РаботаОККПоРазногласиямЗавершена и Объект.РаботаЦИРПоРазногласиямЗавершена Тогда
			ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателяКонечные;
		КонецЕсли;		   
		
		Если ТолькоРазногласия Тогда //0017145
			Если Результат.ЗначениеПоказателя<>Результат.ЗначениеПоказателяОтПоставщикаНачальные и (НЕ ЗначениеЗаполнено(Результат.ЗначениеПоказателяКонечные)) Тогда
				ОбластьПоказатели.Параметры.ЗначениеПоказателя = Результат.ЗначениеПоказателя;
				ОбластьПоказатели.Параметры.ЗначениеПоказателяОтПоставщикаНачальные = Результат.ЗначениеПоказателяОтПоставщикаНачальные;
				
				//0022854
				Если Результат.ВариантСравнения = Перечисления.ВариантыСравнения.Между Тогда
					ОбластьПоказатели.Параметры.ЗначениеПоказателя = ""+Результат.ЗначениеПоказателя;//+"-"+Результат.Интервал;
				Иначе	
					ОбластьПоказатели.Параметры.ЗначениеПоказателя = ""+Результат.ВариантСравнения+" "+ОбластьПоказатели.Параметры.ЗначениеПоказателя;
				КонецЕсли;
				
				ТабДок.Вывести(ОбластьПоказатели);
			КонецЕсли; 
		Иначе	
			ТабДок.Вывести(ОбластьПоказатели);
		КонецЕсли; 
	КонецЦикла;
	
	Если НЕ ТолькоРазногласия Тогда //0017145 Тогда
		Область = Макет.ПолучитьОбласть("Аллергены");
		ТабДок.Вывести(Область);		
	КонецЕсли; 
	
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	ТабДок.АвтоМасштаб = Истина;
	
	Возврат ТабДок;
	
КонецФункции