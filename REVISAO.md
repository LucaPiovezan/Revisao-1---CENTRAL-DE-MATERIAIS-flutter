
# Revisão 1 — Central de Materiais

## Testes realizados

| Teste | Resultado esperado | Resultado obtido |
|---|---|---|
| Nome somente com espaços | Exibir erro de campo obrigatório | Pendente |
| Quantidade negativa | Recusar o valor | Pendente |
| Quantidade decimal | Recusar o valor | Pendente |
| Cadastrar dois materiais | Ambos aparecem na lista | Pendente |
| Editar e recarregar | Alteração permanece salva | Pendente |
| Cancelar exclusão | Material permanece cadastrado | Pendente |
| Excluir um material | Apenas o selecionado é removido | Pendente |
| Quantidade zero | Sem estoque | Pendente |
| Quantidade abaixo do mínimo | Estoque baixo | Pendente |
| Quantidade igual ao mínimo | Estoque adequado | Pendente |
| Nome duplicado | Impedir o cadastro | Pendente |

## Explicação de uma validação

Escolhi a validação de nome obrigatório.

Arquivo: lib/utils/validadores.dart

Método: textoObrigatorio()

Essa validação verifica se o nome está vazio ou
contém apenas espaços, utilizando trim().isEmpty.

Esse arquivo é adequado porque centraliza as
validações dos campos, permitindo que elas sejam
reutilizadas em diferentes partes do aplicativo.
