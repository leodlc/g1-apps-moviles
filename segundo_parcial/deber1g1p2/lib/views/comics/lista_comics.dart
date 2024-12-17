import 'package:flutter/material.dart';
import '/../controllers/comics_controller.dart';
import '/../models/comics_model.dart';
import 'info_comic.dart';
import '../creacion_formulario.dart';

class ListaComics extends StatefulWidget {
  const ListaComics({Key? key}) : super(key: key);

  @override
  _ListaComicsState createState() => _ListaComicsState();
}

class _ListaComicsState extends State<ListaComics> {
  final ComicController _controller = ComicController();
  final ScrollController _scrollController = ScrollController();
  List<Comic> _comics = [];
  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchComics();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _fetchComics();
      }
    });
  }

  Future<void> _fetchComics() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final comics = await _controller.fetchComics(offset: _offset);
      setState(() {
        if (comics.isNotEmpty) {
          _comics.addAll(comics);
          _offset += comics.length;
        } else {
          _hasMore = false; // No hay más cómics
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CÓMICS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF151313),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF852221),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _comics.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Botón central superior
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Acción al presionar el botón
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CreacionFormulario(tipo: 'comics'),
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF852221),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Cuadrícula de cómics
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _comics.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _comics.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final comic = _comics[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoComic(comic: comic),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xFF1E1C1C),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8)),
                                child: Image.network(
                                  comic.imageUrl,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  comic.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      backgroundColor: const Color(0xFF151313),
    );
  }
}
