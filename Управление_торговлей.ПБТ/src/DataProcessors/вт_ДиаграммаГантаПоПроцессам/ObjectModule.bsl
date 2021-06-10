Процедура СформироватьДиаграммуГанта(ДиаграммаГанта, ГруппировкаПоОснованию) Экспорт
	
	ДиаграммаГанта.Точки.Очистить();
	ДиаграммаГанта.Серии.Очистить();
	//
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	вт_ГрафикВыполненияПроизводства.ДокументОснование КАК ДокументОснование,
	|	вт_ГрафикВыполненияПроизводства.Заказ КАК Заказ,
	|	вт_ГрафикВыполненияПроизводства.ДатаНачала КАК ДатаНачала,
	|	вт_ГрафикВыполненияПроизводства.ДатаОкончания КАК ДатаОкончания,
	|	вт_ГрафикВыполненияПроизводства.Номенклатура КАК Номенклатура,
	|	вт_ГрафикВыполненияПроизводства.Операция КАК Операция,
	|	вт_ГрафикВыполненияПроизводства.Выполнено
	|ИЗ
	|	РегистрСведений.вт_ГрафикВыполненияПроизводства КАК вт_ГрафикВыполненияПроизводства
	|
	|ГДЕ 	вт_ГрафикВыполненияПроизводства.ДокументОснование = &ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаНачала,
	|	ДатаОкончания
	|ИТОГИ ПО
	|	" + ?(ГруппировкаПоОснованию,"Заказ ,","") + "
	|	Номенклатура,
	|	Операция");
	
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.ПланЗаказ);
	
	Если ГруппировкаПоОснованию Тогда 
		
		ВыборкаПоЗаказам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоЗаказам.Следующий() Цикл
			//Под заказ
			ТочкаПодразделения = ДиаграммаГанта.Точки.Добавить();//.УстановитьТочку(ВыборкаПоЗаказам.Заказ) ;//("Подразделение1");
			ТочкаПодразделения.Текст = ВыборкаПоЗаказам.Заказ;
			
			Выборкатовары =  ВыборкаПоЗаказам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока Выборкатовары.Следующий() Цикл
				//Под товар
				Точка = ТочкаПодразделения.Точки.Добавить();
				Точка.Текст = Выборкатовары.Номенклатура; // "Сотрудник1";//устанавливаем заголовок, а еще можно цвет фона, шрифт, цвет текста
				
				ВыборкаОперации = Выборкатовары.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаОперации.Следующий() Цикл
					Серия = ДиаграммаГанта.УстановитьСерию(ВыборкаОперации.Операция);
					//у каждой точки может быть несколько серий (графиков)
					//у серии можно задать цвет, но это происходит и автоматически
					Выборка =  ВыборкаОперации.Выбрать();
					Пока Выборка.Следующий() Цикл
						Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);
						
						//также несколько интервалов
						//По количеству операций
						Интервал = Значение.Добавить();
						Интервал.Начало = Выборка.ДатаНачала;
						Интервал.Конец = Выборка.ДатаОкончания;				
						
					КонецЦикла;	
				КонецЦикла;	
			КонецЦикла;	
		КонецЦикла;	
		
	Иначе
		
		Выборкатовары =  Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборкатовары.Следующий() Цикл
			//Под товар
			Точка = ДиаграммаГанта.УстановитьТочку(Выборкатовары.Номенклатура);
			Точка.Текст = Выборкатовары.Номенклатура; // "Сотрудник1";//устанавливаем заголовок, а еще можно цвет фона, шрифт, цвет текста
			
			ВыборкаОперации = Выборкатовары.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаОперации.Следующий() Цикл
				Серия = ДиаграммаГанта.УстановитьСерию(ВыборкаОперации.Операция);
				//у каждой точки может быть несколько серий (графиков)
				//у серии можно задать цвет, но это происходит и автоматически
				Выборка =  ВыборкаОперации.Выбрать();
				Пока Выборка.Следующий() Цикл
					Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);
					
					//также несколько интервалов
					//По количеству операций
					Интервал = Значение.Добавить();
					Интервал.Начало = Выборка.ДатаНачала;
					Интервал.Конец = Выборка.ДатаОкончания;				
					
				КонецЦикла;	
			КонецЦикла;	
		КонецЦикла;	
		
	КонецЕсли;
	
КонецПроцедуры
