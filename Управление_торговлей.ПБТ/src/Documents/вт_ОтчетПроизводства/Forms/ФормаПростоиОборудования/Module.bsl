
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РеквизитОборудование = Параметры.Оборудование;
	РеквизитКлючСвязиСтроки = Параметры.КлючСвязиСтроки;
	ТЗПростоиОборудования.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище));
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтменить(Команда)
	ЭтаФорма.Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура КомандаСохранить(Команда)
	АдресХранилища =  ПоместитьТаблицуВХранилище();
	СтруктураВозврата = Новый Структура("АдресХранилища,Оборудование,КлючСвязи",АдресХранилища,РеквизитОборудование,РеквизитКлючСвязиСтроки);
	ЭтаФорма.Закрыть(СтруктураВозврата);
	Оповестить("ОбновленыПериодыПростоев",СтруктураВозврата);
КонецПроцедуры

&НаСервере
Функция ПоместитьТаблицуВХранилище()
	Возврат ПоместитьВоВременноеХранилище(ТЗПростоиОборудования.Выгрузить());
КонецФункции

&НаКлиенте
Процедура ТЗПростоиОборудованияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		 Элемент.ТекущиеДанные.КлючСвязиОборудования=РеквизитКлючСвязиСтроки;
		 Элемент.ТекущиеДанные.Оборудование=РеквизитОборудование;
		 
	КонецЕсли;
КонецПроцедуры
