//Задача: Rate Limiter (ограничитель частоты) на замыканиях
//Ты пишешь функцию, которая возвращает замыкание‑“пропускатель” событий. Оно решает: разрешить действие или заблокировать, исходя из того, сколько раз его уже вызывали в текущем “окне”.
//
//1) Базовый лимитер: N вызовов, потом блок
//Сигнатура:
//
//Swift
//func makeLimiter(maxCalls: Int) -> () -> Bool
//Требование:
//
//Возвращаемое замыкание при каждом вызове возвращает true, пока число разрешённых вызовов < = maxCalls
//После того как лимит исчерпан — возвращает false
//Состояние (счётчик) должно храниться внутри замыкания (capture)
//Пример ожидаемого поведения:
//
//Swift
//let allow3 = makeLimiter(maxCalls: 3)
//
//allow3() // true
//allow3() // true
//allow3() // true
//allow3() // false
//allow3() // false
//2) Добавь reset (ещё один приём с замыканиями)
//Сделай версию, которая возвращает две функции: allow и reset.
//
//Вариант А (кортеж):
//
//Swift
//func makeLimiterWithReset(maxCalls: Int) -> (allow: () -> Bool, reset: () -> Void)
//Пример:
//
//Swift
//let limiter = makeLimiterWithReset(maxCalls: 2)
//
//limiter.allow() // true
//limiter.allow() // true
//limiter.allow() // false
//
//limiter.reset()
//
//limiter.allow() // true

func makeLimiter(_ maxCalls: Int) -> () -> Bool {
    var count = 0
    return {
        if count < maxCalls {
            count += 1
            return true
        } else {
            return false
        }
    }
}

let allow3 = makeLimiter(3)

for i in 1...5 {
    print("\(i) вызов: \(allow3())")
}

func makeLimiterWithReset(_ maxCalls: Int) -> (allow: () -> Bool, reset: () -> Void) {
    var count = 0
    return (allow: {
        if count < maxCalls {
            count += 1
            return true
        } else {
            return false
        }
    }, reset: {
        count = 0;
    })
}

let limiter = makeLimiterWithReset(2)

print("1 вызов: \(limiter.allow())")
print("2 вызов: \(limiter.allow())")
print("3 вызов: \(limiter.allow())")

print("reset")
limiter.reset()

print("4 вызов: \(limiter.allow())")

//@escaping нужен для того чтобы замыкание сохранилось к контексте функции
//после того как она отработала
func makePayer(_ limiter: @escaping () -> Bool) -> () -> Void {
    return {
        if limiter() {
            print("Transaction succsessful")
        }
        else {
            print("Transaction failed")
        }
    }
}

let allow2 = makeLimiter(2)
let payer = makePayer(allow2)

payer()
payer()
payer()
