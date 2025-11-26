# Руководство по реализации нереализованных возможностей

## 🎯 Где находится код

### Основные файлы

| Файл | Назначение |
|------|------------|
| `src/pc_gen.ml` | Генерация PlusCal IR из Frama-C AST |
| `src/pc_dump.ml` | Дамп PlusCal IR в .tla файлы |
| `src/pc.ml` | Определения типов PlusCal IR |
| `src/pc_utils.ml` | Утилиты |

---

## 🔥 Задача 1: Поддержка `switch` statements

### Текущее состояние
**Файл:** `src/pc_gen.ml`, строка 317  
**Статус:** Не реализовано

```ocaml
(**
  The function does not handle the following cases :
    - [Try]
    - [Throw]
    - [Continue]
    - [Switch]  (* <-- ЗДЕСЬ *)
**)
let rec pc_of_stmt = function
  (* ... *)
```

### Что нужно сделать

#### 1. Добавить в IR (`src/pc.ml`)
```ocaml
type pc_instr = 
  | ...
  | PSwitch of pc_expr * (pc_expr * pc_instr list) list * pc_instr list
  (* PSwitch(condition, [(case_value, case_body)], default_body) *)
```

#### 2. Реализовать в генераторе (`src/pc_gen.ml`)
```ocaml
let rec pc_of_stmt = function
  (* ... existing cases ... *)
  
  | Switch (e, cases, default, _) ->
    (* Преобразовать switch в if-else цепочку *)
    let pc_switch = 
      Result.bind (pc_of_exp e.enode) (fun ok_exp ->
        (* Обработать каждый case *)
        let pc_cases = List.map (fun case -> 
          (* case.labels содержит Case(exp) или Default *)
          (* case.skind содержит тело case *)
          ...
        ) cases in
        Result.ok [PSwitch (ok_exp, pc_cases, default_body)]
      )
    in
    pc_switch, ...
```

#### 3. Реализовать дамп (`src/pc_dump.ml`)
```ocaml
let rec dump_pc_instr proc_name out indent instr = match instr with
  (* ... existing cases ... *)
  
  | PSwitch (cond, cases, default) ->
    (* Преобразовать в if-else цепочку в PlusCal *)
    Format.fprintf out "%sif " indent;
    dump_pc_expr proc_name out cond;
    Format.fprintf out " = ";
    (* Первый case *)
    ...
```

#### 4. Добавить тесты
```c
// tests/test_switch.c
int main() {
    int x = 2;
    int result = 0;
    
    switch (x) {
        case 1:
            result = 10;
            break;
        case 2:
            result = 20;
            break;
        default:
            result = 30;
    }
    
    return result;  // Должно быть 20
}
```

### Сложности
- Fall-through между cases (без break)
- Вложенные switch
- Case с диапазонами (GNU extension)

---

## 🔥 Задача 2: Поддержка `continue`

### Текущее состояние
**Файл:** `src/pc_gen.ml`, строка 316  
**Статус:** Не реализовано

### Что нужно сделать

#### 1. Добавить в IR (`src/pc.ml`)
```ocaml
type pc_instr = 
  | ...
  | PContinue of pc_label  (* Метка начала цикла *)
```

#### 2. Реализовать в генераторе (`src/pc_gen.ml`)
```ocaml
let rec pc_of_stmt = function
  (* ... *)
  
  | Continue _ ->
    (* Нужно знать метку начала текущего цикла *)
    (* Возможно, передавать контекст с меткой цикла *)
    Result.ok [PContinue loop_start_label], 0
```

#### 3. Реализовать дамп (`src/pc_dump.ml`)
```ocaml
| PContinue label ->
  Format.fprintf out "%sgoto %s;\n" indent label
```

#### 4. Добавить тесты
```c
// tests/test_continue.c
int main() {
    int sum = 0;
    
    for (int i = 0; i < 10; i++) {
        if (i % 2 == 0) {
            continue;  // Пропустить четные
        }
        sum += i;
    }
    
    return sum;  // 1+3+5+7+9 = 25
}
```

### Сложности
- Нужен контекст текущего цикла
- Вложенные циклы
- Continue в do-while

---

## 🔥 Задача 3: Исправить пропущенные метки

### Текущее состояние
**Проблема:** Метки Frama-C пропускаются в некоторых блоках

**Где искать:** `src/pc_gen.ml`, функции обработки блоков

### Что нужно сделать

#### 1. Найти, где пропускаются блоки
```ocaml
(* Найти места, где используется: *)
(* - List.length b.bstmts *)
(* - pc_of_block b.bstmts *)
(* Эти места могут пропускать метки *)
```

#### 2. Хранить trace посещенных statements
```ocaml
(* Добавить в контекст *)
type gen_context = {
  visited_stmts: stmt list;
  current_labels: label list;
}

(* При посещении statement *)
let visit_stmt ctx stmt =
  let labels = stmt.labels in
  (* Сохранить метки *)
  { ctx with 
    visited_stmts = stmt :: ctx.visited_stmts;
    current_labels = labels @ ctx.current_labels 
  }
```

#### 3. Извлекать метки при необходимости
```ocaml
(* Вместо пропуска блока *)
(* Извлечь метки из всех statements в блоке *)
let extract_labels block =
  List.concat_map (fun stmt -> stmt.labels) block.bstmts
```

#### 4. Добавить тесты
```c
// tests/test_labels.c
int main() {
    int x = 0;
    
    if (x == 0) {
        label1:  // Эта метка должна сохраниться
        x = 1;
    }
    
    goto label1;  // Должно работать
    
    return x;
}
```

---

## ⭐ Задача 4: Исправить дубликаты меток

