//
//  Manager.swift
//  Third version of Shops & Products
//
//  Created by Даниил Храповицкий on 23.09.2020.
//

import Foundation

final class ShopManager {
    enum EntityType {
        case shop
        case product
        case consignment
        case cart
    }
    
    var shops: [Shop] = []
    var products: [Product] = []
    var consignment: [(product: Product, price: UInt, quantity: UInt)] = []
    var cart: [(product: Product, quantity: UInt)] = []
    
    func createShop(name: String, address: String) {  // 1. Создать магазин
        if let _ = shops.firstIndex(where: { $0.name == name && $0.address == address }) { return }
        
        shops.append(Shop(id: shops.count, name: name, address: address))
    }
    
    func createProduct(name: String) {  // 2. Создать товар
        products.append(Product(id: products.count, name: name))
    }
    
    func addToConsignments(product: Product, price: UInt, quantity: UInt) {  // Добавить товар в партию
        consignment.append((product: product, price: price, quantity: quantity))
    }
    
    func addToCart(product: Product, quantity: UInt) {
        if let _ = cart.firstIndex(where: { $0.product == product }) { return }
        cart.append((product: product, quantity: quantity))
    }
    
    func clearCart() {
        cart.removeAll()
    }
    
    func removeFromCart(at index: Int) {
        cart.remove(at: index)
    }
    
    func addConsignments(to shop: Shop) {  // 3. Завезти партию в магазин
        shop.add(consignment)
    }
    
    func findShopWithMinPrice(forProduct product: Product) -> Shop? {  // 4. Найти магазин с минимальной ценой
        var shopWithMinPrice: Shop? = nil
        
        for shop in shops {
            if let index = shop.products.firstIndex(where: { $0.product == product }) {
                if let currentIndex = shopWithMinPrice?.products.firstIndex(where: { $0.product == product }) {
                    if shopWithMinPrice!.products[currentIndex].price > shop.products[index].price {
                        shopWithMinPrice = shop
                    }
                } else {
                    shopWithMinPrice = shop
                }
            }
        }
        
        return shopWithMinPrice
    }
    
    func returnQuantityOf(product: Product, forPrice price: UInt, in shop: Shop) -> UInt? {  // 5. Найти количество товара, которое можно купить за цену
        return shop.returnQuantityOf(product: product, withPrice: price)
    }
    
    func buy(in shop: Shop) -> UInt? {
        shop.buy(cart)
    }
    
    func findShopWithMinPriceForProductsInCart() -> Shop? {
        var shopWithMinPrice: (shop: Shop?, price: UInt) = (shop: nil, price: UInt.max)
        
        shop: for shop in shops {
            var fullPrice: UInt = 0
            
            for product in cart {
                if let index = shop.products.firstIndex(where: { $0.product == product.product }), shop.products[index].quantity >= product.quantity {  // Наличие товара в магазине
                    fullPrice += (shop.products[index].price * product.quantity)
                } else {
                    continue shop
                }
            }
            
            if shopWithMinPrice.price > fullPrice {
                shopWithMinPrice.shop = shop
                shopWithMinPrice.price = fullPrice
            }
        }
        
        return shopWithMinPrice.shop
    }
    
    func print(_ type: EntityType) {
        switch type {
        case .shop:
            for shop in shops {
                shop.print()
            }
            Swift.print()
            
        case .product:
            for product in products {
                product.print()
            }
            Swift.print()
            
        case .consignment:
            for index in consignment.indices {
                Swift.print("\(index):\"\(consignment[index].product.name)\" — \(consignment[index].price) : \(consignment[index].quantity)")
            }
            Swift.print()
            
        case .cart:
            for product in cart {
                Swift.print("\"\(product.product.name)\" : \(product.quantity)")
            }
            Swift.print()
        }
    }
    
    func printProducts(in shop: Shop) {
        shop.printProducts()
        Swift.print()
    }
    
    func clearConsignment() {
        consignment.removeAll()
    }
    
    func removeFromConsignment(at index: Int) {
        consignment.remove(at: index)
    }
}

extension ShopManager {
    final class Shop {
        private(set) var id: Int
        private(set) var name: String
        private(set) var address: String
        
        private(set) var products: [(product: Product, price: UInt, quantity: UInt)] = []
        
        fileprivate init(id: Int, name: String, address: String) {
            self.id = id
            self.name = name
            self.address = address
        }
        
        fileprivate func add(_ cart: [(product: Product, price: UInt, quantity: UInt)]) {
            add: for newProduct in cart {
                for var product in products {
                    if product.product == newProduct.product && product.price == newProduct.price {
                        product.quantity += newProduct.quantity
                        
                        continue add
                    } else if product.product == newProduct.product && product.price != newProduct.price {
                        product.price = newProduct.price
                        product.quantity += newProduct.quantity
                        
                        continue add
                    }
                }
                
                products.append((product: newProduct.product, price: newProduct.price, quantity: newProduct.quantity))
            }
        }
        
        fileprivate func returnQuantityOf(product: Product, withPrice price: UInt) -> UInt? {
            guard let index = products.firstIndex(where: { $0.product == product }) else { return nil }
            
            return price / products[index].price
        }
        
        fileprivate func buy(_ cart: [(product: Product, quantity: UInt)]) -> UInt? {
            var price: UInt = 0
            
            for product in cart {
                if let index = products.firstIndex(where: { $0.product == product.product }) {
                    if product.quantity < products[index].quantity {
                        price += (product.quantity * products[index].price)
                    } else {
                        return nil
                    }
                }
            }
            
            for product in cart {
                if let index = products.firstIndex(where: { $0.product == product.product }) {
                    products[index].quantity -= product.quantity
                }
            }
            
            return price
        }
        
        fileprivate func print() {
            Swift.print("\(id): \"\(name)\", \(address)")
        }
        
        fileprivate func printProducts() {
            for product in products {
                Swift.print("\"\(product.product.name)\" — \(product.price) : \(product.quantity)")
            }
        }
    }
    
    final class Product: Equatable {
        private(set) var id: Int
        private(set) var name: String
        
        fileprivate init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
        
        static func == (lhs: Product, rhs: Product) -> Bool {
            return lhs.id == rhs.id
        }
        
        fileprivate func print() {
            Swift.print("\(id): \"\(name)\"")
        }
    }
}
