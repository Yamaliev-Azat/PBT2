
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Номенклатура, Упаковка", ПараметрКоманды, ""));
	ПараметрыФормы = Новый Структура("НоменклатураДляОтбораПоПоставщикам", ПараметрКоманды);
	ОткрытьФорму("Справочник.НоменклатураКонтрагентов.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