### Текущее состояние
**Проблема:** Frama-C метки могут дублироваться

### Что нужно сделать

#### 1. Добавить номер строки к меткам (`src/pc_utils.ml`)
```ocaml
(* Функция для создания уникальной метки *)
let make_unique_label label line_num =
  Printf.sprintf "%s_line_%d" label line_num

(* Использовать при генерации меток *)
let label_to_string stmt =
  let line = (fst stmt.sloc).Filepath.pos_lnum in
  List.map (fun label ->
    match label with
    | Label (name, _, _) -> make_unique_label name line
    | _ -> ...
  ) stmt.labels
```

#### 2. Обновить все места, где используются метки
```ocaml
(* В pc_gen.ml *)
(* При создании PLabel *)
| PLabel label -> 
  let unique_label = make_unique_label label line_num in
  ...
```

#### 3. Добавить тесты
```c
// tests/test_duplicate_labels.c
int main() {
    int x = 0;
    
    if (x == 0) {
        loop:  // Строка 5
        x++;
    }
    
    while (x < 10) {
        loop:  // Строка 10 - дубликат!
        x++;
    }
    
    return x;
}
```

---

## ⭐ Задача 5: Поддержка `typedef`

### Текущее состояние
**Статус:** Не реализовано

### Что нужно сделать

#### 1. Обработать typedef в Frama-C AST
```ocaml
(* Frama-C уже разрешает typedef *)
(* Нужно просто использовать разрешенные типы *)

(* В pc_gen.ml *)
let type_of_varinfo vi =
  (* vi.vtype уже содержит разрешенный тип *)
  match vi.vtype with
  | TInt _ -> "Int"
  | TPtr _ -> "Ptr"
  | TNamed (ti, _) -> 
    (* ti.tname содержит имя typedef *)
    (* ti.ttype содержит реальный тип *)
    type_of_typ ti.ttype
  | ...
```

#### 2. Добавить тесты
```c
// tests/test_typedef.c
typedef int my_int;
typedef struct { int x; int y; } Point;

int main() {
    my_int a = 5;
    Point p = {10, 20};
    
    return a + p.x;
}
```

---

## ⭐ Задача 6: Генерация TypeOK

### Текущее состояние
**Статус:** Не реализовано

### Что нужно сделать

#### 1. Собрать информацию о типах
```ocaml
(* В pc_gen.ml *)
type type_info = {
  var_name: string;
  var_type: string;  (* "Int", "Ptr", "Array", "Struct" *)
  constraints: string list;  (* Например, "x >= 0", "x < 100" *)
}

let collect_types prog =
  (* Собрать типы всех переменных *)
  ...
```

#### 2. Генерировать TypeOK в .tla файле
```ocaml
(* В pc_dump.ml *)
let dump_typeok out prog =
  Format.fprintf out "\n";
  Format.fprintf out "TypeOK ==\n";
  Format.fprintf out "  /\\ mem \\in Seq(Int)\n";
  Format.fprintf out "  /\\ initDone \\in BOOLEAN\n";
  (* Для каждой переменной *)
  List.iter (fun var ->
    Format.fprintf out "  /\\ %s \\in %s\n" var.name var.type_constraint
  ) prog.variables;
  Format.fprintf out "\n"
```

#### 3. Добавить в .cfg файл
```ocaml
(* В config_dump.ml *)
Format.fprintf out "INVARIANT\n";
Format.fprintf out "  TypeOK\n";
```

---

## 📝 Общий процесс реализации

### Для каждой задачи:

1. **Изучить существующий код**
   ```bash
   grep -r "keyword" src/
   ```

2. **Добавить в IR** (`src/pc.ml`)
   - Определить новый тип инструкции
   - Обновить документацию

3. **Реализовать генерацию** (`src/pc_gen.ml`)
   - Обработать Frama-C AST
   - Создать PlusCal IR

4. **Реализовать дамп** (`src/pc_dump.ml`)
   - Преобразовать IR в TLA+
   - Обработать edge cases

5. **Добавить тесты**
   - Создать `tests/test_feature.c`
   - Проверить генерацию
   - Проверить с TLC

6. **Обновить документацию**
   - `doc/limitations.md` - убрать из списка
   - `README.md` - добавить в возможности
   - `CHANGELOG.md` - добавить в изменения

---

## 🛠️ Полезные команды

### Поиск в коде
```bash
# Найти все места, где обрабатывается statement
grep -n "pc_of_stmt" src/pc_gen.ml

# Найти определения типов
grep -n "type pc_instr" src/pc.ml

# Найти дамп инструкций
grep -n "dump_pc_instr" src/pc_dump.ml
```

### Тестирование
```bash
# Пересобрать
cd src && dune build && dune install

# Протестировать
frama-c -pluscal tests/test_new_feature.c

# Проверить с TLC
java -cp ~/toolbox/tla2tools.jar pcal.trans test_new_feature.tla
java -cp ~/toolbox/tla2tools.jar tlc2.TLC test_new_feature.tla
```

### Отладка
```bash
# Дамп отладочной информации
frama-c -pluscal -debug-dump tests/test.c
cat test.dump
```

---

## 🎯 С чего начать?

### Рекомендация: Начать с задачи 4 (дубликаты меток)

**Причины:**
1. Самая простая (1 день)
2. Улучшает надежность
3. Хорошее введение в кодовую базу
4. Быстрый результат

**Следующие шаги:**
1. Изучить `src/pc_utils.ml` и `src/pc_gen.ml`
2. Найти, где создаются метки
3. Добавить функцию `make_unique_label`
4. Обновить все места использования
5. Добавить тест
6. Проверить

---

Готовы начать? Выберите задачу! 🚀
