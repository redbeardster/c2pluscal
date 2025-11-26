# C2PlusCal Test Suite

Набор тестов для проверки корректности транспиляции C в PlusCal.

## Структура тестов

- `test_simple.c` - базовые арифметические операции
- `test_conditionals.c` - условные операторы (if-else)
- `test_loops.c` - циклы (while, for, do-while)
- `test_pointers.c` - указатели и разыменование
- `test_arrays.c` - массивы и индексация
- `test_structs.c` - структуры и доступ к полям
- `test_recursion.c` - рекурсивные функции
- `test.c` - комплексный тест

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

## Добавление новых тестов

1. Создайте файл `test_<name>.c` в директории `tests/`
2. Запустите `./run_tests.sh` для проверки
