import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FurrioApp());
}

const _mint = Color(0xFF74D7C4);
const _teal = Color(0xFF1F8A83);
const _dark = Color(0xFF173B3A);
const _cream = Color(0xFFFFF8F0);
const _coral = Color(0xFFFF8A7A);
const _sky = Color(0xFFE8F8FF);

const _petsKey = 'furrio.pets.v1';
const _darkKey = 'furrio.dark.v1';
const _version = '1.0.0';
const _lastUpdated = 'June 29, 2026';

class FurrioApp extends StatefulWidget {
  const FurrioApp({super.key});

  @override
  State<FurrioApp> createState() => _FurrioAppState();
}

class _FurrioAppState extends State<FurrioApp> {
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => darkMode = prefs.getBool(_darkKey) ?? false);
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
    setState(() => darkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furrio',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _teal,
        scaffoldBackgroundColor: _cream,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: _cream,
          foregroundColor: _dark,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: _mint,
      ),
      home: SplashScreen(
        darkMode: darkMode,
        onDarkModeChanged: setDarkMode,
      ),
    );
  }
}

class PetProfile {
  final String id;
  final String name;
  final String type;
  final String age;
  final String weight;
  final String notes;
  final bool favorite;
  final DateTime createdAt;

  PetProfile({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.weight,
    required this.notes,
    required this.favorite,
    required this.createdAt,
  });

  String get emoji {
    switch (type) {
      case 'Dog':
        return '🐶';
      case 'Cat':
        return '🐱';
      case 'Bird':
        return '🐦';
      case 'Rabbit':
        return '🐰';
      case 'Fish':
        return '🐟';
      default:
        return '🐾';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'age': age,
    'weight': weight,
    'notes': notes,
    'favorite': favorite,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    return PetProfile(
      id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      type: json['type'] ?? 'Dog',
      age: json['age'] ?? '',
      weight: json['weight'] ?? '',
      notes: json['notes'] ?? '',
      favorite: json['favorite'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  PetProfile copyWith({
    String? name,
    String? type,
    String? age,
    String? weight,
    String? notes,
    bool? favorite,
  }) {
    return PetProfile(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt,
    );
  }
}

const petTypes = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Fish', 'Other'];

class SplashScreen extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const SplashScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _sky,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/logo.png',
                width: 170,
                height: 170,
                errorBuilder: (_, __, ___) => Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(42),
                  ),
                  child: const Icon(Icons.pets_rounded, size: 90, color: _teal),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Furrio',
                style: TextStyle(
                  color: _dark,
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your pet's little companion.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _teal,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(
                          darkMode: darkMode,
                          onDarkModeChanged: onDarkModeChanged,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Open Furrio',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const HomeScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum PetFilter { all, favorites }

class _HomeScreenState extends State<HomeScreen> {
  List<PetProfile> pets = [];
  String search = '';
  PetFilter filter = PetFilter.all;

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  Future<void> loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_petsKey);
    if (raw == null) return;

    try {
      final decoded = jsonDecode(raw) as List;
      setState(() {
        pets = decoded
            .map((e) => PetProfile.fromJson(Map<String, dynamic>.from(e)))
            .where((p) => p.name.trim().isNotEmpty)
            .toList();
        sortPets();
      });
    } catch (_) {
      setState(() => pets = []);
    }
  }

  Future<void> savePets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _petsKey,
      jsonEncode(pets.map((e) => e.toJson()).toList()),
    );
  }

