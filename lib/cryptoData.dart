class Crypto {
  String id;
  String rank;
  String symbol;
  String name;
  double priceUsd;
  double changePercent24Hr;

  Crypto(
    this.id,
    this.rank,
    this.symbol,
    this.name,
    this.priceUsd,
    this.changePercent24Hr,
  );

  factory Crypto.dataFromJson(Map<String, dynamic> jsonData) {
    return Crypto(
      jsonData['id'],
      jsonData['rank'],
      jsonData['symbol'],
      jsonData['name'],
      double.parse(jsonData['priceUsd']),
      double.parse(jsonData['changePercent24Hr']),
    );
  }
}
