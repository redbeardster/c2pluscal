# C2PlusCal Test Suite

Набор тестов для проверки корректности транспиляции C в PlusCal.

## Структура тестов

### Базовые тесты
- `test_simple.c` - базовые арифметические операции
- `test_conditionals.c` - условные операторы (if-else)
- `test_loops.c` - циклы (while, for, do-while)
- `test_pointers.c` - указатели и разыменование
- `test_arrays.c` - массивы и индексация
- `test_structs.c` - структуры и доступ к полям
- `test_recursion.c` - рекурсивные функции

### Расширенные тесты
- `test_multiple_functions.c` - множественные вызовы функций
- `test_array_pointers.c` - массивы с указателями
- `test_nested_loops.c` - вложенные циклы
- `test_edge_cases.c` - граничные случаи
- `test_globals.c` - глобальные переменные

### Комплексный тест
- `test.c` - все возможности вместе

## Запуск тестов

### Python (рекомендуется):
```bash
cd tests
python3 run_tests.py
```

### Bash:
```bash
cd tests
./run_tests.sh
```

### Make:
```bash
make test
```

### Отдельный тест:
```bash
frama-c -pluscal tests/test_simple.c
```

## Расширенное тестирование

### Валидация содержимого
```bash
python3 run_tests_advanced.py --verbose
```

### Сравнение с baseline
```bash
# Создать baseline
python3 test_comparison.py --save-baseline

# Сравнить с baseline
python3 test_comparison.py
```

### Отчет о покрытии
```bash
python3 generate_coverage_report.py
```

## Добавление новых тестов

1. Создайте файл `test_<name>.c` в директории `tests/`
2. Запустите `./run_tests.sh` для проверки
3. Обновите baseline: `python3 test_comparison.py --save-baseline`
