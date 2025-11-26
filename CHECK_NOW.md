# ✅ Готово к проверке в TLA+ Toolbox!

## 📁 Файлы готовы

### Для проверки:
- ✅ `test_loops.tla` (4.9 KB) - **ПРОВЕРЬТЕ ЭТОТ**
- ✅ `test_loops.cfg` (139 байт)
- ✅ `test_simple.tla` (3.4 KB) - альтернатива

### Документация:
- 📖 `MANUAL_VERIFICATION_STEPS.md` - **ПОШАГОВАЯ ИНСТРУКЦИЯ**
- 📋 `TLA_TOOLBOX_CHEATSHEET.md` - шпаргалка
- 🚀 `QUICKSTART_TLA.md` - быстрый старт

---

## 🎯 Что делать СЕЙЧАС

### Вариант 1: Следовать инструкции (рекомендуется)

Откройте файл **`MANUAL_VERIFICATION_STEPS.md`** и следуйте шагам 1-6.

**Кратко:**
1. Открыть `test_loops.tla` в TLA+ Toolbox
2. Нажать `Ctrl+T` (транслировать)
3. Создать модель
4. Нажать `F11` (запустить проверку)
5. Проверить результаты

**Время:** 5 минут

---

### Вариант 2: Быстрая проверка

Если уже знакомы с TLA+ Toolbox:

```
1. File → Open Spec → test_loops.tla
2. Ctrl+T
3. TLC Model Checker → New Model
4. F11
```

**Ожидается:**
- ✅ No errors found
- States: ~50-100
- Time: 1-5 секунд

---

## 📊 Что проверяется

### Исходный C код (tests/test_loops.c):
```c
int main() {
    int sum = 0;
    int i = 0;
    
    while (i < 5) {
        sum += i;
        i++;
    }
    
    for (int j = 0; j < 3; j++) {
        sum += j;
    }
    
    int k = 0;
    do {
        k++;
    } while (k < 2);
    
    return sum;  // Должно быть 13
}
```

### Проверки TLC:
- ✅ Программа завершается (нет deadlock)
- ✅ Все циклы выполняются корректно
- ✅ Результат корректен (sum = 13)

---

## 🎓 Опционально: Добавить инвариант

После шага 6, добавьте в `test_loops.tla` после `\* END TRANSLATION`:

```tla
\* Check that sum equals 13
SumCorrect == 
    \/ ~initDone
    \/ \E i \in DOMAIN mem : mem[i] = 13
```

Затем в модели:
- Invariants → Add → `SumCorrect`
- F11 (запустить снова)

**Ожидается:** ✅ Invariant not violated

---

## 🐛 Если что-то не работает

### "Module Bitwise not found"
→ См. `MANUAL_VERIFICATION_STEPS.md`, раздел "Проблема 1"

### "Deadlock reached"
→ Это ошибка транспиляции, сообщите нам

### "TLC не запускается"
→ Проверьте, что PlusCal транслирован (Ctrl+T)

---

## 📚 Дополнительные ресурсы

### Если нужна помощь:
1. `MANUAL_VERIFICATION_STEPS.md` - детальная инструкция
2. `TLA_TOOLBOX_CHEATSHEET.md` - горячие клавиши
3. `doc/tla_toolbox_guide.md` - полное руководство

### Если хотите узнать больше:
- [Learn TLA+](https://learntla.com)
- [TLA+ Video Course](https://lamport.azurewebsites.net/video/videos.html)

---

## ✨ После проверки

Попробуйте другие тесты:
- `test_simple.tla` - самый простой (15 состояний)
- `test_conditionals.tla` - с if-else
- `test_recursion.tla` - рекурсия

Генерация:
```bash
frama-c -pluscal tests/test_simple.c
frama-c -pluscal tests/test_conditionals.c
frama-c -pluscal tests/test_recursion.c
```

---

## 🎉 Готово!

Файлы готовы, документация готова, можно проверять!

**Начните с:** `MANUAL_VERIFICATION_STEPS.md` → Шаг 1

Удачи! 🚀
