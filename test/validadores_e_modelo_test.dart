import 'package:central_materiais/models/material_evento.dart';
import 'package:central_materiais/utils/validadores.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validadores', () {
    test('rejeita texto vazio ou somente com espaços', () {
      expect(Validadores.validarNome('   '), isNotNull);
      expect(Validadores.validarCategoria(''), isNotNull);
    });

    test('aceita somente quantidades inteiras não negativas', () {
      expect(Validadores.validarQuantidade('0'), isNull);
      expect(Validadores.validarQuantidade('12'), isNull);
      expect(Validadores.validarQuantidade(''), isNotNull);
      expect(Validadores.validarQuantidade('-1'), isNotNull);
      expect(Validadores.validarQuantidade('2.5'), isNotNull);
      expect(Validadores.validarQuantidade('dez'), isNotNull);
    });
  });

  group('Situação do estoque', () {
    test('prioriza sem estoque quando disponível e mínimo são zero', () {
      final material = MaterialEvento(
        nome: 'Caixa de som',
        categoria: 'Áudio',
        quantidadeDisponivel: 0,
        quantidadeMinima: 0,
      );

      expect(material.situacao, 'Sem estoque');
    });

    test('identifica estoque baixo e adequado', () {
      final baixo = MaterialEvento(
        nome: 'Cabo',
        categoria: 'Áudio',
        quantidadeDisponivel: 2,
        quantidadeMinima: 3,
      );
      final adequado = MaterialEvento(
        nome: 'Projetor',
        categoria: 'Vídeo',
        quantidadeDisponivel: 3,
        quantidadeMinima: 3,
      );

      expect(baixo.situacao, 'Estoque baixo');
      expect(adequado.situacao, 'Estoque adequado');
    });
  });
}
