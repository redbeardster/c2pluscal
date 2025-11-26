# Руководство по проверке результатов в TLA+ Toolbox

Это руководство объясняет, как проверить корректность сгенерированных PlusCal спецификаций с помощью TLA+ Toolbox.

---

## 📥 Установка TLA+ Toolbox

### Скачивание

1. Перейдите на [официальный сайт TLA+](https://lamport.azurewebsites.net/tla/toolbox.html)
2. Скачайте версию для вашей ОС (Linux/Windows/macOS)
3. Распакуйте архив

### Linux
```bash
# Скачать
wget https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/TLAToolbox-1.8.0-linux.gtk.x86_64.zip

# Распаковать
unzip TLAToolbox-1.8.0-linux.gtk.x86_64.zip

# Запустить
cd toolbox
./toolbox
```

---

## 🚀 Быстрый старт

### Шаг 1: Генерация PlusCal спецификации

```bash
# Транспилировать C в PlusCal
frama-c -pluscal tests/test_simple.c

# Результат:
# - test_simple.tla (PlusCal спецификация)
# - test_simple.cfg (конфигурация для TLC)
```

### Шаг 2: Открыть в TLA+ Toolbox

1. Запустите TLA+ Toolbox
2. `File → Open Spec → Add New Spec...`
3. Выберите файл `test_simple.tla`
4. Нажмите `Finish`

### Шаг 3: Транслировать PlusCal в TLA+

PlusCal - это алгоритмический язык, который нужно транслировать в TLA+:

1. Откройте файл `test_simple.tla` в редакторе
2. Нажмите `Ctrl+T` (или `File → Translate PlusCal Algorithm`)
3. В файле появится сгенерированный TLA+ код после строки `\* BEGIN TRANSLATION`

**Важно:** После каждого изменения PlusCal кода нужно заново транслировать!

### Шаг 4: Создать модель

1. `TLC Model Checker → New Model...`
2. Введите имя модели (например, `Model_1`)
3. Нажмите `OK`

### Шаг 5: Настроить модель

В открывшемся окне модели:

#### What is the behavior spec?
- Выберите `Temporal formula`: `Spec`

#### What is the model?
Константы уже определены в `.cfg` файле:
- `GLOBAL_INIT = {0}`
- `PROCESS = {1}`
- `UNDEF = UNDEF`

#### What to check?
- **Deadlock**: оставьте включенным (проверка на deadlock)
- **Invariants**: можно добавить инварианты (см. ниже)
- **Properties**: можно добавить temporal properties

### Шаг 6: Запустить проверку

1. Нажмите зеленую кнопку `Run TLC on the model` (или F11)
2. Дождитесь завершения проверки
3. Результаты появятся в окне `Model Checking Results`

---

## ✅ Интерпретация результатов

### Успешная проверка

```
TLC finished checking the model.
No errors found.
States found: 42
Distinct states: 15
```

**Это означает:**
- ✅ Нет ошибок
- ✅ Нет deadlock'ов
- ✅ Все инварианты выполнены
- Проверено 42 состояния (15 уникальных)

### Ошибка: Deadlock

```
Error: Deadlock reached.
```

**Причины:**
- Программа завершилась некорректно
- Процесс застрял в ожидании
- Проблема в трансляции

**Решение:**
- Проверьте исходный C код
- Добавьте отладочную информацию: `frama-c -pluscal -debug-dump test.c`

### Ошибка: Invariant violated

```
Error: Invariant Inv is violated.
```

**Это означает:**
- Инвариант не выполняется в некотором состоянии
- TLC покажет trace (последовательность шагов) до нарушения

**Действия:**
1. Изучите trace
2. Проверьте корректность инварианта
3. Проверьте корректность программы

---

## 📝 Добавление инвариантов

Инварианты - это условия, которые должны быть истинны во всех состояниях.

### Пример 1: Простой инвариант

В файле `.tla` после `\* END TRANSLATION` добавьте:

```tla
\* Invariant: memory is never empty after initialization
MemoryNotEmpty == initDone => Len(mem) > 0
```

В модели добавьте инвариант:
- `Invariants → Add → MemoryNotEmpty`

### Пример 2: Инвариант с ожидаемым значением

```tla
\* Check that result is correct
ResultCorrect == 
    \/ ~initDone  \* Not initialized yet
    \/ mem[Len(mem) - 1] = 15  \* Expected result
```

### Пример 3: Безопасность памяти

```tla
\* No stack overflow
StackSafe == Len(my_stack) < 1000

\* No memory overflow  
MemorySafe == Len(mem) < 1000
```

---

## 🔍 Отладка с помощью TLC

### Просмотр состояний

1. После проверки откройте `Model Checking Results`
2. Вкладка `Error-Trace` показывает последовательность шагов
3. Каждый шаг показывает значения переменных

### Пример trace

```
State 1: Initial state
  mem = <<>>
  initDone = FALSE

State 2: After initialization
  mem = <<0, 0, 0>>
  initDone = TRUE

State 3: After computation
  mem = <<0, 0, 15>>
  initDone = TRUE
```

### Использование CHOOSE для отладки

Добавьте в инвариант:

```tla
DebugPrint == 
    /\ PrintT(<<"mem", mem>>)
    /\ PrintT(<<"initDone", initDone>>)
    /\ TRUE
```

---

## 🎯 Практические примеры

### Пример 1: Проверка test_simple.c

```bash
# Генерация
frama-c -pluscal tests/test_simple.c

# В TLA+ Toolbox:
# 1. Open test_simple.tla
# 2. Ctrl+T (translate)
# 3. Create model
# 4. Run TLC
```

**Ожидаемый результат:**
- Состояний: ~10-20
- Ошибок: 0
- Время: < 1 секунды

### Пример 2: Проверка с инвариантом

Добавьте в `test_simple.tla`:

```tla
\* After END TRANSLATION

\* Result should be 15 (5 + 10)
ResultIs15 == 
    \/ ~initDone
    \/ \E i \in DOMAIN mem : mem[i] = 15
```

В модели добавьте инвариант `ResultIs15`.

### Пример 3: Проверка test_loops.c

```bash
frama-c -pluscal tests/test_loops.c
```

**Особенности:**
- Больше состояний (из-за циклов)
- Время проверки: несколько секунд
- Можно ограничить глубину поиска в настройках модели

---

## ⚙️ Настройки TLC

### Ограничение глубины поиска

В модели:
- `TLC Options → Depth of search`: установите, например, 100

### Увеличение памяти

В модели:
- `TLC Options → JVM arguments`: `-Xmx4G` (4GB памяти)

### Параллельная проверка

В модели:
- `TLC Options → Number of worker threads`: установите количество ядер

---

## 🐛 Частые проблемы

### Проблема 1: "Module Bitwise not found"

**Причина:** Используются битовые операции, но модуль не установлен.

**Решение:**
1. Скачайте [CommunityModules](https://github.com/tlaplus/CommunityModules)
2. Добавьте путь в TLA+ Toolbox:
   - `File → Preferences → TLA+ Preferences → TLA+ library path locations`
   - Добавьте путь к `CommunityModules/modules`

### Проблема 2: "TLC ran out of memory"

**Решение:**
- Увеличьте память JVM: `-Xmx8G`
- Уменьшите глубину поиска
- Упростите программу

### Проблема 3: "Deadlock reached"

**Причины:**
- Программа не завершается корректно
- Процесс ждет события, которое не произойдет

**Решение:**
- Проверьте, что `main` возвращает значение
- Проверьте условия циклов

---

## 📚 Дополнительные ресурсы

### Документация
- [TLA+ Home Page](https://lamport.azurewebsites.net/tla/tla.html)
- [Learn TLA+](https://learntla.com)
- [TLA+ Video Course](https://lamport.azurewebsites.net/video/videos.html)

### Примеры
- [TLA+ Examples](https://github.com/tlaplus/Examples)
- [PlusCal Tutorial](https://lamport.azurewebsites.net/tla/pluscal.html)

### Сообщество
- [TLA+ Google Group](https://groups.google.com/g/tlaplus)
- [TLA+ Subreddit](https://www.reddit.com/r/tlaplus/)

---

## 🔄 Workflow

```
1. Написать C код
   ↓
2. Транспилировать: frama-c -pluscal file.c
   ↓
3. Открыть .tla в TLA+ Toolbox
   ↓
4. Транслировать PlusCal: Ctrl+T
   ↓
5. Создать модель
   ↓
6. Добавить инварианты (опционально)
   ↓
7. Запустить TLC: F11
   ↓
8. Проанализировать результаты
   ↓
9. Если ошибки → исправить → повторить
```

---

## ✨ Советы

1. **Начните с простых программ** - test_simple.c идеален для начала
2. **Добавляйте инварианты постепенно** - начните с простых
3. **Используйте отладочный дамп** - `frama-c -pluscal -debug-dump`
4. **Изучайте trace при ошибках** - он показывает путь к проблеме
5. **Ограничивайте глубину** - для больших программ
6. **Сохраняйте модели** - можно создать несколько с разными настройками

---

## 🎓 Обучение

### Шаг 1: Простая программа
```bash
frama-c -pluscal tests/test_simple.c
# Проверьте в TLA+ Toolbox
```

### Шаг 2: Добавьте инвариант
```tla
SimpleInvariant == Len(mem) < 100
```

### Шаг 3: Более сложная программа
```bash
frama-c -pluscal tests/test_loops.c
# Изучите, как циклы влияют на количество состояний
```

### Шаг 4: Проверка корректности
```bash
frama-c -pluscal tests/test_conditionals.c
# Добавьте инварианты для проверки результата
```

---

Удачи в формальной верификации! 🚀
