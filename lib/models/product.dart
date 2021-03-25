class Product {
  final int id;
  final String title, description, image, price;

  Product({this.id, this.price, this.title, this.description, this.image});
}

// list of products
// for our demo
List<Product> products = [
  Product(
    id: 1,
    price: "New",
    title: "Repair",
    image: "assets/images/girlies_text_small.png",
    description:
        "The reconditioning or renewal of parts, components, and/or subsystems necessary to keep the Lift Equipment in compliance with applicable requirements and the manufacturer’s specifications.",
  ),
  Product(
    id: 4,
    price: "New",
    title: "Cleaning",
    image: "assets/images/girlies_text_small.png",
    description:
        "Bringing happiness to homes with a fresh approach to home cleaning services. We know you're busy and that you would love to swap some of your household chores for time with the kids, friends, or just an hour or two of relaxing in front of the TV, so we're empowering you to take back your free time with a simple tap of a button.",
  ),
  Product(
    id: 9,
    price: "New",
    title: "Gardening",
    image: "assets/images/girlies_text_small.png",
    description:
        "Looking for professional  landscaping and gardening services?Here we offer professional landscaping and gardening",
  ),
];
