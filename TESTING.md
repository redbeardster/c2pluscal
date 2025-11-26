# Руководство по тестированию C2PlusCal

## Запуск тестов

### Python (рекомендуется)
```bash
cd tests
python3 run_tests.py
```

### Bash
```bash
cd tests
./run_tests.sh
```

### Make
```bash
make test
```

## Структура тестов

- `test_simple.c` - базовые операции
- `test_conditionals.c` - условные операторы
- `test_loops.c` - циклы
- `test_pointers.c` - указатели
- `test_arrays.c` - массивы
- `test_structs.c` - структуры
- `test_recursion.c` - рекурсия
- `test.c` - комплексный тест

## Добавление новых тестов

1. Создайте `tests/test_<name>.c`
2. Запустите `./run_tests.sh`

## Отдельный тест

```bash
frama-c -pluscal tests/test_simple.c
```

Создаст `test_simple.tla` и `test_simple.cfg`
