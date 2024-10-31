// lib/backend/Categories.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Category {
  final String name;
  final Icon icon;
  final Color color;
  List<SubCategory>? subCategories;

  Category({
    required this.name,
    required this.icon,
    required this.color,
    this.subCategories,
  });
}

class SubCategory {
  final String name;
  final Icon icon;

  SubCategory({required this.name, required this.icon});
}

List<Category> categories = [
  Category(name: "Food & Drinks", icon: const Icon(Icons.fastfood), color: const Color(0xfff43c06), subCategories: [
    SubCategory(name: "Restaurants", icon: const Icon(Icons.restaurant)),
    SubCategory(name: "Fast Food", icon: const Icon(Icons.fastfood)),
    SubCategory(name: "Groceries", icon: const Icon(Icons.shopping_cart)),
    SubCategory(name: "Cafes", icon: const Icon(Icons.local_cafe)),
    SubCategory(name: "Bars", icon: const Icon(Icons.local_bar)),
  ]),
  Category(name: "Shopping", icon: const Icon(Icons.shopping_cart), color: const Color(0xff4fbbed), subCategories: [
    SubCategory(name: "Clothing , shoes", icon: const Icon(Icons.shopping_bag)),
    SubCategory(name: "Electronics", icon: const Icon(Icons.phone_android)),
    SubCategory(name: "Books", icon: const Icon(Icons.menu_book)),
    SubCategory(name: "Home, garden", icon: const Icon(Icons.home)),
    SubCategory(name: "Jewelry, accessories", icon: const Icon(Icons.watch)),
    SubCategory(name: "Health, beauty", icon: const Icon(Icons.healing)),
    SubCategory(name: "Kids", icon: const Icon(Icons.child_friendly)),
    SubCategory(name: "Pets", icon: const Icon(Icons.pets)),
    SubCategory(name: "Gifts", icon: const Icon(Icons.card_giftcard)),
    SubCategory(name: "Stationery", icon: const Icon(Icons.book)),
    SubCategory(name: "Free time", icon: const Icon(Icons.sports_esports)),
    SubCategory(name: "Drugstore, chemist", icon: const Icon(Icons.local_pharmacy)),
  ]),
  Category(name: "Housing", icon: const Icon(Icons.home), color: const Color(0xfff49c29), subCategories: [
    SubCategory(name: "Rent", icon: const Icon(Icons.home)),
    SubCategory(name: "Mortgage", icon: const Icon(Icons.account_balance)),
    SubCategory(name: "Energy, utilities", icon: const Icon(Icons.flash_on)),
    SubCategory(name: "Services", icon: const Icon(Icons.build)),
    SubCategory(name: "Maintenance, repairs", icon: const Icon(Icons.handyman)),
    SubCategory(name: "Property insurance", icon: const Icon(Icons.security)),
  ]),
  Category(name: "Transportation", icon: const Icon(Icons.directions_bus), color: const Color(0xfff47029), subCategories: [
    SubCategory(name: "Public transport", icon: const Icon(Icons.directions_bus)),
    SubCategory(name: "Taxi", icon: const Icon(Icons.local_taxi)),
    SubCategory(name: "Long distance", icon: const Icon(Icons.train)),
    SubCategory(name: "Business trips", icon: const Icon(Icons.business_center)),
  ]),
  Category(name: "Vehicle", icon: const Icon(Icons.directions_car), color: const Color(0xfff43f7d), subCategories: [
    SubCategory(name: "Fuel", icon: const Icon(Icons.local_gas_station)),
    SubCategory(name: "Parking", icon: const Icon(Icons.local_parking)),
    SubCategory(name: "Vehicle maintenance", icon: const Icon(Icons.build)),
    SubCategory(name: "Rentals", icon: const Icon(Icons.car_rental)),
    SubCategory(name: "Vehicle insurance", icon: const Icon(Icons.security)),
    SubCategory(name: "Leasing", icon: const Icon(Icons.car_rental)),
  ]),
  Category(name: "Life & Entertainment", icon: const Icon(Icons.movie), color: const Color(0xff61d41e)),
  Category(name: "Communication, PC", icon: const Icon(Icons.computer), color: const Color(0xff516af3), subCategories: [
    SubCategory(name: "Phone, cell phone", icon: const Icon(Icons.phone)),
    SubCategory(name: "Internet", icon: const Icon(Icons.wifi)),
    SubCategory(name: "Software, apps, games", icon: const Icon(Icons.games)),
    SubCategory(name: "Postal services", icon: const Icon(Icons.local_post_office)),
  ]),
  Category(name: "Financial expenses", icon: const Icon(Icons.account_balance_wallet), color: const Color(0xff0fb89f), subCategories: [
    SubCategory(name: "Taxes", icon: const Icon(Icons.attach_money)),
    SubCategory(name: "Insurances", icon: const Icon(Icons.security)),
    SubCategory(name: "Loan, interests", icon: const Icon(Icons.account_balance)),
    SubCategory(name: "Fines", icon: const Icon(Icons.gavel)),
    SubCategory(name: "Advisory", icon: const Icon(Icons.person)),
    SubCategory(name: "Charges, Fees", icon: const Icon(Icons.money)),
    SubCategory(name: "Child Support", icon: const Icon(Icons.child_care)),
  ]),
  Category(name: "Investments", icon: const Icon(Icons.trending_up), color: const Color(0xffa405f5), subCategories: [
    SubCategory(name: "Realty", icon: const Icon(Icons.home)),
    SubCategory(name: "Vehicles, chattels", icon: const Icon(Icons.directions_car)),
    SubCategory(name: "mili", icon: const Icon(Icons.military_tech)),
    SubCategory(name: "Financial investments", icon: const Icon(Icons.attach_money)),
    SubCategory(name: "Savings", icon: const Icon(Icons.savings)),
    SubCategory(name: "Collections", icon: const Icon(Icons.collections)),
  ]),
  Category(name: "Income", icon: const Icon(Icons.attach_money), color: const Color(0xfff1b82e), subCategories: [
    SubCategory(name: "Wage, invoices", icon: const Icon(Icons.receipt)),
    SubCategory(name: "Interests, dividends", icon: const Icon(Icons.attach_money)),
    SubCategory(name: "Sale", icon: const Icon(Icons.sell)),
    SubCategory(name: "Rental income", icon: const Icon(Icons.home)),
    SubCategory(name: "Dues & grants", icon: const Icon(Icons.card_giftcard)),
    SubCategory(name: "Lending, renting", icon: const Icon(Icons.handshake)),
    SubCategory(name: "Checks, coupons", icon: const Icon(Icons.check)),
    SubCategory(name: "Lottery, gambling", icon: const Icon(Icons.casino)),
    SubCategory(name: "Refunds (tax, purchase)", icon: const Icon(Icons.money_off)),
    SubCategory(name: "Child Support", icon: const Icon(Icons.child_care)),
    SubCategory(name: "Gifts", icon: const Icon(Icons.card_giftcard)),
  ]),
  Category(name: "Others", icon: const Icon(Icons.menu_sharp), color: const Color(0xff989898), subCategories: [
    SubCategory(name: "Missing", icon: const Icon(Icons.help)),
  ]),
];