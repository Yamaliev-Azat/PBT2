
&НаКлиенте
Процедура МатериалыПланПриАктивизацииСтроки(Элемент)
	
	Данные = Элементы.МатериалыПлан.ТекущиеДанные;
	Если Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;  
	//устанавливаем идентификатор если он пустой
	Если НЕ ЗначениеЗаполнено(Данные.ИдентификаторСтрокиПлан) Тогда 
		Данные.ИдентификаторСтрокиПлан = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	//устанавливаем отбор в подчиненных табличных частях
	Элементы.Материалы.ОтборСтрок = Новый ФиксированнаяСтруктура("ИдентификаторСтрокиТЧПлан", Данные.ИдентификаторСтрокиПлан);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПланПередУдалением(Элемент, Отказ)
	
	Данные = Элементы.МатериалыПлан.ТекущиеДанные;
	Отбор = Новый Структура("ИдентификаторСтрокиТЧПлан",Данные.ИдентификаторСтрокиПлан);
	Масс = Объект.Материалы.НайтиСтроки(Отбор);
	Для каждого Строка из Масс Цикл
		Объект.Материалы.Удалить(Строка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПриАктивизацииСтроки(Элемент)
	
	ДанныеПлан = Элементы.МатериалыПлан.ТекущиеДанные;
	Если ДанныеПлан = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ДанныеФакт = Элементы.Материалы.ТекущиеДанные;
	Если ДанныеФакт = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//устанавливаем идентификатор ВИ если он пустой
	Если НЕ ЗначениеЗаполнено(ДанныеФакт.ИдентификаторСтрокиТЧПлан) Тогда 
		ДанныеФакт.ИдентификаторСтрокиТЧПлан = ДанныеПлан.ИдентификаторСтрокиПлан;
		ДанныеФакт.Упаковка = ДанныеПлан.Упаковка;
		ДанныеФакт.Номенклатура = ДанныеПлан.Номенклатура;
		ДанныеФакт.СтатусУказанияСерий = 14;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//ОткрытьПодборСерий("Материалы", Элемент.ТекстРедактирования);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Надо заполнять серии после в форме Редактирования Факта");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерий(ИмяТЧ, Текст = "", ТекущиеДанные = Неопределено)
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий[ИмяТЧ],Текст, ТекущиеДанные) Тогда
		Если ТекущиеДанные = Неопределено Тогда
			ТекущиеДанныеИдентификатор = Элементы[ИмяТЧ].ТекущиеДанные.ПолучитьИдентификатор();
		Иначе
			ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		КонецЕсли;
		
		ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор, ИмяТЧ);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение",
														ЭтотОбъект,
														Новый Структура("ИмяТЧ,ПараметрыФормыУказанияСерий", ИмяТЧ,ПараметрыФормыУказанияСерий));

		ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,
					ПараметрыФормыУказанияСерий,
					ЭтаФорма,
					,
					,
					,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор, ИмяТЧ)
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.МаршрутныйЛист);
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий[ИмяТЧ], ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.МаршрутныйЛист));
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	//ДанныеПлан = Элементы.МатериалыПлан.ТекущиеДанные;
	//Если ДанныеПлан = Неопределено Тогда
	//	Возврат;
	//КонецЕсли; 
	
	ДанныеФакт = Элементы.Материалы.ТекущиеДанные;
	Если ДанныеФакт = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МатериалыПланРасчет(ДанныеФакт.ИдентификаторСтрокиТЧПлан);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПланКоличествоПриИзменении(Элемент)
	
	ДанныеПлан = Элементы.МатериалыПлан.ТекущиеДанные;
	МатериалыПланРасчет(ДанныеПлан.ИдентификаторСтрокиПлан); 
	
КонецПроцедуры

