import 'package:flutter/material.dart';

import 'models/material_evento.dart';
import 'repositories/material_repository.dart';
import 'utils/validadores.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CentralMateriaisApp());
}

class CentralMateriaisApp extends StatelessWidget {
  const CentralMateriaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Central de materiais',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0f766e)),
        useMaterial3: true,
      ),
      home: const MateriaisPage(),
    );
  }
}

class MateriaisPage extends StatefulWidget {
  const MateriaisPage({super.key});

  @override
  State<MateriaisPage> createState() => _MateriaisPageState();
}

class _MateriaisPageState extends State<MateriaisPage> {
  final _repository = MaterialRepository();
  List<MaterialEvento> _materiais = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarMateriais();
  }

  Future<void> _carregarMateriais() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final materiais = await _repository.listar();
      if (!mounted) return;
      setState(() => _materiais = materiais);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erro = 'Não foi possível carregar os materiais.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _abrirFormulario([MaterialEvento? material]) async {
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController(text: material?.nome ?? '');
    final categoriaController = TextEditingController(
      text: material?.categoria ?? '',
    );
    final disponivelController = TextEditingController(
      text: material?.quantidadeDisponivel.toString() ?? '',
    );
    final minimoController = TextEditingController(
      text: material?.quantidadeMinima.toString() ?? '',
    );
    String? erroNome;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, atualizarDialog) {
            return AlertDialog(
              title: Text(
                material == null ? 'Novo material' : 'Editar material',
              ),
              content: SizedBox(
                width: 420,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nomeController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(),
                          ),
                          validator: (valor) =>
                              erroNome ?? Validadores.validarNome(valor),
                          onChanged: (_) {
                            if (erroNome != null) {
                              atualizarDialog(() => erroNome = null);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: categoriaController,
                          decoration: const InputDecoration(
                            labelText: 'Categoria',
                            border: OutlineInputBorder(),
                          ),
                          validator: Validadores.validarCategoria,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: disponivelController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantidade disponível',
                            border: OutlineInputBorder(),
                          ),
                          validator: Validadores.validarQuantidade,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: minimoController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantidade mínima',
                            border: OutlineInputBorder(),
                          ),
                          validator: Validadores.validarQuantidade,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final nomeJaExiste = await _repository.existeNome(
                      nomeController.text,
                      ignorarId: material?.id,
                    );
                    if (nomeJaExiste) {
                      atualizarDialog(() {
                        erroNome = 'Já existe um material com este nome.';
                      });
                      formKey.currentState!.validate();
                      return;
                    }

                    final novoMaterial = MaterialEvento(
                      id: material?.id,
                      nome: nomeController.text.trim(),
                      categoria: categoriaController.text.trim(),
                      quantidadeDisponivel: int.parse(
                        disponivelController.text,
                      ),
                      quantidadeMinima: int.parse(minimoController.text),
                    );

                    if (material == null) {
                      await _repository.inserir(novoMaterial);
                    } else {
                      await _repository.atualizar(novoMaterial);
                    }

                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                    await _carregarMateriais();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    nomeController.dispose();
    categoriaController.dispose();
    disponivelController.dispose();
    minimoController.dispose();
  }

  Future<void> _confirmarExclusao(MaterialEvento material) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir material'),
          content: Text('Deseja excluir ${material.nome}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || material.id == null) return;
    await _repository.excluir(material.id!);
    await _carregarMateriais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de materiais'),
        centerTitle: false,
      ),
      body: RefreshIndicator(onRefresh: _carregarMateriais, child: _conteudo()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return ListView(
        children: [
          const SizedBox(height: 180),
          Center(child: Text(_erro!)),
          const SizedBox(height: 12),
          Center(
            child: FilledButton(
              onPressed: _carregarMateriais,
              child: const Text('Tentar novamente'),
            ),
          ),
        ],
      );
    }

    if (_materiais.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 180),
          Icon(Icons.inventory_2_outlined, size: 54),
          SizedBox(height: 12),
          Center(child: Text('Nenhum material cadastrado.')),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: _materiais.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final material = _materiais[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(18, 12, 8, 12),
            title: Text(material.nome),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${material.categoria}\nDisponível: ${material.quantidadeDisponivel}  •  Mínimo: ${material.quantidadeMinima}',
              ),
            ),
            isThreeLine: true,
            trailing: Wrap(
              spacing: 2,
              children: [
                IconButton(
                  tooltip: 'Editar',
                  onPressed: () => _abrirFormulario(material),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Excluir',
                  onPressed: () => _confirmarExclusao(material),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            leading: _SituacaoBadge(situacao: material.situacao),
          ),
        );
      },
    );
  }
}

class _SituacaoBadge extends StatelessWidget {
  const _SituacaoBadge({required this.situacao});

  final String situacao;

  @override
  Widget build(BuildContext context) {
    final cor = switch (situacao) {
      'Sem estoque' => Theme.of(context).colorScheme.error,
      'Estoque baixo' => Colors.orange.shade800,
      _ => Colors.green.shade700,
    };

    return Tooltip(
      message: situacao,
      child: Icon(Icons.inventory_2, color: cor),
    );
  }
}
