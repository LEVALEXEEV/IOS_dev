// Выбранный метод
// contains

//1. Краткое описание
//Метод contains перебирает элементы в массие и возвращает true, если встречает элемент равный параметру
//Также можно вызвать фунцию с предикатом, так contains перебирает элементы массива, к каждому применяет предикат
//и возвращает true если предикат также вернул true

//2. Пример использования
let array = [1, 2, 3, 4, 5, 6]
print("ОРИГИНАЛЬНЫЙ МЕТОД:")
print("Массив \(array) содержит значение 1: \(array.contains(1))")
print("Массив \(array) содержит значение 2: \(array.contains(2))")
print("Массив \(array) содержит значение 10: \(array.contains(10))")
print("Массив \(array) содержит значение кратное 2: \(array.contains {$0.isMultiple(of: 2)})")
print("Массив \(array) содержит значение кратное 10: \(array.contains {$0.isMultiple(of: 10)})")

//3. Полифил
//5. Объясние работы
//Функция принимает 2 аргумента: массив и значение одного типа
//У типа должна быть предусмотрена возможность сравнения, поэтому тип наследуется от Equatable
func contains<T: Equatable>(array: [T], value: T) -> Bool {
    for element in array { //перебираются элементы в массиве
        if element == value { //если находится элемент равный параметру возвращает true
            return true
        }
    }
    return false //если все элементы перебраны, а равный не нашелся, возвращает false
}

//Применяется перегрузка метода, компилятор сам выбирает подходящий
//Функция принимает массив и предикат
func contains<T>(array: [T], where predicate: (T) -> Bool) -> Bool {
    for element in array { //перебираются элементы в массиве
        if predicate(element) { //если предикат возвращает true, функция тоже возвращает true
            return true
        }
    }
    return false //если все элементы перебраны, и ни один предикат не вернул true, возвращает false
}

//4. Пример использования полифила
print("ФУНКЦИЯ ПОЛИФИЛ:")
print("Массив \(array) содержит значение 1: \(contains(array: array, value: 1))")
print("Массив \(array) содержит значение 2: \(contains(array: array, value: 2))")
print("Массив \(array) содержит значение 10: \(contains(array: array, value: 10))")
print("Массив \(array) содержит значение кратное 2: \(contains(array: array, where: { $0.isMultiple(of: 2) }))")
print("Массив \(array) содержит значение кратное 10: \(contains(array: array, where: { $0.isMultiple(of: 10) }))")
