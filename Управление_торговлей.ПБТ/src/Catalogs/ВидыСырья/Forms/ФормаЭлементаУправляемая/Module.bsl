
&НаСервереБезКонтекста
Функция АналогИспользуетсяВДругихВидахСырья(ВидСырья, Аналог)

	//Если в качестве Аналога выбрна номенклатуры, которая уже является Аналогом в другом виде сырья, то сообщать об этом и не добавлять ее в текущий.
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВидыСырьяАналогиСырья.Ссылка,
	               |	ВидыСырьяАналогиСырья.Аналог
	               |ИЗ
	               |	Справочник.ВидыСырья.АналогиСырья КАК ВидыСырьяАналогиСырья
	               |ГДЕ
	               |	ВидыСырьяАналогиСырья.Аналог = &Аналог
	               |	И ВидыСырьяАналогиСырья.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Аналог", Аналог);
	Запрос.УстановитьПараметр("Ссылка", ВидСырья);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	    ОбщегоНазначения.СообщитьПользователю("Аналог "+Выборка.Аналог+" уже используется в виде сырья "+ Выборка.Ссылка);
	КонецЦикла; 
	
КонецФункции

&НаКлиенте
Процедура АналогиСырьяАналогПриИзменении(Элемент)
	
	Аналог = Элементы.АналогиСырья.ТекущиеДанные.Аналог;
	АналогИспользуетсяВДругихВидахСырья(Объект.Ссылка, Аналог);
	
КонецПроцедуры
