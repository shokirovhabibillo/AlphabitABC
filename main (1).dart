import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mushukcha Alifbo',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueGrey),
        home: const AlphabetPage(),
      );
}

/// Harf ma'lumoti: chiziqlar (x,y juftliklari), mushuk boshi va dum nuqtasi.
/// Koordinatalar: x 0..4, y 0..6 (katakli daftar kabi).
class _L {
  final List<List<double>> s;
  final double hx, hy, tx, ty;
  const _L(this.s, this.hx, this.hy, this.tx, this.ty);
}

const List<_L> _letters = [
  // A
  _L([[0, 6, 2, 0, 4, 6], [1, 3.5, 3, 3.5]], 2, 0, 4, 6),
  // B
  _L([[0, 0, 0, 6, 3, 6, 4, 5, 4, 4, 3, 3, 0, 3], [0, 0, 3, 0, 4, 1, 4, 2, 3, 3]], 0, 0, 3, 6),
  // C
  _L([[4, 1, 3, 0, 1, 0, 0, 1, 0, 5, 1, 6, 3, 6, 4, 5]], 2, 0, 4, 5),
  // D
  _L([[0, 0, 0, 6, 2, 6, 4, 4, 4, 2, 2, 0, 0, 0]], 0, 0, 2, 6),
  // E
  _L([[4, 0, 0, 0, 0, 6, 4, 6], [0, 3, 3, 3]], 0, 0, 4, 6),
  // F
  _L([[4, 0, 0, 0, 0, 6], [0, 3, 3, 3]], 0, 0, 0, 6),
  // G
  _L([[4, 1, 3, 0, 1, 0, 0, 1, 0, 5, 1, 6, 3, 6, 4, 5, 4, 3, 2, 3]], 2, 0, 2, 3),
  // H
  _L([[0, 0, 0, 6], [4, 0, 4, 6], [0, 3, 4, 3]], 0, 0, 4, 6),
  // I
  _L([[1, 0, 3, 0], [2, 0, 2, 6], [1, 6, 3, 6]], 2, 0, 3, 6),
  // J
  _L([[4, 0, 4, 5, 3, 6, 1, 6, 0, 5]], 4, 0, 0, 5),
  // K
  _L([[0, 0, 0, 6], [4, 0, 0, 3, 4, 6]], 0, 0, 4, 6),
  // L
  _L([[0, 0, 0, 6, 4, 6]], 0, 0, 4, 6),
  // M
  _L([[0, 6, 0, 0, 2, 3, 4, 0, 4, 6]], 0, 0, 4, 6),
  // N
  _L([[0, 6, 0, 0, 4, 6, 4, 0]], 0, 0, 0, 6),
  // O
  _L([[1, 0, 3, 0, 4, 1, 4, 5, 3, 6, 1, 6, 0, 5, 0, 1, 1, 0]], 2, 0, 3, 6),
  // P
  _L([[0, 6, 0, 0, 3, 0, 4, 1, 4, 2, 3, 3, 0, 3]], 0, 0, 0, 6),
  // Q
  _L([[1, 0, 3, 0, 4, 1, 4, 5, 3, 6, 1, 6, 0, 5, 0, 1, 1, 0], [2.5, 4.5, 4, 6]], 2, 0, 4, 6),
  // R
  _L([[0, 6, 0, 0, 3, 0, 4, 1, 4, 2, 3, 3, 0, 3], [1.5, 3, 4, 6]], 0, 0, 4, 6),
  // S
  _L([[4, 1, 3, 0, 1, 0, 0, 1, 0, 2, 1, 3, 3, 3, 4, 4, 4, 5, 3, 6, 1, 6, 0, 5]], 2, 0, 0, 5),
  // T
  _L([[0, 0, 4, 0], [2, 0, 2, 6]], 2, 0, 2, 6),
  // U
  _L([[0, 0, 0, 5, 1, 6, 3, 6, 4, 5, 4, 0]], 0, 0, 3, 6),
  // V
  _L([[0, 0, 2, 6, 4, 0]], 0, 0, 4, 0),
  // W
  _L([[0, 0, 1, 6, 2, 2, 3, 6, 4, 0]], 0, 0, 4, 0),
  // X
  _L([[0, 0, 4, 6], [4, 0, 0, 6]], 0, 0, 4, 6),
  // Y
  _L([[0, 0, 2, 3, 4, 0], [2, 3, 2, 6]], 0, 0, 2, 6),
  // Z
  _L([[0, 0, 4, 0, 0, 6, 4, 6]], 0, 0, 4, 6),
];