&НаСервере
Процедура МатериалыПланРасчет(ИдентификаторСтрокиПлан)
	
	Отбор = Новый Структура("ИдентификаторСтрокиТЧПлан", ИдентификаторСтрокиПлан);
	Масс = Объект.Материалы.НайтиСтроки(Отбор);
	Кол = 0;
	Для каждого Строка из Масс Цикл
		Кол = Кол + Строка.Количество;
	КонецЦикла;
	
	//ДанныеПлан = Объект.МатериалыПлан.Найти(ИдентификаторСтрокиПлан, "ИдентификаторСтрокиПлан");
	ОтборПлан = Новый Структура("ИдентификаторСтрокиПлан", ИдентификаторСтрокиПлан);
	МассПлан = Объект.МатериалыПлан.НайтиСтроки(ОтборПлан);
	
	Если МассПлан.Количество()>0 Тогда
		
		ДанныеПлан = МассПлан[0];
		ДанныеПлан.КоличествоФакт = Кол;
		ДанныеПлан.Разница = ДанныеПлан.КоличествоФакт - ДанныеПлан.Количество;
		Если ДанныеПлан.Количество>5 Тогда
			ДанныеПлан.Допуск = ДанныеПлан.Количество*0.003;
		Иначе	
			ДанныеПлан.Допуск = 0.75;
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура РедактироватьФакт(Команда=Неопределено)
	
	ТекущиеДанныеИдентификатор = Элементы.Материалы.ТекущиеДанные.ПолучитьИдентификатор();
	
	ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор, "Материалы");
	
	ПараметрыОткрытияФормы = Новый Структура("Уникальность, Окно, НавигационнаяСсылка, Владелец", Ложь);
	//Если ПараметрыОткрытия <> Неопределено Тогда
	//	ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормы, ПараметрыОткрытия);
	//КонецЕсли;
	
	ОповещениеОЗакрытие = Новый ОписаниеОповещения("ПослеЗакрытияФормыРедатированияФакта", ЭтотОбъект);
	
	ТекСтрока = Элементы.Материалы.ТекущиеДанные;
	
	ТекущаяСтрокаИдентификатор = ТекСтрока.ПолучитьИдентификатор();
	
	ПараметрыФормы = Новый Структура("Номенклатура, ТекущийВес, Серия, Выбрали, ТекущаяСтрокаИдентификатор, МЛ, ПараметрыУказанияСерий, Склад", ТекСтрока.Номенклатура, ТекСтрока.Количество, ТекСтрока.Серия, Истина, ТекущаяСтрокаИдентификатор, Объект.Ссылка, ПараметрыУказанияСерий, Объект.Склад);
	
	ОткрытьФорму("Документ.МаршрутныйЛист.Форма.ФормаРедатированияФакта", ПараметрыФормы,
	ПараметрыОткрытияФормы.Владелец, ПараметрыОткрытияФормы.Уникальность,
	ПараметрыОткрытияФормы.Окно, ПараметрыОткрытияФормы.НавигационнаяСсылка, ОповещениеОЗакрытие);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	//ПослеЗакрытияФормыРедатированияФакта(Источник, Параметр);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыРедатированияФакта(СтрукПараметров, ДополнительныеПараметры) Экспорт
	
	Если НЕ СтрукПараметров = неопределено Тогда
		Если СтрукПараметров.Свойство("ТекущаяСтрокаИдентификатор") Тогда
			ТекущаяСтрока = Объект.Материалы.НайтиПоИдентификатору(СтрукПараметров.ТекущаяСтрокаИдентификатор);	
			ТекущаяСтрока.Номенклатура = СтрукПараметров.Номенклатура;
			ТекущаяСтрока.Количество = СтрукПараметров.ТекущийВес;
			ТекущаяСтрока.Серия = СтрукПараметров.Серия;
		КонецЕсли; 
	КонецЕсли;
	
	МатериалыПланРасчет(ТекущаяСтрока.ИдентификаторСтрокиТЧПлан);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПланПоФакту(Команда)
	
	ЗаполнитьПланПоФактуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПланПоФактуНаСервере()
	
	Объект.Материалы.Очистить();
	
	Для каждого СтрПлан Из Объект.МатериалыПлан Цикл
		
		СтрФакт = Объект.Материалы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрФакт, СтрПлан, , "НомерСтроки");
		СтрФакт.ИдентификаторСтрокиТЧПлан = СтрПлан.ИдентификаторСтрокиПлан;
		
		МатериалыПланРасчет(СтрПлан.ИдентификаторСтрокиПлан);
		
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыСерияПриИзменении(Элемент)
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.ОтгружаемыеТовары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.ОтгружаемыеТовары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий.ОтгружаемыеТовары, ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ПартияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//СерияНачалоВыбораНаСервере(Элемент);
	НачалоВыбораСерии();
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСерии()

	ПараметрыФормы = Новый Структура("Номенклатура, Серия, Склад", Объект.Номенклатура);
	ОповещениеОЗакрытие = Новый ОписаниеОповещения("ПослеЗакрытияФормыВыбораСерии", ЭтотОбъект);
	ПараметрыОткрытияФормы = Новый Структура("Уникальность, Окно, НавигационнаяСсылка, Владелец", Ложь);
	
	ОткрытьФорму("Документ.МаршрутныйЛист.Форма.ФормаВыбораСерии", ПараметрыФормы,
	ПараметрыОткрытияФормы.Владелец, ПараметрыОткрытияФормы.Уникальность,
	ПараметрыОткрытияФормы.Окно, ПараметрыОткрытияФормы.НавигационнаяСсылка, ОповещениеОЗакрытие);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыВыбораСерии(СтрукПараметров, ДополнительныеПараметры) Экспорт
	
	Если НЕ СтрукПараметров = неопределено Тогда
		Если СтрукПараметров.Свойство("Серия") Тогда
			Объект.Серия = СтрукПараметров.Серия;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	РедактироватьФакт();
