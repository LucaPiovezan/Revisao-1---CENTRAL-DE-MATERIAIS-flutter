class MaterialEvento {
  const MaterialEvento({
    this.id,
    required this.nome,
    required this.categoria,
    required this.quantidadeDisponivel,
    required this.quantidadeMinima,
  });

  final int? id;
  final String nome;
  final String categoria;
  final int quantidadeDisponivel;
  final int quantidadeMinima;

  String get situacao {
    if (quantidadeDisponivel == 0) return 'Sem estoque';
    if (quantidadeDisponivel < quantidadeMinima) return 'Estoque baixo';
    return 'Estoque adequado';
  }

  Map<String, Object> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
      'quantidade_disponivel': quantidadeDisponivel,
      'quantidade_minima': quantidadeMinima,
    };
  }

  factory MaterialEvento.fromMap(Map<String, Object?> map) {
    return MaterialEvento(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      categoria: map['categoria'] as String,
      quantidadeDisponivel: map['quantidade_disponivel'] as int,
      quantidadeMinima: map['quantidade_minima'] as int,
    );
  }
}
