

# Seed Products
products = [
  { name: 'Product 1', description: 'Description for product 1', price: 9.99 },
  { name: 'Product 2', description: 'Description for product 2', price: 19.99 },
  { name: 'Product 3', description: 'Description for product 3', price: 29.99 },
  { name: 'Product 4', description: 'Description for product 4', price: 39.99 },
  { name: 'Product 5', description: 'Description for product 5', price: 49.99 },
  { name: 'Product 6', description: 'Description for product 6', price: 59.99 },
  { name: 'Product 7', description: 'Description for product 7', price: 69.99 },
  { name: 'Product 8', description: 'Description for product 8', price: 79.99 },
]
Product.create(products)

# Seed Users
users = [
  { name: '111', password: '111' },
  { name: '222', password: '222' },
  { name: '333', password: '333' }
]
User.create(users)

puts "Database seeded successfully!"
