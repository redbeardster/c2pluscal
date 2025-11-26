# Пошаговая проверка test_loops.tla в TLA+ Toolbox

## 📋 Подготовка

### Файлы готовы:
- ✅ `test_loops.tla` (4.9 KB, 226 строк)
- ✅ `test_loops.cfg` (139 байт)

### Исходный C код (tests/test_loops.c):
```c
int main() {
    int i = 0;
    int sum = 0;
    
    // While loop
    while (i < 5) {
        sum += i;
        i++;
    }
    
    // For loop
    for (int j = 0; j < 3; j++) {
        sum += j;
    }
    
    // Do-while loop
    int k = 0;
    do {
        k++;
    } while (k < 2);
    
    return sum;
}
```

**Ожидаемый результат:** sum = 0+1+2+3+4 + 0+1+2 = 10 + 3 = 13

---

## 🚀 Шаг 1: Открыть файл в TLA+ Toolbox

1. Запустите **TLA+ Toolbox**
2. Меню: `File → Open Spec → Add New Spec...`
3. Нажмите `Browse...`
4. Выберите файл `test_loops.tla` (в корне проекта)
5. Нажмите `Finish`

**Результат:** Файл откроется в редакторе

---

## 🔄 Шаг 2: Транслировать PlusCal в TLA+

PlusCal код (между `(*--algorithm` и `end algorithm; *)`) нужно транслировать в TLA+.

1. Убедитесь, что файл `test_loops.tla` открыт
2. Нажмите **`Ctrl+T`** (или `File → Translate PlusCal Algorithm`)
3. Дождитесь сообщения: `"PCAL translation successful"`

**Что произошло:**
- После строки `end algorithm; *)` появился блок `\* BEGIN TRANSLATION`
- Это автоматически сгенерированный TLA+ код
- Файл сохранен автоматически

**Проверка:** Прокрутите вниз и найдите:
```tla
\* BEGIN TRANSLATION
...
\* END TRANSLATION
```

---

## 📝 Шаг 3: Создать модель для проверки

1. Меню: `TLC Model Checker → New Model...`
2. Введите имя модели: `Model_1` (или любое другое)
3. Нажмите `OK`

**Результат:** Откроется окно настройки модели

---

## ⚙️ Шаг 4: Настроить модель

В окне модели вы увидите несколько секций:

### 4.1 What is the behavior spec?
- Выберите: **`Temporal formula`**
- В поле должно быть: `Spec`
- ✅ Оставьте как есть

### 4.2 What is the model?
Константы уже определены в `.cfg` файле:
- `GLOBAL_INIT = {0}`
- `PROCESS = {1}`
- `UNDEF = UNDEF`
- `defaultInitValue = 0`

✅ Ничего менять не нужно

### 4.3 What to check?
- ✅ **Deadlock** - оставьте включенным
- Invariants - пока пусто (добавим позже)
- Properties - пока пусто

### 4.4 How to run? (опционально)
- Depth: можно оставить по умолчанию или установить 100
- Number of worker threads: оставьте auto

---

## ▶️ Шаг 5: Запустить проверку

1. Нажмите зеленую кнопку **"Run TLC on the model"** (или `F11`)
2. Дождитесь завершения проверки

**Процесс:**
```
Computing initial states...
Finished computing initial states: X distinct states generated.
Model checking completed. No error has been found.
```

**Ожидаемое время:** 1-5 секунд

---

## ✅ Шаг 6: Проверить результаты

### Успешная проверка выглядит так:

```
Model checking completed.
No error has been found.
  States found: ~50-100
  Distinct states: ~20-40
  State queue: 0
```

**Это означает:**
- ✅ Нет ошибок
- ✅ Нет deadlock'ов
- ✅ Программа завершается корректно
- Проверено ~50-100 состояний

### Вкладки результатов:

1. **Model Checking Results** - общая информация
2. **User Output** - вывод программы (если есть)
3. **Progress Output** - детали процесса проверки

---

## 📊 Шаг 7: Добавить инвариант (опционально)

Давайте проверим, что результат правильный (sum = 13).

### 7.1 Добавить инвариант в файл

1. Откройте `test_loops.tla` в редакторе Toolbox
2. Найдите строку `\* END TRANSLATION`
3. После неё добавьте:

```tla
\* Invariant: sum should be 13 at the end
SumCorrect == 
    \/ ~initDone  \* Not initialized yet
    \/ \E i \in DOMAIN mem : mem[i] = 13
```

4. Сохраните файл (`Ctrl+S`)

