&НаСервере
Процедура ПрименитьОтборПоСтатусу()
Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус"); 
Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
Отбор.Использование = Истина; 
Отбор.ПравоеЗначение = Перечисления.вт_СтатусыПроизводства.ВПроизводстве;
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Счетчик = 1;
	СписокОтбораСтатусВПроизводстве.Добавить(Счетчик,"Незавершенные");
	Для Каждого Метпер Из Метаданные.Перечисления.вт_СтатусыПроизводства.ЗначенияПеречисления Цикл 
		Счетчик = Счетчик + 1;
		СписокОтбораСтатусВПроизводстве.Добавить(Счетчик,Метпер.Синоним);		
		//ОтборСтатусВПроизводстве.СписокВыбора.Добавить(Метпер);
	КонецЦикла;	
	//ОтборСтатусВПроизводстве.СписокВыбора.Добавить("Незавершенные");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого мСтатус Из СписокОтбораСтатусВПроизводстве Цикл
		Элементы.ОтборСтатусВПроизводстве.СписокВыбора.Добавить(мСтатус.Значение,мСтатус.Представление);			
	КонецЦикла;	
	
	//Элементы.ОтборСтатусВПроизводстве.СписокВыбора.Добавить(1,ПредопределенноеЗначение("Перечисление.вт_СтатусыПроизводства.ВПроизводстве"));
	//Элементы.ОтборСтатусВПроизводстве.СписокВыбора.Добавить(2,ПредопределенноеЗначение("Перечисление.вт_СтатусыПроизводства.Ожидание"));
	//Элементы.ОтборСтатусВПроизводстве.СписокВыбора.Добавить(3,ПредопределенноеЗначение("Перечисление.вт_СтатусыПроизводства.Завершено"));
	//Элементы.ОтборСтатусВПроизводстве.СписокВыбора.Добавить(4,ПредопределенноеЗначение("Перечисление.вт_СтатусыПроизводства.Отменено"));
	//Элементы.ОтборСтатусВПроизводстве.СписокВыбора.Добавить(5,"Незавершенные");
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусВПроизводствеПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ОтборСтатусВПроизводстве) тогда
		Если ОтборСтатусВПроизводстве = 1 ИЛИ ОтборСтатусВПроизводстве = НЕОпределено Тогда
			ОтобратьНезавершенные();
		Иначе 
			ОтобратьПоСтатусу(ОтборСтатусВПроизводстве); 
		КонецЕсли;
	Иначе
	 	ОчиститьОтбор();	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтобратьНезавершенные()
	Список.Отбор.Элементы.Очистить();
	Отбор1 = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
	Отбор1.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус"); 
	Отбор1.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно; 
	Отбор1.Использование = Истина; 
	Отбор1.ПравоеЗначение = Перечисления.вт_СтатусыПроизводства.Завершено;	
	
КонецПроцедуры	

&НаСервере
Процедура ОтобратьПоСтатусу(ЗначениеВЫбора)
	Список.Отбор.Элементы.Очистить();
	Отбор1 = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
	Отбор1.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус"); 
	Отбор1.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	Отбор1.Использование = Истина; 
	Счетчик = 2;
	Для Каждого Метпер Из Метаданные.Перечисления.вт_СтатусыПроизводства.ЗначенияПеречисления Цикл 
		Если ЗначениеВыбора = Счетчик Тогда
			Выполнить("Отбор1.ПравоеЗначение = Перечисления.вт_СтатусыПроизводства."+Метпер.Имя+";");
			Прервать;
		КонецЕсли;	
		Счетчик = Счетчик + 1;		
	 КонецЦикла;	
	//Отбор1.ПравоеЗначение = ПравоеЗначениеОтбора.СтандартныеРеквизиты;	
КонецПроцедуры	

&НаСервере
Процедура ОчиститьОтбор()
	Список.Отбор.Элементы.Очистить();	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "СписокСсылкаНомер" тогда
		ПоказатьЗначение(,Элемент.ТекущиеДанные.Ссылка);
	ИначеЕсли Поле.Имя = "СписокНоменклатура" тогда
		ПоказатьЗначение(,Элемент.ТекущиеДанные.Номенклатура);
	ИначеЕсли Поле.Имя = "СписокПартнер" тогда
		ПоказатьЗначение(,Элемент.ТекущиеДанные.Партнер);
	ИначеЕсли Поле.Имя = "СписокСтатус" ИЛИ Поле.Имя = "СписокЗаказВПроизводствоТребуемаяДата" ИЛИ Поле.Имя = "СписокВыполненоПроцент" тогда
		ПоказатьЗначение(,Элемент.ТекущиеДанные.ЗаказВПроизводство);
	КонецЕсли;
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтменитьОтбор(Команда)
	ОчиститьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьОтборКСписку(Элемент)
	ОтборСтатусВПроизводствеПриИзменении(Элемент);
	ПрименитьОтборНаСервере();
КонецПроцедуры
	
&НаСервере
Процедура ПрименитьОтборНаСервере()	
	Если ЗначениеЗаполнено(ОтборНоменклатура) Тогда
		Отбор1 = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		Отбор1.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Номенклатура"); 
		Отбор1.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
		Отбор1.ПравоеЗначение = ОтборНоменклатура;
		Отбор1.Использование = Истина; 
	КонецЕсли;		
	Если ЗначениеЗаполнено(ОтборКлиент) Тогда
		Отбор1 = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		Отбор1.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер"); 
		Отбор1.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
		Отбор1.ПравоеЗначение = ОтборКлиент;
		Отбор1.Использование = Истина;
	КонецЕсли;	
КонецПроцедуры	


