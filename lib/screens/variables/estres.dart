import 'package:flutter/material.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/variables/actividades.dart';
import 'package:neru/services/db_helper.dart';
import 'package:neru/widgets/bottom_nav.dart';

class EstresScreen extends StatefulWidget {
  final int variable;
  final String t_icono;

  const EstresScreen({
    super.key,
    required this.variable,
    required this.t_icono,
  });
  @override
  State<EstresScreen> createState() => _EstresScreenState();
}

class _EstresScreenState extends State<EstresScreen> {
  String nameVar = '';
  String iconVar = '';
  final List<Widget> _pages = [
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Progreso", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Home", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Calendario", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Perfil", style: TextStyle(color: Colors.white)),
    ),
  ];
  final Map<String, IconData> iconMap = {
    "estres": Icons.psychology,
    "confianza": Icons.star,
    "motivacion": Icons.rocket_launch,
    "objetivo": Icons.flag,
    "control": Icons.self_improvement,
  };
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VariablesScreen()),
      );
      return; // no cambies _selectedIndex si navegas
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerfilScreen()),
      );
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadActividades();
  }

  Future<void> _loadActividades() async {
    final variableData = await DBHelper.getVariableById(widget.variable);

    if (variableData != null) {
      setState(() {
        nameVar = variableData['nombre'] ?? '';
        iconVar = variableData['icono'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('⌛⚽ ${widget.t_icono}');
    Widget content;

    switch (widget.variable) {
      case 1:
        content = _buildEstres();
        break;
      case 2:
        content = _buildAutoConfianza();
        break;
      case 3:
        content = _buildConcentracion();
        break;
      case 4:
        content = _buildObjetivo();
        break;
      case 5:
        content = _buildMotivacion();
        break;
      case 6:
        content = _buildActivacion();
        break;
      case 7:
        content = _buildAutoControl();
        break;
      default:
        content = const Center(child: Text("Variable no encontrada"));
    }
    return Scaffold(
      backgroundColor: Colors.blue,

      appBar: AppBar(
        backgroundColor: const Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: Stack(
          children: [
            // 🔹 Texto alineado a la derecha
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'NERU',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              content, // todo tu contenido dinámico

              const SizedBox(height: 32),

              /// 👇 BOTÓN AL FINAL DEL CONTENIDO
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00406a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ActividadesScreen(variable: widget.variable),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'EMPEZAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24), // espacio final
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildEstres() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.t_icono, // 👈 aquí usas la variable
                width: 32,
                height: 32,
                color: Colors.white, // opcional: para poner color blanco
              ),
              const SizedBox(width: 8),
              const Text(
                "ESTRÉS / ANSIEDAD",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        // Bloque rojo de definición
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "El estrés es una reacción cuando te sientes amenazado con inseguridad o ansiedad.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // Ejemplo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              children: [
                TextSpan(
                  text: "▶️EJEMPLO:\n",
                  style: TextStyle(
                    color: Color(0xFFFF4000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      "Antes de salir al campo sientes como tu corazón late más, presentas dolor de estómago, nauseas, dolores musculares, calambres, en el campo puedes estar más violento, sentir sensaciones de huir o retirarte, también disminuye tu concentración, influye en la toma de decisiones y hace que se presenten pensamientos confusos.",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Imagen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/variables/rodilla.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/variables/espalda.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Pregunta en bloque rojo
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "¿Cuál es el nivel de estrés óptimo?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        // Texto explicativo
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Todos sentimos estrés antes de iniciar una competencia, pero el estrés puede ayudarte a rendir al máximo, solo es cuestión de controlarlo.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // Gráfico
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            "assets/variables/grafico_estres.png",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAutoConfianza() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.t_icono, // 👈 aquí usas la variable
                width: 32,
                height: 32,
                color: Colors.white, // opcional: para poner color blanco
              ),
              const SizedBox(width: 8),
              const Text(
                "AUTOCONFIANZA",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        // Bloque rojo de definición
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          child: const Text(
            "La autoconfíanza es el grado de certeza que tienes respecto a tu habilidad para tener éxito y se forma de pasadas experiencias. Es un elemento crítico del rendimiento deportivo, la seguridad de uno mismo, confiar en hacerlo bien.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16), // margen lateral
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // 👈 distribuye el espacio
            children: [
              Expanded(
                // 👈 para que no se desborden
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/variables/auto1.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16), // espacio entre las imágenes
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/variables/auto2.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Pregunta en bloque rojo
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "¿Cuál es el nivel óptimo de confianza?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        // Texto explicativo
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Lograr un nivel óptimo en tu confianza es posible. Alcanzar tu nivel óptimo de confianza en cada entrenamiento y partido te ayudará a rendir al máximo.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // Gráfico
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset("assets/variables/auto3.png", fit: BoxFit.contain),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildConcentracion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.t_icono, // 👈 aquí usas la variable
                width: 32,
                height: 32,
                color: Colors.white, // opcional: para poner color blanco
              ),
              const SizedBox(width: 8),
              const Text(
                "CONCENTRACIÓN",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        // Bloque rojo de definición
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "La concentración es la focalización de toda tu atención en una tarea, es apartar la atención de todo lo que distrae como: público, gritos, errores, pensamientos pasados o pensamientos futuros. Todo con el fin de lograr lo que te propones.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16), // margen lateral
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // 👈 distribuye el espacio
            children: [
              Expanded(
                // 👈 para que no se desborden
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/variables/con1.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16), // espacio entre las imágenes
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/variables/con2.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Ejemplo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              children: [
                TextSpan(
                  text: "▶️▶EJEMPLO:\n",
                  style: TextStyle(
                    color: Color(0xFFFF4000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      "Cuando entras al campo con la mente enfocada y concentrada, sigues cada instrucción adaptándote a cada situación hasta alcanzar tu meta.",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Gráfico
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset("assets/variables/con3.png", fit: BoxFit.contain),
        ),
      ],
    );
  }

  Widget _buildObjetivo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.t_icono, // 👈 aquí usas la variable
                width: 32,
                height: 32,
                color: Colors.white, // opcional: para poner color blanco
              ),
              const SizedBox(width: 8),
              const Text(
                "METAS / OBJETIVOS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        // Bloque rojo de definición
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "El objetivo es el fin último al que se dirige una planeación o una acción. Cumplir los objetivos que te colocaste en entrenamientos o competencias ayudará al aumento de tu rendimiento. Tus objetivos son el apoyo a lo largo de un partido hasta el pitido final o a lo largo de la temporada.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Imagen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/variables/metas1.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/variables/metas2.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Pregunta en bloque rojo
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "¿Qué tipo de objetivos hay?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        // Texto explicativo
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Objetivos de rendimiento, objetivos de resultado, objetivos específicos, objetivos de actuación, objetivos a corto, mediano y largo plazo.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // Gráfico
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            "assets/variables/metas3.png",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMotivacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.t_icono, // 👈 aquí usas la variable
                width: 32,
                height: 32,
                color: Colors.white, // opcional: para poner color blanco
              ),
              const SizedBox(width: 8),
              const Text(
                "MOTIVACIÓN",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        // Bloque rojo de definición
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "La motivación es el deseo o necesidad que tienes para conseguir tus objetivos o metas.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Ejemplo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              children: [
                TextSpan(
                  text: "▶️EJEMPLO:\n",
                  style: TextStyle(
                    color: Color(0xFFFF4000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      "Luchas por ser el goleador del torneo, para llegar a lograrlo deberás trabajar constantemente en tu técnica, tu definición, tu confianza para anotar, todo sin dejar de sentir la emoción de lograr ese objetivo.",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Imagen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset("assets/variables/moti1.png", fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),

        // Pregunta en bloque rojo
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "¿Cuál es nivel óptimo de motivación?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),

        // Texto explicativo
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Sentir motivación en entrenamientos y partidos de forma constante es posible, dominarlo te ayudará a tener un mejor rendimiento.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Gráfico
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            "assets/variables/grafico_moti.png",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),

        // Logo
        const Text(
          "NERÜ",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF4000),
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          "App",
          style: TextStyle(fontSize: 14, color: Color(0xFFFF4000)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildActivacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.t_icono, // 👈 aquí usas la variable
                width: 32,
                height: 32,
                color: Colors.white, // opcional: para poner color blanco
              ),
              const SizedBox(width: 8),
              const Text(
                "ACTIVACIÓN MENTAL",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        // Bloque rojo de definición
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "La activación es el grado de intensidad o grado de alerta que pones a la hora de entrenar o competir.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Ejemplo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              children: [
                TextSpan(
                  text: "▶️EJEMPLO:\n",
                  style: TextStyle(
                    color: Color(0xFFFF4000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      "Cuando entras al campo y te sientes apático, desinteresado o aburrido es síntoma de subactivación (estás poco activado). Cuando entras al campo y te sientes acelerado, con sudor en las manos o ansioso es sobre activación (estás muy activado). La activación óptima es el nivel justo entre la sobre activación y la sub activación.",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Imagen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/variables/activacion.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Pregunta en bloque rojo
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "¿Cuál es la activación óptima?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),

        // Texto explicativo
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Lograr una buena activación cada que entrenes o juegues un partido es posible.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Gráfico
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            "assets/variables/grafico_rendimiento.png",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),

        // Logo
        const Text(
          "NERÜ",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF4000),
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          "App",
          style: TextStyle(fontSize: 14, color: Color(0xFFFF4000)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildAutoControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.t_icono, // 👈 aquí usas la variable
                width: 32,
                height: 32,
                color: Colors.white, // opcional: para poner color blanco
              ),
              const SizedBox(width: 8),
              const Text(
                "CONTROL EMOCIONAL",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Bloque rojo de definición
        Container(
          color: const Color(0xFFFF4000),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "El control emocional es uno de los elementos de la fortaleza mental, es la habilidad que tienes para controlar tus emociones, una pieza muy importante para llegar a dominar tu actuación en el campo y tener un mejor dominio en el terreno de juego.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16), // margen lateral
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // 👈 distribuye el espacio
            children: [
              Expanded(
                // 👈 para que no se desborden
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/variables/control_emo1.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16), // espacio entre las imágenes
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/variables/control_emo2.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Ejemplo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              children: [
                TextSpan(
                  text: "▶️EJEMPLO:\n",
                  style: TextStyle(
                    color: Color(0xFFFF4000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      "Controlar tu ira ante un gol anulado, una mala decisión tuya o una mala decisión de algún compañero.",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Imagen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/variables/control3.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Texto explicativo
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Lograr una buena activación cada que entrenes o juegues un partido es posible.",
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // Logo
        const Text(
          "NERÜ",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF4000),
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          "App",
          style: TextStyle(fontSize: 14, color: Color(0xFFFF4000)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
