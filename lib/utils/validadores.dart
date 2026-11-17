
class Validadores {
  static String? textoObrigatorio(String? valor) {
    // TODO 1: Rejeita textos vazios ou somente com espaços.
    if (valor == null || valor.trim().isEmpty) {
      return 'O campo é obrigatório.';
    }

    return null;
  }

  static String? quantidade(String? valor) {
    // TODO 2: Aceita somente inteiros maiores ou iguais a zero.
    if (valor == null || valor.trim().isEmpty) {
      return 'O campo é obrigatório.';
    }

    final texto = valor.trim();

    if (!RegExp(r'^[0-9]+$').hasMatch(texto) ||
        int.tryParse(texto) == null) {
      return 'Informe um número inteiro maior ou igual a zero.';
    }

    return null;
  }
}
