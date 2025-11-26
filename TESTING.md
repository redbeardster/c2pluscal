# Руководство по тестированию C2PlusCal

## Запуск тестов

### Базовое тестирование

#### Python (рекомендуется)
```bash
cd tests
python3 run_tests.py
```

#### Bash
```bash
cd tests
./run_tests.sh
```

#### Make
```bash
make test
```

### Расширенное тестирование

#### С валидацией содержимого
```bash
cd tests
python3 run_tests_advanced.py --verbose
```

#### Сравнение с baseline (отслеживание регрессий)
```bash
cd tests
# Создать baseline
python3 test_comparison.py --save-baseline

# Сравнить текущие результаты с baseline
python3 test_comparison.py
```

#### Отчет о покрытии
```bash
cd tests
python3 generate_coverage_report.py
```

## Структура тестов

### Базовые (7 тестов)
- `test_simple.c` - базовые операции
- `test_conditionals.c` - условные операторы
- `test_loops.c` - циклы
- `test_pointers.c` - указатели
- `test_arrays.c` - массивы
- `test_structs.c` - структуры
- `test_recursion.c` - рекурсия

### Расширенные (5 тестов)
- `test_multiple_functions.c` - множественные функции
- `test_array_pointers.c` - массивы с указателями
- `test_nested_loops.c` - вложенные циклы
- `test_edge_cases.c` - граничные случаи
- `test_globals.c` - глобальные переменные

### Комплексный (1 тест)
- `test.c` - все возможности

**Всего: 13 тестов**

## Добавление новых тестов

1. Создайте `tests/test_<name>.c`
2. Запустите `./run_tests.sh`

## Отдельный тест

```bash
frama-c -pluscal tests/test_simple.c
```

Создаст `test_simple.tla` и `test_simple.cfg`
