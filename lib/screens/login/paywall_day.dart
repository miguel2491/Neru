import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PaywallDayScreen extends StatefulWidget {
  final int daysRemaining;

  const PaywallDayScreen({super.key, required this.daysRemaining});

  @override
  State<PaywallDayScreen> createState() => _PaywallDayScreenState();
}

class _PaywallDayScreenState extends State<PaywallDayScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final String _productId = "programa_mental_800";

  ProductDetails? _product;

  @override
  void initState() {
    super.initState();
    _loadProduct();

    _inAppPurchase.purchaseStream.listen(_listenToPurchase);
  }

  /// Cargar producto desde Google Play
  Future<void> _loadProduct() async {
    final response = await _inAppPurchase.queryProductDetails({_productId});

    if (response.productDetails.isNotEmpty) {
      setState(() {
        _product = response.productDetails.first;
      });
    }
  }

  /// Escuchar resultado de compra
  void _listenToPurchase(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        print("Compra exitosa");

        /// Aquí desbloqueas premium
      }

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  void _openTerms(BuildContext context) {
    print("Abrir términos");
  }

  void _openPrivacy(BuildContext context) {
    print("Abrir privacidad");
  }

  /// Iniciar compra
  void _startPurchase() {
    if (_product == null) return;

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: _product!,
    );

    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    final daysRemaining = widget.daysRemaining;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text('NERU')],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                Text(
                  "Te quedan $daysRemaining días de prueba gratuita",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                const Text(
                  "DOMINA EL JUEGO DESDE LA MENTE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 40,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE75A2A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "PROGRAMA DE\nENTRENAMIENTO\nMENTAL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 15),

                      Text(
                        "10 semanas\n"
                        "7 variables a trabajar\n"
                        "más de 50 audios\n"
                        "tiempo ilimitado\n"
                        "pago único",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),

                      SizedBox(height: 20),

                      Text(
                        "\$800 MXN",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: 280,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _startPurchase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Paga con tu cuenta Google",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                    children: [
                      TextSpan(
                        text: "Seguir con la prueba gratuita",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openTerms(context);
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