  void sortPets() {
    pets.sort((a, b) {
      if (a.favorite != b.favorite) return a.favorite ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  List<PetProfile> get visiblePets {
    final q = search.toLowerCase();
    var list = pets.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(q) || p.type.toLowerCase().contains(q);
      final matchesFilter = filter == PetFilter.all || p.favorite;
      return matchesSearch && matchesFilter;
    }).toList();
    list.sort((a, b) {
      if (a.favorite != b.favorite) return a.favorite ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return list;
  }

  Future<void> openEditor([PetProfile? pet]) async {
    final result = await Navigator.push<PetProfile>(
      context,
      MaterialPageRoute(builder: (_) => PetEditorScreen(pet: pet)),
    );

    if (result == null) return;

    setState(() {
      final index = pets.indexWhere((p) => p.id == result.id);
      if (index == -1) {
        pets.add(result);
      } else {
        pets[index] = result;
      }
      sortPets();
    });
    savePets();
  }

  Future<void> deletePet(PetProfile pet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete pet?'),
        content: Text('Remove ${pet.name} from Furrio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final index = pets.indexWhere((p) => p.id == pet.id);
    setState(() => pets.removeWhere((p) => p.id == pet.id));
    await savePets();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pet.name} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              pets.insert(index < 0 ? 0 : index, pet);
              sortPets();
            });
            savePets();
          },
        ),
      ),
    );
  }

  Future<void> toggleFavorite(PetProfile pet) async {
    setState(() {
      final index = pets.indexWhere((p) => p.id == pet.id);
      pets[index] = pet.copyWith(favorite: !pet.favorite);
      sortPets();
    });
    savePets();
  }

  @override
  Widget build(BuildContext context) {
    final visible = visiblePets;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        onPressed: () => openEditor(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Pet'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 54,
                      height: 54,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.pets_rounded,
                        size: 46,
                        color: _teal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Furrio',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: _dark,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Settings',
                      icon: const Icon(Icons.settings_rounded),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(
                            darkMode: widget.darkMode,
                            onDarkModeChanged: widget.onDarkModeChanged,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: _teal,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _HeaderStat(
                          value: pets.length.toString(),
                          label: 'Pets',
                        ),
                      ),
                      Expanded(
                        child: _HeaderStat(
                          value: pets.where((p) => p.favorite).length.toString(),
                          label: 'Favorites',
                        ),
                      ),
                      Expanded(
                        child: _HeaderStat(
                          value: petTypes
                              .where((type) => pets.any((p) => p.type == type))
                              .length
                              .toString(),
                          label: 'Types',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => search = v),
                        decoration: InputDecoration(
                          hintText: 'Search pets...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: search.isEmpty
                              ? null
                              : IconButton(
                            onPressed: () => setState(() => search = ''),
                            icon: const Icon(Icons.close_rounded),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      selected: filter == PetFilter.favorites,
                      label: const Text('Favorites'),
                      avatar: const Icon(Icons.favorite_rounded, size: 18),
                      onSelected: (selected) {
                        setState(() {
                          filter = selected ? PetFilter.favorites : PetFilter.all;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (visible.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyPetsState(onAdd: () => openEditor()),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 96),
                sliver: SliverGrid.builder(
                  itemCount: visible.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .68,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (_, index) {
                    final pet = visible[index];
                    return PetCard(
                      pet: pet,
                      onTap: () => openEditor(pet),
                      onDelete: () => deletePet(pet),
                      onFavorite: () => toggleFavorite(pet),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeaderStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(.80),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class PetCard extends StatelessWidget {
  final PetProfile pet;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;

  const PetCard({
    super.key,
    required this.pet,
    required this.onTap,
    required this.onDelete,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${pet.name}, ${pet.type}, age ${pet.age}, weight ${pet.weight}',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: _mint.withOpacity(.35), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: _teal.withOpacity(.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onFavorite,
                    child: Icon(
                      pet.favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _coral,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(Icons.close_rounded, color: _dark),
                  ),
                ],
              ),
           //   const Spacer(),
              Text(
                pet.emoji,
                style: const TextStyle(fontSize: 54),
              ),
              const SizedBox(height: 5),
              Text(
                pet.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _dark,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                decoration: BoxDecoration(
                  color: _sky,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  pet.type,
                  style: const TextStyle(
                    color: _teal,
                    fontWeight: FontWeight.w900,
                    fontSize: 9,
                  ),
                ),
              ),
              const Spacer(),
              _MiniLine(title: 'Age', value: pet.age.isEmpty ? '-' : pet.age),
              const SizedBox(height: 2),
              _MiniLine(
                title: 'Weight',
                value: pet.weight.isEmpty ? '-' : pet.weight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniLine extends StatelessWidget {
  final String title;
  final String value;

  const _MiniLine({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _dark,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class EmptyPetsState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyPetsState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(34),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            width: 110,
            height: 110,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.pets_rounded, size: 90, color: _teal),
          ),
          const SizedBox(height: 20),
          const Text(
            'No pets yet',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first pet profile to keep basic care details in one simple place.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add First Pet'),
          ),
        ],
      ),
    );
  }
}

class PetEditorScreen extends StatefulWidget {
  final PetProfile? pet;

  const PetEditorScreen({super.key, this.pet});

  @override
  State<PetEditorScreen> createState() => _PetEditorScreenState();
}

class _PetEditorScreenState extends State<PetEditorScreen> {
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController weightController;
  late final TextEditingController notesController;

  String type = 'Dog';
  bool favorite = false;

  @override
  void initState() {
    super.initState();
    final pet = widget.pet;
    nameController = TextEditingController(text: pet?.name ?? '');
    ageController = TextEditingController(text: pet?.age ?? '');
    weightController = TextEditingController(text: pet?.weight ?? '');
    notesController = TextEditingController(text: pet?.notes ?? '');
    type = pet?.type ?? 'Dog';
    favorite = pet?.favorite ?? false;
  }

  void save() {
    final name = nameController.text.trim();
    final age = ageController.text.trim();
    final weight = weightController.text.trim();
    final notes = notesController.text.trim();

    if (name.isEmpty || name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid pet name')),
      );
      return;
    }

    Navigator.pop(
      context,
      PetProfile(
        id: widget.pet?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        type: type,
        age: age,
        weight: weight,
        notes: notes,
        favorite: favorite,
        createdAt: widget.pet?.createdAt ?? DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmoji = PetProfile(
      id: '',
      name: '',
      type: type,
      age: '',
      weight: '',
      notes: '',
      favorite: false,
      createdAt: DateTime.now(),
    ).emoji;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Add Pet' : 'Edit Pet'),
        actions: [
          IconButton(
            tooltip: 'Favorite',
            onPressed: () => setState(() => favorite = !favorite),
            icon: Icon(
              favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _coral,
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: _sky,
                shape: BoxShape.circle,
                border: Border.all(color: _mint, width: 4),
              ),
              child: Center(
                child: Text(currentEmoji, style: const TextStyle(fontSize: 56)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Pet name',
              prefixIcon: Icon(Icons.badge_rounded),
              filled: true,
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: type,
            decoration: const InputDecoration(
              labelText: 'Pet type',
              prefixIcon: Icon(Icons.pets_rounded),
              filled: true,
            ),
            items: petTypes
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => type = v ?? 'Other'),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    hintText: '3 years',
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                    hintText: '8 kg',
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: notesController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Food, habits, vet notes, or special care details...',
              prefixIcon: Icon(Icons.notes_rounded),
              filled: true,
            ),
          ),
          const SizedBox(height: 26),
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: save,
              child: const Text('Save Pet'),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _sky,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 76,
                  height: 76,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.pets_rounded, size: 64, color: _teal),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Furrio\nYour pet's little companion.",
                    style: TextStyle(
                      color: _dark,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SwitchListTile(
            value: darkMode,
            onChanged: onDarkModeChanged,
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode_rounded),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_rounded),
            title: Text('App Version'),
            subtitle: Text(_version),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_rounded),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LegalScreen(
                  title: 'Privacy Policy',
                  sections: privacySections,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article_rounded),
            title: const Text('Terms & Conditions'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LegalScreen(
                  title: 'Terms & Conditions',
                  sections: termsSections,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegalScreen extends StatelessWidget {
  final String title;
  final List<LegalSection> sections;

  const LegalScreen({
    super.key,
    required this.title,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Furrio $title',
            style: const TextStyle(
              color: _dark,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text('Last Updated: $_lastUpdated'),
          const SizedBox(height: 18),
          ...sections.map(
                (section) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      color: _dark,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(section.body, style: const TextStyle(height: 1.55)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegalSection {
  final String title;
  final String body;

  const LegalSection(this.title, this.body);
}

const privacySections = [
  LegalSection(
    'Introduction',
    'Furrio is a simple pet profile app designed to help users keep basic pet care details in one place. This Privacy Policy explains how Furrio handles information in a clear and practical way.',
  ),
  LegalSection(
    'Information We Store',
    'Furrio stores only the information you choose to enter, such as pet names, pet type, age, weight, favorite status, notes, and app settings like dark mode.',
  ),
  LegalSection(
    'Local Device Storage',
    'All Furrio data is stored locally on your device using local storage. Furrio does not upload, sync, or transfer your pet profiles to any server.',
  ),
  LegalSection(
    'No Account Required',
    'Furrio does not require login, account creation, email address, username, password, or profile registration.',
  ),
  LegalSection(
    'No Personal Data Collection',
    'Furrio does not intentionally collect personal information such as your name, location, contacts, photos, camera data, microphone data, payment information, or device identifiers.',
  ),
  LegalSection(
    'No Analytics or Ads',
    'Furrio does not use analytics SDKs, advertising networks, behavioral tracking tools, ad identifiers, or marketing trackers.',
  ),
  LegalSection(
    'No Third-Party Sharing',
    'Furrio does not sell, rent, share, or disclose your pet profile data to third parties.',
  ),
  LegalSection(
    'Data Security',
    'Because data stays on your device, it is protected by your device security settings. You are responsible for keeping your device secure.',
  ),
  LegalSection(
    'User Control and Deletion',
    'You can add, edit, favorite, and delete pet profiles at any time. You can also clear app data or uninstall Furrio to remove locally stored information.',
  ),
  LegalSection(
    'Children’s Privacy',
    'Furrio is a general pet organization app and is not specifically directed to children. The app does not knowingly collect children’s personal information.',
  ),
  LegalSection(
    'Pet Care Disclaimer',
    'Furrio is not veterinary, medical, health, emergency, or professional animal care advice. Always consult a qualified veterinarian for health concerns or urgent pet care needs.',
  ),
  LegalSection(
    'Changes to Policy',
    'This Privacy Policy may be updated if Furrio changes or improves. Any updated version should continue to describe the app accurately.',
  ),
  LegalSection(
    'Contact',
    'For questions, use the developer contact listed on the app store page or official project website.',
  ),
];

const termsSections = [
  LegalSection(
    'Acceptance of Terms',
    'By using Furrio, you agree to these Terms & Conditions. If you do not agree, do not use the app.',
  ),
  LegalSection(
    'Description of App',
    'Furrio helps users create simple pet profiles with basic details such as name, type, age, weight, notes, and favorite status.',
  ),
  LegalSection(
    'User Responsibility',
    'You are responsible for the information you enter into Furrio and for keeping your device secure.',
  ),
  LegalSection(
    'Not Veterinary Advice',
    'Furrio does not provide veterinary advice, diagnosis, treatment, emergency guidance, or professional animal health recommendations.',
  ),
  LegalSection(
    'Local Data Only',
    'Furrio stores data locally and does not provide cloud sync, online backup, or account recovery.',
  ),
  LegalSection(
    'Accuracy Disclaimer',
    'Furrio displays pet information based on what you enter. The app cannot verify pet age, weight, notes, or care details.',
  ),
  LegalSection(
    'Limitation of Liability',
    'Furrio is provided as-is. The developer is not responsible for lost local data, incorrect pet details, missed care actions, or indirect losses.',
  ),
  LegalSection(
    'Acceptable Use',
    'Use Furrio for lawful personal pet organization only. Do not misuse, copy, resell, or interfere with the app.',
  ),
  LegalSection(
    'Updates',
    'Future updates may improve features, design, compatibility, or policy content. Continued use means you accept updated terms.',
  ),
  LegalSection(
    'Termination',
    'You may stop using Furrio at any time by deleting the app. There is no account to close.',
  ),
  LegalSection(
    'Governing Terms',
    'If any part of these terms is unenforceable, the remaining sections should continue to apply as allowed by law.',
  ),
  LegalSection(
    'Contact',
    'For questions, use the developer contact listed on the app store page or official project website.',
  ),
];