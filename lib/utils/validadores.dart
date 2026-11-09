class Validadores {
  static String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o nome do material.';
    }
    return null;
  }

  static String? validarCategoria(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe a categoria do material.';
    }
    return null;
  }

  static String? validarQuantidade(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe uma quantidade inteira.';
    }

    final quantidade = int.tryParse(valor);
    if (quantidade == null || quantidade < 0) {
      return 'Use um número inteiro maior ou igual a zero.';
    }
    return null;
  }
}
