# TLA+ Toolbox - Шпаргалка

## ⌨️ Горячие клавиши

| Действие | Клавиши | Описание |
|----------|---------|----------|
| Транслировать PlusCal | `Ctrl+T` | Преобразовать PlusCal → TLA+ |
| Запустить TLC | `F11` | Начать model checking |
| Остановить TLC | `Shift+F11` | Прервать проверку |
| Сохранить | `Ctrl+S` | Сохранить файл |
| Найти | `Ctrl+F` | Поиск в файле |

---

## 🔄 Workflow

```
1. Открыть .tla файл
   File → Open Spec → Add New Spec
   
2. Транслировать PlusCal
   Ctrl+T
   
3. Создать модель
   TLC Model Checker → New Model
   
4. Запустить проверку
   F11
   
5. Проверить результаты
   Model Checking Results
```

---

## 📝 Структура .tla файла

```tla
---- MODULE test_loops ----
EXTENDS Integers, Sequences

(*--algorithm test_loops
variables
    x = 0;
    
begin
    x := x + 1;
end algorithm; *)

\* BEGIN TRANSLATION
... (автоматически сгенерировано)
\* END TRANSLATION

\* Ваши инварианты здесь
MyInvariant == x >= 0

====
```

---

## ✅ Типичные инварианты

### Проверка значения
```tla
ResultCorrect == 
    \/ ~initialized
    \/ result = 42
```

### Границы переменной
```tla
Bounded == x >= 0 /\ x <= 100
```

### Безопасность памяти
```tla
MemorySafe == Len(memory) < 1000
```

### Существование значения
```tla
HasValue == \E i \in DOMAIN mem : mem[i] = expected
```

---

## 🎯 Настройки модели

### Behavior Spec
- **Temporal formula:** `Spec` (обычно)
- **Initial predicate:** `Init` (редко)

### Constants
Определены в `.cfg` файле:
```
GLOBAL_INIT = {0}
PROCESS = {1}
UNDEF = UNDEF
```

### What to check
- ✅ **Deadlock** - всегда включено
- **Invariants** - добавьте свои
- **Properties** - temporal properties

### TLC Options
- **Depth:** 100 (по умолчанию)
- **Workers:** auto (количество ядер)
- **JVM args:** `-Xmx4G` (память)

---

## 🐛 Частые ошибки

### "Module X not found"
```
Решение: File → Preferences → TLA+ library path
Добавить путь к модулям
```

### "Deadlock reached"
```
Причина: Программа не завершается
Решение: Проверить return в main()
```

### "Invariant violated"
```
Причина: Условие не выполняется
Решение: Изучить Error-Trace
```

### "Out of memory"
```
Решение: Увеличить -Xmx в TLC Options
Или уменьшить depth
```

---

## 📊 Интерпретация результатов

### ✓ Успех
```
Model checking completed.
No error has been found.
States: 42
Distinct: 15
```

### ✗ Deadlock
```
Error: Deadlock reached.
State: ...
```
→ Программа застряла

### ✗ Invariant
```
Error: Invariant X is violated.
State: ...
```
→ Условие нарушено

### ⚠️ Timeout
```
TLC still running...
```
→ Слишком много состояний

---

## 🔍 Отладка

### Просмотр состояний
1. Error-Trace → показывает путь к ошибке
2. Каждый шаг = состояние переменных
3. Действие = что выполнилось

### Добавить вывод
```tla
DebugInvariant == 
    /\ PrintT(<<"x", x>>)
    /\ TRUE
```

### Ограничить поиск
```tla
StateConstraint == x < 10
```

---

## 📚 Полезные операторы TLA+

### Логические
```tla
/\  - AND
\/  - OR
~   - NOT
=>  - IMPLIES
<=> - EQUIVALENT
```

### Множества
```tla
\in     - принадлежит
\E x \in S : P  - существует
\A x \in S : P  - для всех
```

### Последовательности
```tla
Len(seq)      - длина
seq[i]        - элемент
<<a, b, c>>   - литерал
Head(seq)     - первый
Tail(seq)     - без первого
```

---

## 🚀 Быстрый старт

### 1 минута
```bash
# Генерация
frama-c -pluscal test.c

# В Toolbox:
# 1. Open test.tla
# 2. Ctrl+T
# 3. New Model → F11
```

### 5 минут
```bash
# + Добавить инвариант
# + Изучить результаты
# + Попробовать другие тесты
```

### 30 минут
```bash
# + Изучить Error-Trace
# + Написать свои инварианты
# + Проверить сложные программы
```

---

## 📖 Ресурсы

### Документация проекта
- `QUICKSTART_TLA.md` - быстрый старт
- `doc/tla_toolbox_guide.md` - полное руководство
- `MANUAL_VERIFICATION_STEPS.md` - пошаговая инструкция

### Внешние ресурсы
- [TLA+ Home](https://lamport.azurewebsites.net/tla/tla.html)
- [Learn TLA+](https://learntla.com)
- [Video Course](https://lamport.azurewebsites.net/video/videos.html)

---

## 💡 Советы

1. **Начните с простого** - test_simple.c
2. **Транслируйте после изменений** - Ctrl+T
3. **Сохраняйте модели** - можно создать несколько
4. **Изучайте trace** - он показывает путь к ошибке
5. **Ограничивайте depth** - для больших программ
6. **Используйте инварианты** - они помогают найти ошибки

---

Распечатайте эту шпаргалку и держите под рукой! 📄