/// Bosilganda to'ldirish rangi shu ranglardan biriga o'tib, qaytadi.
const List<Color> _palette = [
  Color(0xFFFF9800),
  Color(0xFF42A5F5),
  Color(0xFF66BB6A),
  Color(0xFFEC407A),
  Color(0xFFAB47BC),
  Color(0xFFFFCA28),
];

class AlphabetPage extends StatelessWidget {
  const AlphabetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E6D6),
      appBar: AppBar(
        title: const Text('Mushukcha Alifbo'),
        backgroundColor: const Color(0xFFF1E6D6),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.6,
        ),
        itemCount: _letters.length,
        itemBuilder: (context, i) => CatTile(index: i),
      ),
    );
  }
}

class CatTile extends StatefulWidget {
  final int index;
  const CatTile({super.key, required this.index});

  @override
  State<CatTile> createState() => _CatTileState();
}

class _CatTileState extends State<CatTile> with TickerProviderStateMixin {
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );
  late final AnimationController _tap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  @override
  void initState() {
    super.initState();
    // Har bir harf boshqacha fazada harakatlanadi
    _idle.value = (widget.index * 0.137) % 1.0;
    _idle.repeat();
  }

  @override
  void dispose() {
    _idle.dispose();
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _palette[widget.index % _palette.length];
    return GestureDetector(
      onTap: () => _tap.forward(from: 0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB0BEC5)),
        ),
        child: CustomPaint(
          painter: GridPainter(),
          child: AnimatedBuilder(
            animation: Listenable.merge([_idle, _tap]),
            builder: (context, _) => CustomPaint(
              painter: CatLetterPainter(
                _letters[widget.index],
                _idle.value,
                _tap.value,
                color,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Katakli daftar foni
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFCFE3F3)
      ..strokeWidth = 0.8;
    const step = 12.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CatLetterPainter extends CustomPainter {
  final _L l;
  final double idle; // 0..1 doimiy aylanuvchi
  final double tap; // 0..1 bosilganda
  final Color color;

  CatLetterPainter(this.l, this.idle, this.tap, this.color);

  static const Color ink = Color(0xFF263238);
  static const Color pale = Color(0xFFD6E8F5);

  @override
  void paint(Canvas canvas, Size size) {
    final u = math.min(size.width / 5.8, size.height / 10);
    final ox = (size.width - 4 * u) / 2;
    final oy = (size.height - 10 * u) / 2 + 3 * u;

    final jump = -math.sin(math.pi * tap) * u * 0.9;
    final bob = math.sin(idle * 2 * math.pi) * u * 0.06;

    // Bosilganda to'ldirish rangi vaqtincha o'zgaradi
    final flash = math.sin(math.pi * tap);
    final fill = Color.lerp(pale, color, flash * 0.9)!;

    final line = u * 0.07;
    final bar = u * 0.34;
    final tailW = u * 0.2;

    Paint outerP(double w) => Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = w + 2 * line;
    Paint innerP(double w) => Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = w;

    canvas.save();
    canvas.translate(ox, oy + jump + bob);

    Offset pt(double x, double y) => Offset(x * u, y * u);

    // Harf chiziqlari
    final paths = <Path>[];
    for (final s in l.s) {
      final path = Path()..moveTo(s[0] * u, s[1] * u);
      for (int i = 2; i < s.length; i += 2) {
        path.lineTo(s[i] * u, s[i + 1] * u);
      }
      if (s[0] == s[s.length - 2] && s[1] == s[s.length - 1]) {
        path.close();
      }
      paths.add(path);
    }

    // Dum (burchakli, zigzag)
    final tp = pt(l.tx, l.ty);
    final a1 = -math.pi / 4 +
        math.sin(idle * 4 * math.pi) * 0.35 +
        math.sin(tap * math.pi * 8) * 0.7 * (1 - tap);
    final a2 = a1 - 0.9 - math.sin(idle * 4 * math.pi + 1) * 0.3;
    final dx = l.tx < 2 ? -1.0 : 1.0;
    final p1 = tp + Offset(math.cos(a1) * dx, math.sin(a1)) * (u * 0.8);
    final p2 = p1 + Offset(math.cos(a2) * dx, math.sin(a2)) * (u * 0.7);
    final tailPath = Path()
      ..moveTo(tp.dx, tp.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);

    // Chizish tartibi: avval hamma konturlar, keyin hamma ichki to'ldirishlar
    canvas.drawPath(tailPath, outerP(tailW));
    for (final p in paths) {
      canvas.drawPath(p, outerP(bar));
    }
    for (final p in paths) {
      canvas.drawPath(p, innerP(bar));
    }
    canvas.drawPath(tailPath, innerP(tailW));

    // Panjalar: pastki chiziqqa tegib turgan uchlarda kichik uchburchak
    final fillPaint = Paint()..color = fill;
    final edgePaint = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = line * 1.2;
    for (final s in l.s) {
      for (final i in [0, s.length - 2]) {
        if (s[i + 1] >= 5.99) {
          final x = s[i] * u;
          final y = s[i + 1] * u;
          final paw = Path()
            ..moveTo(x - 0.5 * u, y + 0.25 * u)
            ..lineTo(x + 0.5 * u, y + 0.25 * u)
            ..lineTo(x, y - 0.45 * u)
            ..close();
          canvas.drawPath(paw, fillPaint);
          canvas.drawPath(paw, edgePaint);
        }
      }
    }

    // Mushuk boshi: uchli quloqlar, o'tkir iyak
    final r = u * 0.5;
    final c = pt(l.hx, l.hy) + Offset(0, -1.0 * r);

    final twitch =
        math.pow(math.max(0.0, math.sin(idle * 4 * math.pi + 1)), 12)
                .toDouble() *
            0.4;
    for (final side in [-1.0, 1.0]) {
      final angle = side *
          (math.sin(idle * 2 * math.pi) * 0.06 +
              twitch +
              math.sin(tap * math.pi * 4) * 0.35 * (1 - tap));
      canvas.save();
      canvas.translate(c.dx + side * 0.55 * r, c.dy - 0.5 * r);
      canvas.rotate(angle);
      final ear = Path()
        ..moveTo(side * 0.45 * r, 0)
        ..lineTo(side * 0.35 * r, -1.2 * r)
        ..lineTo(side * -0.45 * r, 0)
        ..close();
      canvas.drawPath(ear, fillPaint);
      canvas.drawPath(ear, edgePaint);
      canvas.restore();
    }

    final head = Path()
      ..moveTo(c.dx - r, c.dy - 0.5 * r)
      ..lineTo(c.dx + r, c.dy - 0.5 * r)
      ..lineTo(c.dx + r, c.dy + 0.1 * r)
      ..lineTo(c.dx, c.dy + 1.0 * r)
      ..lineTo(c.dx - r, c.dy + 0.1 * r)
      ..close();
    canvas.drawPath(head, fillPaint);
    canvas.drawPath(head, edgePaint);

    // Ko'zlar (miltillaydi)
    final blink = (idle > 0.9 && idle < 0.95) ? 0.1 : 1.0;
    for (final side in [-1.0, 1.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: c + Offset(side * 0.4 * r, -0.05 * r),
          width: r * 0.24,
          height: r * 0.4 * blink,
        ),
        Paint()..color = ink,
      );
    }
    // Burun
    canvas.drawCircle(
      c + Offset(0, 0.5 * r),
      r * 0.09,
      Paint()..color = ink,
    );

    // "Miyov!" yozuvi
    if (tap > 0 && tap < 1) {
      final tpnt = TextPainter(
        text: TextSpan(
          text: 'Miyov!',
          style: TextStyle(
            fontSize: u * 0.7,
            fontWeight: FontWeight.bold,
            color: ink.withAlpha((255 * (1 - tap)).round()),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tpnt.paint(
        canvas,
        c + Offset(-tpnt.width / 2, -r * 3.0 - tap * u * 0.5 - tpnt.height),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CatLetterPainter old) => true;
}