КонецПроцедуры

&НаКлиенте
Процедура ПечатьМЛ(Команда)
	ТабДок = ПечатьМЛНаСервере();
	ТабДок.Показать();
КонецПроцедуры

&НаСервере
Функция ПечатьМЛНаСервере()
	Возврат Документы.МаршрутныйЛист.ПечатьМаршрутного(Объект);
КонецФункции

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере()
	
	Объект.Рецепт = вт_ОбщийМодульПроизводства.ПолучитьВариантПроизводстваПродукции(Объект.Номенклатура, Объект.ХарактеристикаНоменклатуры).Ссылка;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	НоменклатураПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМатериалыПоРецептуНаСервере()
	
	Объект.МатериалыПлан.Очистить();
	Объект.Материалы.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	|	вт_ВариантыПроизводстваПоТехКартамСостав.Сырье КАК Номенклатура,
	|	вт_ВариантыПроизводстваПоТехКартамСостав.Количество КАК Количество,
	|	вт_ВариантыПроизводстваПоТехКартамСостав.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Справочник.вт_ВариантыПроизводстваПоТехКартам.Состав КАК вт_ВариантыПроизводстваПоТехКартамСостав
	|ГДЕ
	|	вт_ВариантыПроизводстваПоТехКартамСостав.Ссылка = &Рецепт
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("Рецепт", Объект.Рецепт);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	КолСырьяПоМат = 0;
	
	Пока Выборка.Следующий() Цикл
		НовСтр = Объект.МатериалыПлан.Добавить();
		НовСтр.Номенклатура = Выборка.Номенклатура;
		НовСтр.Количество100 = Выборка.Количество;
		
		НовСтр.Количество = Объект.Количество*Выборка.Количество/100;
		
		Если НЕ НовСтр.Номенклатура.ВидНоменклатуры.Наименование = "Тара" Тогда
			КолСырьяПоМат = КолСырьяПоМат + НовСтр.Количество;
		КонецЕсли;
		
		НовСтр.ИдентификаторСтрокиПлан = Новый УникальныйИдентификатор();
		
	КонецЦикла; 
	
	Объект.КоличествоСырья = КолСырьяПоМат;
	
	ЗаполнитьПланПоФактуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалыПоРецепту(Команда)
	ЗаполнитьМатериалыПоРецептуНаСервере();
КонецПроцедуры


 

