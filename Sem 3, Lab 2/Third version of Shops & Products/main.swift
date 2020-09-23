//
//  main.swift
//  Third version of Shops & Products
//
//  Created by Даниил Храповицкий on 23.09.2020.
//

import Foundation

let manager = ShopManager()

manager.createShop(name: "Пятёрочка", address: "Стремянная ул. 1")
manager.createShop(name: "Семишагофф", address: "Владимирский пр. 13")
manager.createShop(name: "Перекрёсток", address: "Лиговский пр. 30")

print("Магазины:")
manager.print(.shop)

manager.createProduct(name: "Курица")
manager.createProduct(name: "Печенье")
manager.createProduct(name: "Чай")
manager.createProduct(name: "Капуста")
manager.createProduct(name: "Шоколад")
manager.createProduct(name: "Грибы")
manager.createProduct(name: "Огурцы")
manager.createProduct(name: "Помидоры")
manager.createProduct(name: "Морепродукты")
manager.createProduct(name: "Майонез")

print("Товары:")
manager.print(.product)

manager.addToConsignments(product: manager.products[6], price: 2500, quantity: 20)
manager.addToConsignments(product: manager.products[4], price: 60, quantity: 50)
manager.addToConsignments(product: manager.products[3], price: 60, quantity: 80)
manager.addToConsignments(product: manager.products[1], price: 30, quantity: 30)
manager.addToConsignments(product: manager.products[9], price: 80, quantity: 20)

print("Первая партия:")
manager.print(.consignment)

manager.addConsignments(to: manager.shops[0])

print("Товары в первом магазине:")
manager.printProducts(in: manager.shops[0])

manager.clearConsignment()

manager.addToConsignments(product: manager.products[4], price: 50, quantity: 20)
manager.addToConsignments(product: manager.products[1], price: 80, quantity: 1)
manager.addToConsignments(product: manager.products[6], price: 15, quantity: 30)
manager.addToConsignments(product: manager.products[2], price: 50, quantity: 80)

manager.addConsignments(to: manager.shops[1])

manager.clearConsignment()

print("Товары во втором магазине:")
manager.printProducts(in: manager.shops[1])

manager.addToConsignments(product: manager.products[0], price: 120, quantity: 50)
manager.addToConsignments(product: manager.products[1], price: 40, quantity: 30)
manager.addToConsignments(product: manager.products[8], price: 400, quantity: 10)
manager.addToConsignments(product: manager.products[5], price: 70, quantity: 70)
manager.addToConsignments(product: manager.products[7], price: 20, quantity: 50)
manager.addToConsignments(product: manager.products[6], price: 10, quantity: 60)
manager.addToConsignments(product: manager.products[2], price: 80, quantity: 100)

manager.addConsignments(to: manager.shops[2])

manager.clearConsignment()

print("Товары в последнем магазине:")
manager.printProducts(in: manager.shops[2])

print("Где самый дешевый чай?")
print(manager.findShopWithMinPrice(forProduct: manager.products[1])!.name, terminator: "\n\n")


print("Сколько можем купить товара \"\(manager.products[4].name)\" в магазине \"\(manager.shops[0].name)\"?")
print(manager.returnQuantityOf(product: manager.products[4], forPrice: 150, in: manager.shops[0])!, terminator: "\n\n")

manager.addToCart(product: manager.products[2], quantity: 7)
manager.addToCart(product: manager.products[7], quantity: 10)
manager.addToCart(product: manager.products[8], quantity: 5)

print("Наша корзина")
manager.print(.cart)

print("Купить партию товаров \"\(manager.products[2].name)\", \"\(manager.products[7].name)\" и \"\(manager.products[8].name)\" в количестве 7, 10 и 5 штук соответственно:")

print(manager.buy(in: manager.shops[2])!, terminator: "\n\n")

print("Проверяем, что товары убавились")
manager.printProducts(in: manager.shops[2])

manager.clearCart()

manager.addToCart(product: manager.products[1], quantity: 2)
manager.addToCart(product: manager.products[2], quantity: 7)

print("Наша новая корзина")
manager.print(.cart)

print("Найти, где \"\(manager.products[1].name)\" в количестве 2 и \"\(manager.products[2].name)\" в количестве 7 дешевле")
print(manager.findShopWithMinPriceForProductsInCart()!.name)
