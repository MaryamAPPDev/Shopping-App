# 🛍️ Flutter Dummy Shopping App

A modern and scalable **Flutter E-Commerce Demo Application** built using **Provider State Management** and REST API integration.

This project demonstrates clean architecture, professional UI design, cart quantity management, and a complete checkout flow (demo).

---

## 🚀 Features

### 🏠 Home Screen
- Fetches products from API
- Displays products in grid layout
- Smooth navigation to Product Details
- Hero animations for images

### 📄 Product Detail Screen
- Image preview with SliverAppBar
- Category badge
- Product description
- Quantity increase / decrease
- Dynamic total price calculation
- Add to Cart / Remove from Cart functionality

### 🛒 Cart Screen
- Displays unique products
- Quantity management (+ / -)
- Remove single quantity
- Remove entire product
- Subtotal & Total calculation
- Checkout dialog
- Empty cart UI state

---

## 📸 App Screenshots

> 📌 Place your screenshots inside:  
> `assets/screenshots/`

### 🏠 Home Screen
![Home Screen](assets/screenshots/home.png)

### 📄 Product Detail Screen
![Product Detail](assets/screenshots/product_detail.png)

### 🛒 Cart Screen
![Cart Screen](assets/screenshots/cart.png)

### 💳 Checkout Dialog
![Checkout](assets/screenshots/checkout.png)

---

### 📌 Side-by-Side Preview Layout (Optional)

<p align="center">
  <img src="assets/screenshots/home.png" width="250"/>
  <img src="assets/screenshots/product_detail.png" width="250"/>
  <img src="assets/screenshots/cart.png" width="250"/>
</p>

---

## 🧠 State Management

This app uses **Provider** for state management.

### CartProvider Responsibilities
- Add product to cart
- Increase quantity
- Decrease quantity
- Remove all quantities
- Calculate total price
- Maintain unique product list
- Notify UI on state change

---

## 📦 Dependencies

Add the following dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  cached_network_image: ^3.3.1
  intl: ^0.18.1
  http: ^1.2.1