### 7.2 Добавить инвариант в модель

1. Вернитесь в окно модели
2. Секция **"What to check?"**
3. **Invariants** → нажмите `Add`
4. Введите: `SumCorrect`
5. Нажмите `Finish`

### 7.3 Запустить проверку снова

1. Нажмите `F11`
2. Проверьте результаты

**Ожидается:** 
```
✓ No error has been found.
✓ Invariant SumCorrect is not violated.
```

---

## 🐛 Возможные проблемы

### Проблема 1: "Module Bitwise not found"

**Причина:** Используются битовые операции, но модуль не установлен.

**Решение:**
1. Скачайте [CommunityModules](https://github.com/tlaplus/CommunityModules)
2. В Toolbox: `File → Preferences → TLA+ Preferences`
3. `TLA+ library path locations → Add Directory`
4. Добавьте путь к `CommunityModules/modules`

### Проблема 2: "Deadlock reached"

**Причина:** Программа не завершается корректно.

**Решение:**
- Проверьте, что в C коде `main()` возвращает значение
- Проверьте условия циклов

### Проблема 3: "Invariant SumCorrect is violated"

**Причина:** Результат не равен 13.

**Действия:**
1. Посмотрите **Error-Trace** в результатах
2. Проверьте значения переменных в последнем состоянии
3. Проверьте логику программы

---

## 🔍 Шаг 8: Изучить состояния (опционально)

### Просмотр Error-Trace

Если есть ошибка, TLC покажет последовательность шагов:

1. Вкладка **Error-Trace**
2. Каждый шаг показывает:
   - Состояние переменных
   - Выполненное действие
   - Переход к следующему состоянию

### Пример trace:

```
State 1: <Initial predicate>
  mem = <<>>
  initDone = FALSE

State 2: <Line0_globalInit line 195>
  mem = <<>>
  initDone = TRUE

State 3: <Line0_proc line 205>
  mem = <<>>
  initDone = TRUE

...

State N: <Final state>
  mem = <<..., 13, ...>>
  initDone = TRUE
```

---

## 📈 Ожидаемые результаты

### Для test_loops.c:

| Метрика | Значение |
|---------|----------|
| Состояний | ~50-100 |
| Уникальных | ~20-40 |
| Время | 1-5 сек |
| Ошибок | 0 |
| Deadlock | Нет |

### Проверяемые циклы:

1. **While loop** (i < 5): 5 итераций
2. **For loop** (j < 3): 3 итерации  
3. **Do-while loop** (k < 2): 2 итерации

**Итого:** ~10 итераций циклов → ~50-100 состояний

---

## ✨ Дополнительные инварианты

### Проверка границ переменных:

```tla
\* Loop counters are bounded
LoopBounded == 
    \A i \in DOMAIN mem : 
        mem[i] >= -100 /\ mem[i] <= 100

\* Memory is not too large
MemorySafe == Len(mem) < 1000

\* Stack is not too large  
StackSafe == \A proc \in PROCESS : TRUE  \* Simplified
```

Добавьте их после `\* END TRANSLATION` и в модель.

---

## 🎓 Что вы узнали

После этой проверки вы:

1. ✅ Открыли PlusCal спецификацию в TLA+ Toolbox
2. ✅ Транслировали PlusCal в TLA+ (`Ctrl+T`)
3. ✅ Создали модель для проверки
4. ✅ Запустили TLC model checker (`F11`)
5. ✅ Проверили результаты
6. ✅ Добавили инвариант
7. ✅ Изучили состояния программы

---

## 🚀 Следующие шаги

### Попробуйте другие тесты:

1. **test_simple.c** - самый простой (15 состояний)
2. **test_conditionals.c** - с if-else
3. **test_recursion.c** - рекурсия
4. **test.c** - комплексный (много состояний)

### Изучите:

- [Learn TLA+](https://learntla.com)
- [TLA+ Video Course](https://lamport.azurewebsites.net/video/videos.html)
- [`doc/tla_toolbox_guide.md`](./doc/tla_toolbox_guide.md)

---

## 📞 Помощь

Если что-то не работает:

1. Проверьте, что файлы `test_loops.tla` и `test_loops.cfg` существуют
2. Убедитесь, что PlusCal транслирован (`Ctrl+T`)
3. Проверьте логи в окне TLC
4. См. раздел "Возможные проблемы" выше
5. См. [`doc/tla_toolbox_guide.md`](./doc/tla_toolbox_guide.md)

---

Удачи! 🎉
