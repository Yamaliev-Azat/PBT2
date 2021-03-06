
&НаСервере
Процедура Р1_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НоменклатураДляОтбораПоПоставщикам") Тогда
		
		Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение = Параметры.НоменклатураДляОтбораПоПоставщикам;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Номенклатура");
		Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		Отбор.Использование = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
