class Images {
  static final creditCards = <CreditCard>[
    CreditCard(
      urlFront: 'Images/i1.jpg',
    ),
    CreditCard(
      urlFront: 'Images/i2.jpg',
    ),
    CreditCard(
      urlFront: 'Images/i3.jpg',
    ),CreditCard(
      urlFront: 'Images/i4.jpg',
    ),
  ];

  static final frontCreditCards =
  Images.creditCards.map((card) => card.urlFront).toList();
}

class CreditCard {
  final String urlFront;

  const CreditCard({
    this.urlFront,
  });
}