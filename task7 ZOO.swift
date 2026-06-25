import Foundation

struct AnimalNames {
    static let pool = [
        "Барсик",
        "Рыжик",
        "Снежок",
        "Тучка",
        "Гром",
        "Луна",
        "Ветер",
        "Туман",
        "Малыш",
        "Буран",
        "Искра",
        "Зубастик",
        "Хвостик",
        "Соня",
        "Шустрик",
        "Пушок",
        "Смоки",
        "Коготь",
        "Янтарь",
        "Рокки"
    ]
    
    static func generateUniqueName(
        for species: AnimalSpices,
        among animals: [Animal]
    ) -> String? {

        let usedNames = Set(
            animals
                .filter { $0.spices == species }
                .map(\.name)
        )

        let availableNames = pool.filter {
            !usedNames.contains($0)
        }

        return availableNames.randomElement()
    }
}

enum AnimalSpices: CaseIterable {
    case bear
    case wolf
    case chicken
    case fox
    case rabbit
    case deer
    case boar
    case mouse
    case eagle
    case snake

    var maxAge: Int {
        switch self {
        case .bear: return 30
        case .wolf: return 15
        case .chicken: return 8
        case .fox: return 10
        case .rabbit: return 6
        case .deer: return 20
        case .boar: return 15
        case .mouse: return 3
        case .eagle: return 25
        case .snake: return 18
        }
    }
    
    var foodFindChance: Double {
        switch self {
        case .bear: return 0.90
        case .wolf: return 0.70
        case .chicken: return 0.95
        case .fox: return 0.80
        case .rabbit: return 0.90
        case .deer: return 0.85
        case .boar: return 0.80
        case .mouse: return 0.95
        case .eagle: return 0.70
        case .snake: return 0.70
        }
    }

    var reproductionChance: Double {
        switch self {
        case .bear: return 0.15
        case .wolf: return 0.25
        case .chicken: return 0.80
        case .fox: return 0.30
        case .rabbit: return 0.90
        case .deer: return 0.40
        case .boar: return 0.35
        case .mouse: return 0.95
        case .eagle: return 0.10
        case .snake: return 0.20
        }
    }

    var name: String {
        switch self {
        case .bear: return "🐻Медведь"
        case .wolf: return "🐺Волк"
        case .chicken: return "🐔Курица"
        case .fox: return "🦊Лиса"
        case .rabbit: return "🐰Кролик"
        case .deer: return "🦌Олень"
        case .boar: return "🐗Кабан"
        case .mouse: return "🐭Мышь"
        case .eagle: return "🦅Орёл"
        case .snake: return "🐍Змея"
        }
    }
}

class Animal {
    var spices: AnimalSpices
    var name: String
    var age: Int
    var satiety: Int
    var isAlive: Bool = true

    init(
        spices: AnimalSpices,
        name: String,
        age: Int,
        satiety: Int
    ) {
        self.spices = spices
        self.name = name
        self.age = age
        self.satiety = satiety
    }
    
    func growOlder() -> Bool {
        if isAlive {
            age += 1
            toHunger()
            tryFindFood()
            isGonnaDie()
            let hasReproduced = tryReproduce()
            printInfo()
            return hasReproduced
        }
        return false
    }
    
    func toHunger() {
        satiety -= 1
    }
    
    func tryFindFood() {
        if Double.random(in: 0...1) < spices.foodFindChance {
            satiety += 1
            print("\(spices.name) \(name) found food 😋")
        }
        else {
            print("\(spices.name) \(name) didn`t found food 😢")
        }
    }
    
    func tryReproduce() -> Bool {
        if Double.random(in: 0...1) < spices.reproductionChance {
            satiety += 1
            print("\(spices.name) \(name) reproduced 🐣")
            return true
        }
        return false
    }
    
    func isGonnaDie() {
        if (age > spices.maxAge || satiety < 0) {
            isAlive = false
            print("\(spices.name) \(name) died ☠️")
        } else {
            print("\(spices.name) \(name) survived 🥳")
        }
    }
    
    func printInfo() {
        print("\(spices.name) \(name) is \(age) years old, \(satiety) satiety, \(isAlive ? "alive" : "dead")")
    }
}

class Zoo {
    var animals: [Animal]
    var day: Int = 0
    
    var births = 0
    
    init(animals: [Animal]) {
        self.animals = animals
    }
    
    func addAnimal(spices: AnimalSpices, name: String, age: Int, satiety: Int = 10) {
        animals.append(
            Animal(
                spices: spices,
                name: name,
                age: 0,
                satiety: satiety
            )
        )
    }
    
    func nextDay() -> Bool {
        day += 1
        
        var newborns: [Animal] = []
        
        let aliveAnimals = animals.filter { $0.isAlive }
        if (aliveAnimals.count == 0) {
            return false
        }
        for animal in aliveAnimals {
            let (hasReproduced) = animal.growOlder()
            if (hasReproduced) {
                if let name = AnimalNames.generateUniqueName(
                    for: animal.spices,
                    among: animals
                ) {
                    births += 1
                    newborns.append(
                        Animal(
                            spices: animal.spices,
                            name: name,
                            age: 0,
                            satiety: 10
                        )
                    )
                }
            }
        }
        animals += newborns
        return true
    }
    
    func runSimulation(days: Int) {
        for _ in 0..<days {
            let success = nextDay()
            if (!success) {
                print("Fauna extinction! 😱");
                break
            }
        }
        printStatistics(days: days)
    }
    
    func printStatistics(days: Int) {
        print("\n===== ZOO STATISTICS =====")
        print("Days passed: \(days)")

        let aliveAnimals = animals.filter { $0.isAlive }
        let deadAnimals = animals.filter { !$0.isAlive }

        print("Total animals: \(animals.count)")
        print("Alive: \(aliveAnimals.count)")
        print("Dead: \(deadAnimals.count)")
        print("Born: \(births)")
        print("Net growth: \(births - deadAnimals.count)")

        let averageAge =
            animals.isEmpty
            ? 0
            : Double(animals.map(\.age).reduce(0, +))
                / Double(animals.count)

        print(
            String(
                format: "Average age: %.2f",
                averageAge
            )
        )

        if let oldest = animals.max(by: { $0.age < $1.age }) {
            print(
                "Oldest animal: \(oldest.spices.name) \(oldest.name) (\(oldest.age) years)"
            )
        }

        print("\nPopulation by species:")

        for species in AnimalSpices.allCases {
            let count = animals.filter {
                $0.spices == species && $0.isAlive
            }.count

            print("  \(species.name): \(count)")
        }

        print("==========================")
    }
}


let animals = [
    Animal(
        spices: .bear,
        name: "Буран",
        age: 5,
        satiety: 10
    ),
    Animal(
        spices: .wolf,
        name: "Серый",
        age: 3,
        satiety: 10
    ),
    Animal(
        spices: .chicken,
        name: "Ряба",
        age: 1,
        satiety: 10
    )
]

let zoo = Zoo(animals: animals)

zoo.runSimulation(days: 10)
