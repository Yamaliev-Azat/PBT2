
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Если ЭтотОбъект.Начисления.Количество() > 0 Тогда
		НаборЗаписей = РегистрыНакопления.вт_НачислениеЗарплаты.СоздатьНаборЗаписей(); 
		НаборЗаписей.Отбор.Регистратор.Установить(ЭтотОбъект.Ссылка);
		Для каждого СТР из ЭтотОбъект.Начисления цикл
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.ВидДвижения = ВидДвиженияНакопления.Приход;
			НоваяЗапись.Период = ЭтотОбъект.Дата;
			НоваяЗапись.ПериодНачисления = ЭтотОбъект.МесяцНачисления;
			НоваяЗапись.Регистратор = ЭтотОбъект.Ссылка; 
			НоваяЗапись.Организация = ЭтотОбъект.Организация;
			НоваяЗапись.ФизическоеЛицо  = СТР.ФизическоеЛицо;
			НоваяЗапись.СуммаВзаиморасчетов  = СТР.СуммаНачисления;
		КонецЦикла;
		НаборЗаписей.Записать();
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	Если ЭтотОбъект.Начисления.Количество() > 0 Тогда
		НаборЗаписей = РегистрыНакопления.вт_НачислениеЗарплаты.СоздатьНаборЗаписей(); 
		НаборЗаписей.Отбор.Регистратор.Установить(ЭтотОбъект.Ссылка);
		НаборЗаписей.Записать();
	КонецЕсли;
КонецПроцедуры
