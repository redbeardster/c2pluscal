# Быстрый старт: Проверка с TLA+ Toolbox

Краткое руководство по проверке сгенерированных PlusCal спецификаций.

---

## 🎯 Цель

Проверить корректность транспиляции C → PlusCal → TLA+ с помощью TLC model checker.

---

## 📥 Установка TLA+ Toolbox

### Вариант 1: GUI (рекомендуется для начинающих)

```bash
# Linux
wget https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/TLAToolbox-1.8.0-linux.gtk.x86_64.zip
unzip TLAToolbox-1.8.0-linux.gtk.x86_64.zip
cd toolbox && ./toolbox
```

### Вариант 2: CLI (для автоматизации)

```bash
# Скачать tla2tools.jar
wget https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/tla2tools.jar
mv tla2tools.jar ~/tla2tools.jar

# Или установить через package manager
# Ubuntu/Debian:
sudo apt-get install tla-plus-toolbox
```

---

## 🚀 Быстрая проверка (3 шага)

### Шаг 1: Генерация

```bash
frama-c -pluscal tests/test_simple.c
# Создаст: test_simple.tla, test_simple.cfg
```

### Шаг 2: Открыть в TLA+ Toolbox

1. Запустить Toolbox
2. `File → Open Spec → Add New Spec`
3. Выбрать `test_simple.tla`

### Шаг 3: Проверка

1. Нажать `Ctrl+T` (транслировать PlusCal)
2. `TLC Model Checker → New Model`
3. Нажать `F11` (запустить проверку)

**Результат:**
```
✓ No errors found
States: ~15
Time: < 1s
```

---

## 💻 Проверка из командной строки

### Автоматическая проверка всех тестов

```bash
cd tests
python3 verify_all_with_tlc.py
```

### Проверка одного файла

```bash
cd tests
./verify_with_tlc.sh test_simple.tla
```

---

## 📝 Добавление инвариантов

### Пример: Проверка результата

Откройте `test_simple.tla` и после `\* END TRANSLATION` добавьте:

```tla
\* Result should be 15 (a=5, b=10, c=a+b)
ResultCorrect == 
    \/ ~initDone  \* Not initialized
    \/ \E i \in DOMAIN mem : mem[i] = 15
```

В модели TLA+ Toolbox:
- `Invariants → Add → ResultCorrect`
- Запустить проверку (`F11`)

---

## ✅ Интерпретация результатов

### ✓ Успех

```
Model checking completed.
No errors found.
States: 42
```

**Означает:** Программа корректна, нет deadlock'ов, инварианты выполнены.

### ✗ Deadlock

```
Error: Deadlock reached.
```

**Причины:**
- Программа не завершается
- Процесс застрял

**Решение:** Проверьте, что `main()` возвращает значение.

### ✗ Invariant violated

```
Error: Invariant ResultCorrect is violated.
```

**Означает:** Результат не соответствует ожидаемому.

**Действия:**
1. Изучите Error-Trace
2. Проверьте логику программы
3. Проверьте инвариант

---

## 🎓 Примеры

### Пример 1: Простая программа

```bash
# Генерация
frama-c -pluscal tests/test_simple.c

# В Toolbox:
# 1. Open test_simple.tla
# 2. Ctrl+T
# 3. New Model → Run (F11)
```

**Ожидается:** ~15 состояний, 0 ошибок

### Пример 2: С циклами

```bash
frama-c -pluscal tests/test_loops.c
```

**Ожидается:** ~50-100 состояний, несколько секунд

### Пример 3: С рекурсией

```bash
frama-c -pluscal tests/test_recursion.c
```

**Ожидается:** ~30-50 состояний

---

## 🐛 Частые проблемы

### "Module Bitwise not found"

**Решение:**
```bash
# Скачать CommunityModules
git clone https://github.com/tlaplus/CommunityModules.git

# В Toolbox:
# File → Preferences → TLA+ Preferences
# → TLA+ library path locations
# → Add: /path/to/CommunityModules/modules
```

### "PlusCal algorithm not translated"

**Решение:** Нажмите `Ctrl+T` в Toolbox

### "TLC ran out of memory"

**Решение:**
- В модели: `TLC Options → JVM arguments → -Xmx4G`
- Или уменьшите глубину поиска

---

## 📚 Дополнительно

### Полное руководство
См. [`doc/tla_toolbox_guide.md`](./doc/tla_toolbox_guide.md)

### Документация TLA+
- [TLA+ Home](https://lamport.azurewebsites.net/tla/tla.html)
- [Learn TLA+](https://learntla.com)
- [PlusCal Tutorial](https://lamport.azurewebsites.net/tla/pluscal.html)

### Примеры
- Все тесты в `tests/` можно проверить
- Начните с `test_simple.c`
- Затем попробуйте `test_loops.c`, `test_recursion.c`

---

## 🎯 Workflow

```
C код → frama-c → .tla файл → TLA+ Toolbox → Проверка
                                    ↓
                              Ctrl+T (translate)
                                    ↓
                              F11 (run TLC)
                                    ↓
                              Результаты
```

---

Удачи! 🚀

Для детального руководства см. [`doc/tla_toolbox_guide.md`](./doc/tla_toolbox_guide.md)
